//
//  SignInViewModel.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 12/12/2022.
//

import UIKit

class SignInViewModel {
    
    var error: Observable<String?> = Observable(nil)
    var success: Observable<String?> = Observable(nil)

    func login(email: String, password: String) {
        AuthManager.shared.login(email: email, password: password) { status, msg in
            DispatchQueue.main.async { [weak self] in
                if status.rawValue == 0 {
                    self?.error.value = msg.statusDescription
                } else {
                    self?.success.value = msg.statusDescription
                }
            }
        }
    }
    
}
