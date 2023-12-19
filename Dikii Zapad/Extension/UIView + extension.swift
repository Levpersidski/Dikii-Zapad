//
//  UIView + extension.swift
//  Dikii Zapad
//
//  Created by Роман Бакаев on 26.09.2023.
//

import UIKit

//MAAK: - extension View
extension UIView {
    func addSubViews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
    extension UIScrollView {
        func addToScrollView(_ views: UIView...) {
            views.forEach { addSubview($0) }
        }
}
