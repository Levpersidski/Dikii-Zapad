//
//  Date + extension.swift
//  Dikii Zapad
//
//  Created by mac on 25.02.2024.
//

import Foundation


extension Date {
   func plus(days: Int? = nil, hours: Int? = nil, minutes: Int? = nil) -> Date? {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .hour, .day, .minute], from: self)
        if let days {
            components.day = (components.day ?? 0) + days
        }
        if let hours {
            components.hour = (components.hour ?? 0) + hours
        }
        if let minutes {
            components.minute = (components.minute ?? 0) + minutes
        }
        return calendar.date(from: components)
    }
    
    func set(days: Int? = nil, hours: Int? = nil, minutes: Int? = nil) -> Date? {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .hour, .day, .minute], from: self)
        if let days {
            components.day = days
        }
        if let hours {
            components.hour = hours
        }
        if let minutes {
            components.minute = minutes
        }
        return calendar.date(from: components)
    }
    
    func string(format: String, isMoscowTimezone: Bool = false) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ru_RU")
        if isMoscowTimezone {
            formatter.timeZone = TimeZone(abbreviation: "MSK")!
        }
        return formatter.string(from: self)
    }
}
