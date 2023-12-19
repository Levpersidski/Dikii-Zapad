//
//  UIColorExtension.swift
//  Dikii Zapad
//
//  Created by Роман Бакаев on 03.10.2023.
//

import UIKit

extension UIColor {
    static var  tabBarItemAccent: UIColor {
        #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
    }
    static var  mainMilk: UIColor {
        #colorLiteral(red: 0.9998105168, green: 0.9952459931, blue: 0.8368335366, alpha: 1).withAlphaComponent(0.2)
    }
    static var  tabBarItemlight: UIColor {
        #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
    }
    
    static var  customOrange: UIColor {
        UIColor(hex: "#FE6F1F")
    }
    
    static var customGrey: UIColor {
        UIColor(hex: "333333")
    }
    
    static var customClearGray: UIColor {
        UIColor(hex: "1C1C1C")
    }
    
    
    
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }

}
