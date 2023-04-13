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
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    var updateLoadingStatus: (() -> Void)?
    var navigationClosure: (() -> Void)?
    var alertMessageClosure: (() -> Void)?
    
    func loginWithGoogle(viewController: UIViewController) {
        isLoading = true
        AuthManager.shared.loginWithGoogle(with: viewController) { [weak self] error in
            if error != nil {
                self?.alertMessageClosure?()
            } else {
                self?.signInNotify()
                self?.navigationClosure?()
            }
            self?.isLoading = false
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
