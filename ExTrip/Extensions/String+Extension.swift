//
//  String+Extension.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 13/12/2022.
//

import UIKit

extension String {
    // MARK: - Check email format
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    // MARK: - Check is number
    func isNumber() -> Bool {
            // 3 numbers, then 3 numbers, then 4 numbers
            // The first 3 numbers may be enclosed in (), and either 
            // " " or "-" can be used to separate number groups
        let phonePattern = #"^\(?\d{3}\)?[ -]?\d{3}[ -]?\d{4}$"#
        let result = self.range(
            of: phonePattern,
            options: .regularExpression
        )
        return result != nil ? true : false
    }
}
