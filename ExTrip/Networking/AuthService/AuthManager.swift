//
//  AuthManager.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 12/12/2022.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore
import FirebaseCore
import GoogleSignIn

class AuthManager {
        
    // Singleton
    static let shared = AuthManager()

    private init() {}
    
    enum AuthenticationError: Error {
        case signInError(message: String)
        case tokenError(message: String)
        case clientError(message: String)
    }
    
    // MARK: - Login 
    func login(email: String, password: String, completion: @escaping(ResultInt, StatusCode) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (_, error)in
            guard error == nil else { 
                completion(.failed,
                           .loginFailed)
                return 
            }
            if let user = Auth.auth().currentUser {
                UserManager.shared.saveUserInfo(user.uid)
                completion(.success,
                           .loginSuccess)
            } else {
                completion(.failed,
                           .requestFailed)
            }
        }
    }
    
    // MARK: - Register
    func register(with info: UserInfoModel, password: String, completion: @escaping (ResultInt, StatusCode) -> Void) {
        guard let email = info.email, let name = info.name else { return }
        // Check email existing yet
        DatabaseManager.shared.canCreateNewUser(with: email, username: name) { canCreate in
            if canCreate {
                Auth.auth().createUser(withEmail: email, password: password) { result, error in 
                    
                    guard result != nil, error == nil else { 
                        completion(.failed,
                                   .registerFailed)
                        return 
                    }
                    
                    guard let uid = result?.user.uid else { return }
                    
                    // Insert into database
                    DatabaseManager.shared.insertNewUser(with: info, uid: uid) { success in 
                        if success {
                            UserManager.shared.saveUserInfo(uid)
                            completion(.success,
                                       .registerSuccess)
                            return
                        } else {
                            completion(.failed,
                                       .insertUserFailed)
                            return
                        }
                    }
                }
            } else {
                    // Email or password does not exit
                completion(.failed,
                           .insertUserFailed)
            }
        }
    }
    
    func loginWithGoogle(with viewController: UIViewController, completion: @escaping (Error?) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion(AuthenticationError.clientError(message: "No client ID found in Firebase configuration"))
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
            guard error == nil, let result = result else {
                completion(AuthenticationError
                    .signInError(message: "Error"))
                return
            }
            
            let user = result.user
            
            guard let idToken = user.idToken else {
                completion(AuthenticationError.tokenError(message: "Id token missing"))
                return
            }
            
            let accessToken = user.accessToken
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                           accessToken: accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { _, error in
                guard error == nil else {
                    completion(AuthenticationError
                        .signInError(message: "Somthing error when login"))
                    return
                }
                if let currentUser = Auth.auth().currentUser {
                    UserManager.shared.saveUserGoogle(currentUser)
                }
                completion(nil)
            }
        }
    }
    
    func currentUser() -> User? {
        guard let currentUser = Auth.auth().currentUser else {
            return nil
        }
        return currentUser
    }
    
    func signOut(completion: @escaping (Result<Bool, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            resetDefaults()
            completion(.success(true))
        } catch let error as NSError {
            completion(.failure(error))
        }
        UserManager.shared.removeUserInfo()
    }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    func getCurrentUserID() -> String {
        guard let userID = Auth.auth().currentUser?.uid else { return "" }
        return userID
    }

}
