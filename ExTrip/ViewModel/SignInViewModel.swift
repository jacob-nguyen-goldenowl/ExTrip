//
//  SignInViewModel.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 12/12/2022.
//

import UIKit

class SignInViewModel {
    
    var errorMessage: Observable<String?> = Observable(nil)
    
    func login(email: String, password: String) {
        AuthManager.shared.login(email: email, password: password) { success in
            DispatchQueue.main.async { [weak self] in
                self?.errorMessage.value = success ? nil : "Invalid email or password"
            }
        }
    }
}
