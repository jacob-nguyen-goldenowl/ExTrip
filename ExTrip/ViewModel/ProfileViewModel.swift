//
//  ProfileViewModel.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 02/03/2023.
//

import Foundation

class ProfileViewModel {
    
    var userName = UserDefaults.standard.string(forKey: UserDefaultKey.userName)
    var avatarURL = UserDefaults.standard.string(forKey: UserDefaultKey.userPhotoURL)
    var userID = UserManager.shared.getUserId()

    func signOut(completion: @escaping (Error?) -> Void) {
        AuthManager.shared.signOut { result in
            switch result {
            case .success(_):
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
}
