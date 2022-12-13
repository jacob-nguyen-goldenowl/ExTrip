//
//  SignUpViewModel.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 12/12/2022.
//

import Foundation

class SignUpViewModel {
    
    var error: Observable<String?> = Observable(nil)
    var success: Observable<String?> = Observable(nil)
    
    func register(info: UserInfoModel, password: String) {
        AuthManager.shared.register(with: info, password: password) { status, msg in
            DispatchQueue.main.async { [weak self] in 
                if status == 0 {
                    self?.error.value = msg
                } else {
                    self?.success.value = msg
                }
            }
        }
    }
    
}
