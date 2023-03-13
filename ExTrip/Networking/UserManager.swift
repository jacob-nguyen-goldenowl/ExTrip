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

    func saveUserInfo(_ uid: String) {
        let docRef = db.collection("users").document(uid)
        
        docRef.getDocument { [self] (document, _) in
            if let document = document?.data() {
                userDefault.set(uid, forKey: UserDefaultKey.userId)
                userDefault.set(document["email"], forKey: UserDefaultKey.userEmail)
                userDefault.set(document["name"], forKey: UserDefaultKey.userName)
                userDefault.set(document["phone"], forKey: UserDefaultKey.userPhone)
                userDefault.set(document["state"], forKey: UserDefaultKey.userState)
                userDefault.set(document["image"], forKey: UserDefaultKey.userPhotoURL)
                userDefault.set(document["city"], forKey: UserDefaultKey.userCity)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func removeUserInfo() {
        userDefault.removeObject(forKey: UserDefaultKey.userId)
        userDefault.removeObject(forKey: UserDefaultKey.userEmail)
        userDefault.removeObject(forKey: UserDefaultKey.userName)
        userDefault.removeObject(forKey: UserDefaultKey.userPhone)
        userDefault.removeObject(forKey: UserDefaultKey.userPhotoURL)
        userDefault.removeObject(forKey: UserDefaultKey.userCity)
        userDefault.removeObject(forKey: UserDefaultKey.userState)
    }
    
    func getUserInfo() -> UserInfoModel? {
        let userEmail = userDefault.string(forKey: UserDefaultKey.userEmail)
        let userName = userDefault.string(forKey: UserDefaultKey.userName)
        let userState = userDefault.string(forKey: UserDefaultKey.userState)
        let userPhone = userDefault.string(forKey: UserDefaultKey.userPhone)
        let userCity = userDefault.string(forKey: UserDefaultKey.userCity)
        let userImage = userDefault.string(forKey: UserDefaultKey.userPhotoURL)
        
        return UserInfoModel(email: userEmail,
                             name: userName,
                             state: userState, 
                             city: userCity,
                             phone: userPhone,
                             image: userImage)
    }
    
    func getUserId() -> String? {
        return userDefault.string(forKey: UserDefaultKey.userId)
    }
}
