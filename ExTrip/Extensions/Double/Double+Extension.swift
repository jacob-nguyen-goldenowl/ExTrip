//
//  Double+Extension.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 01/03/2023.
//

import Foundation

extension Double {
    func roundDouble() -> Double {
        return (self * 1000).rounded() / 1000
    }
    
    func toCurrency() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: "en_US")
        return numberFormatter.string(from: NSNumber(value: self)) ?? "---"
    }
}
