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
    
    var navigationClosure: (() -> Void)?
    var alertMessageClosure: ((Error) -> Void)?
    
    func loginWithGoogle(viewController: UIViewController) {
        AuthManager.shared.loginWithGoogle(with: viewController) { [weak self] error in
            if let error = error {
                self?.alertMessageClosure?(error)
            } else {
                // NOT FIX
                self?.signInNotify()
                self?.navigationClosure?()
            }
        }
    }
    
    func login(email: String, password: String) {
        AuthManager.shared.login(email: email, password: password) { status, msg in
            DispatchQueue.main.async { [weak self] in
                if status.rawValue == 0 {
                    self?.error.value = msg.statusDescription
                } else {
                    self?.signInNotify()
                    self?.success.value = msg.statusDescription
                }
            }
        }
    }
    
    func signInNotify() {
        NotificationCenter.default.post(name: NSNotification.Name(UserDefaultKey.loginsuccessNotify),  
                                        object: nil)
    }

    deinit { 
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(UserDefaultKey.loginsuccessNotify),
                                                  object: nil) 
    }
}
