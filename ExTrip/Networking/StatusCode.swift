//
//  StatusCode.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 13/12/2022.
//

import Foundation

enum StatusCode {
    case loginFailed
    case loginSuccess
    case requestFailed
    case registerFailed
    case registerSuccess
    case insertUserFailed
    case insertUserSuccess
    
    var statusDescription: String {
        switch self {
            case .loginFailed:
                return "The mail and password is incorrect"
            case .loginSuccess:
                return "Login successful"
            case .requestFailed:
                return "Something error when login"
            case .registerFailed:
                return "User with email already exists"
            case .registerSuccess:
                return "Create user successful"
            case .insertUserFailed:
                return "Insert user failed"
            case .insertUserSuccess:
                return "Insert user unsuccessful"
        }
    }
}

enum ResultInt: Int {
    case success = 1
    case failed = 0
}

