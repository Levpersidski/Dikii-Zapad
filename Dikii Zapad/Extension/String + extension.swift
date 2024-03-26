//
//  String + extension.swift
//  Dikii Zapad
//
//  Created by mac on 24.02.2024.
//

import Foundation


extension String {
    func maskAsPhone() -> String {
        guard self.length == 11 else {
            return self
        }
        let operatorCode = substring(from: 1, to: 4)
        let base = substring(from: 4, to: 7)
        let first = substring(from: 7, to: 9)
        let second = substring(from: 9, to: 11)
        return "+7 (\(operatorCode)) \(base)-\(first)-\(second)"
    }
    
    func substring(from: Int, to: Int) -> String {
        let range = Range<Int>.init(uncheckedBounds: (from, to))
        return self[range]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    var length: Int {
        return self.count
    }
    
    var numbers: String {
        return filter { "0"..."9" ~= $0 }
    }
}
