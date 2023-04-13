//
//  UserManager.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 14/12/2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class UserManager {
    
    static let shared = UserManager()
    private init() {}
    
    private let db = Firestore.firestore()
    private let userDefault = UserDefaults.standard
    
    func saveUserGoogle(_ user: User) {
        UserDefaults.standard.set(user.uid, forKey: UserDefaultKey.userId)
        UserDefaults.standard.set(user.email, forKey: UserDefaultKey.userEmail)
        UserDefaults.standard.set(user.photoURL?.absoluteString, forKey: UserDefaultKey.userPhotoURL)
        UserDefaults.standard.set(user.displayName, forKey: UserDefaultKey.userName)
    }

    func saveUserInfo(_ uid: String) {
        let docRef = db.collection("users").document(uid)
        
        docRef.getDocument { [self] (document, _) in
            if let document = document?.data() {
                userDefault.set(uid, forKey: UserDefaultKey.userId)
                userDefault.set(document["email"], forKey: UserDefaultKey.userEmail)
                userDefault.set(document["name"], forKey: UserDefaultKey.userName)
                userDefault.set(document["image"], forKey: UserDefaultKey.userPhotoURL)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func removeUserInfo() {
        userDefault.removeObject(forKey: UserDefaultKey.userId)
        userDefault.removeObject(forKey: UserDefaultKey.userEmail)
        userDefault.removeObject(forKey: UserDefaultKey.userName)
        userDefault.removeObject(forKey: UserDefaultKey.userPhotoURL)
    }
    
    func getUserInfo() -> UserInfoModel? {
        let userEmail = userDefault.string(forKey: UserDefaultKey.userEmail)
        let userName = userDefault.string(forKey: UserDefaultKey.userName)
        let userImage = userDefault.string(forKey: UserDefaultKey.userPhotoURL)
        
        return UserInfoModel(email: userEmail,
                             name: userName,
                             image: userImage)
    }
    
    func getUserId() -> String? {
        return userDefault.string(forKey: UserDefaultKey.userId)
    }
}
