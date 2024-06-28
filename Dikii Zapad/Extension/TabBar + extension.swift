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
        case logs = 5
    }
    
    func setBageValue(_ item: TabItem, value: Int) {
        guard let index = items?.firstIndex(where: { $0.tag == item.rawValue }) else { return }
        
        items?[index].badgeValue = value == 0 ? "" : "\(value)"
        
        if value == 0 {
            items?[index].badgeColor = .clear
        } else {
            items?[index].badgeColor = .systemRed
        }
    }
}
