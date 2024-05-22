//
//  TabBar + extension.swift
//  Dikii Zapad
//
//  Created by Glushchenko on 22.05.2024.
//

import UIKit

extension UITabBar {
    enum TabItem: Int {
        case main = 0
        case sales = 1
        case contacts = 2
        case vacancies = 3
        case cart = 4
    }
    
    func setBageValue(_ item: TabItem, value: Int) {
        let indexTab = item.rawValue
        items?[indexTab].badgeValue = value == 0 ? "" : "\(value)"
        
        if value == 0 {
            items?[indexTab].badgeColor = .clear
        } else {
            items?[indexTab].badgeColor = .systemRed
        }
    }
}
