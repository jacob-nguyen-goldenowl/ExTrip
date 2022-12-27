//
//  Date+Utilities.swift
//  Fastis
//
//  Created by Ilya Kharlamov on 14.04.2020.
//  Copyright © 2020 DIGITAL RETAIL TECHNOLOGIES, S.L. All rights reserved.
//

import Foundation

internal extension Date {

    func startOfMonth(in calendar: Calendar = .current) -> Date {
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: calendar.startOfDay(for: self))) ?? Date()
        return startOfMonth.startOfDay(in: calendar)
    }

    func endOfMonth(in calendar: Calendar = .current) -> Date {
        let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth(in: calendar)) ?? Date()
        return endOfMonth.endOfDay(in: calendar)
    }

    func isInSameDay(in calendar: Calendar = .current, date: Date) -> Bool {
        return calendar.isDate(self, equalTo: date, toGranularity: .day)
    }

    func isInSameMonth(in calendar: Calendar = .current, date: Date) -> Bool {
        return calendar.component(.month, from: self) == calendar.component(.month, from: date)
    }

    func startOfDay(in calendar: Calendar = .current) -> Date {
        return calendar.date(bySettingHour: 0, minute: 0, second: 0, of: self) ?? Date()
    }

    func endOfDay(in calendar: Calendar = .current) -> Date {
        return calendar.date(bySettingHour: 23, minute: 59, second: 59, of: self) ?? Date()
    }

}

extension Date {
    
    var monthString: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM"
            return dateFormatter.string(from: self)
        }
    }
    
    var dateString: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return dateFormatter.string(from: self)
        }
    }
    
    var displayDateString: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE M/dd/yy"
            return dateFormatter.string(from: self)
        }
    }

}
