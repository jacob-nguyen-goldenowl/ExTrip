//
//  DatabaseManager.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 12/12/2022.
//

import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

class DatabaseManager {
    
    static let shared = DatabaseManager()
    private init() {}
    
    private let database = Database.database().reference()
    private let fireStore = Firestore.firestore()
    
    // Check user is existing
    public func canCreateNewUser(with email: String, username: String, completion: @escaping (Bool) -> Void) {
        database.child(email.safeDatabaseKey()).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.hasChild(email.safeDatabaseKey()) {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    // Insert new user
    public func insertNewUser(with info: UserInfoModel, uid: String , completion: @escaping(Bool) -> Void) {
        let users = fireStore.collection("users").document(uid)
                
        let data: [String: Any] = [
            "email": info.email,
            "name": info.name,
            "state": info.state,
            "city": info.city,
            "phone": info.phone,
            "image": info.image ?? ""
        ]
        
        users.setData(data) { error in 
            if error == nil {
                // success
                completion(true)
            } else {
                // failed
                completion(false)
            }
        }
    }
}

fileprivate extension String {
    func safeDatabaseKey() -> String {
        return self.replacingOccurrences(of: "@", with: "-").replacingOccurrences(of: ".", with: "-")
    }
}

