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
    
    func login(email: String, password: String, completion: @escaping(Bool) -> Void) {
        Auth.auth().signIn(withEmail: email,
                           password: password) { res, error in
            guard error == nil else { 
                completion(false)
                return 
            }
            if Auth.auth().currentUser != nil {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func removeChild(completion:@escaping()->()){
        let ref = Database.database().reference()
        ref.child(UIDevice.current.identifierForVendor!.uuidString).removeValue()
    }
    
    func register(with info: RegisterModel, completion: @escaping (Bool) -> Void) {
        
    }
    
}
