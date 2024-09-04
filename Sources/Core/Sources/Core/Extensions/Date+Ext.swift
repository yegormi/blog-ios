//
//  Date+Ext.swift
//  Spendbase
//
//  Created by Larik on 26.10.2023.
//

import Foundation

extension Date {
    /// Creates formatted string of month and day
    /// Example: Oct 6, Jan 30, Mar 1
    var shortMonthDay: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        return formatter.string(from: self)
    }
    
    var shortYearMonthDay: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        return formatter.string(from: self)
    }
    
    var transactionDetailsDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy 'at' HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        return formatter.string(from: self)
    }
}
