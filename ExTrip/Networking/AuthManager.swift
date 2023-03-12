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

class AuthManager {
        
    // Singleton
    static let shared = AuthManager()

    private init() {}
    
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
    
    func getCurrentUserID() -> String {
        guard let userID = Auth.auth().currentUser?.uid else { return "" }
        return userID
    }

}
