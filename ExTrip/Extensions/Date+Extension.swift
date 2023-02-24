//
//  Date+Extension.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 08/02/2023.
//

import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore
import FirebaseFirestoreSwift

extension Date {
    func isEqualTo(_ date: Date) -> Bool {
        return self == date
    }
    
    func isGreaterThan(_ date: Date) -> Bool {
        return self > date
    }
    
    func isLessThan(_ date: Date) -> Bool {
        return self < date
    }
    
    func isGreaterThanOrEqualTo(_ date: Date) -> Bool {
        return self >= date
    }
    
    func isLessThanOrEqualTo(_ date: Date) -> Bool {
        return self <= date
    }
    
    func dateToTimestamp() -> Timestamp {
        return Timestamp(date: self)
    }
}

extension Timestamp {
    func timestampToDate() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self.seconds))
    } 
}

