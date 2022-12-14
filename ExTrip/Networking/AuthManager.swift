//
//  AuthManager.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 12/12/2022.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AuthManager {
    
    // Singleton
    static let shared = AuthManager()
    private init() {}
    
    // MARK: - Login 
    func login(email: String, password: String, completion: @escaping(Result, StatusCode) -> Void) {
        Auth.auth().signIn(withEmail: email,
                           password: password) { res, error in
            guard error == nil else { 
                completion(.failed,
                           .loginFailed)
                return 
            }
            if Auth.auth().currentUser != nil {
                completion(.success,
                           .loginSuccess)
            } else {
                completion(.failed,
                           .requestFailed)
            }
        }
    }
    
    func removeChild(completion:@escaping()->()){
        let ref = Database.database().reference()
        ref.child(UIDevice.current.identifierForVendor!.uuidString).removeValue()
    }
    
    // MARK: - Register
    func register(with info: UserInfoModel, password: String , completion: @escaping (Result, StatusCode) -> Void) {

        // Check email existing yet
        DatabaseManager.shared.canCreateNewUser(with: info.email, username: info.name) { canCreate in
            if canCreate {
                Auth.auth().createUser(withEmail: info.email, password: password) { result, error in 
                    
                    guard result != nil, error == nil else { 
                        completion(.failed,
                                   .registerFailed)
                        return 
                    }
                    
                    guard let uid = result?.user.uid else { return }
                    
                    // Insert into database
                    DatabaseManager.shared.insertNewUser(with: info, uid: uid) { success in 
                        if success {
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
                // email or password does not exit
                completion(.failed,
                           .insertUserFailed)
            }
        }
    }
    
}
