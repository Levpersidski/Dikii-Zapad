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
    
    func fadeIn(_ duration: TimeInterval = 0.2, onCompletion: (() -> Void)? = nil) {
        self.alpha = 0
        self.isHidden = false
        UIView.animate(withDuration: duration,
                       animations: { self.alpha = 1 },
                       completion: { (_: Bool) in
            self.isHidden = false
            if let complete = onCompletion { complete() }
        }
        )
    }
    
    func fadeOut(_ duration: TimeInterval = 0.2, onCompletion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration,
                       animations: { self.alpha = 0 },
                       completion: { (_: Bool) in
            self.isHidden = true
            if let complete = onCompletion { complete() }
        }
        )
    }
    
    ///Этот метод закругляет углы не задавая новую максу CAShapeLayer(). А только редактирует. Это позволяет избежать бага отображением subviews
    func maskCorners(radius: CGFloat, _ corners: UIRectCorner = .allCorners) {
        var cornerMasks = CACornerMask()
        if corners.contains(.allCorners) {
            cornerMasks.insert(.layerMinXMinYCorner)
            cornerMasks.insert(.layerMaxXMinYCorner)
            cornerMasks.insert(.layerMinXMaxYCorner)
            cornerMasks.insert(.layerMaxXMaxYCorner)
        }
        if corners.contains(.topLeft) {
            cornerMasks.insert(.layerMinXMinYCorner)
        }
        if corners.contains(.topRight) {
            cornerMasks.insert(.layerMaxXMinYCorner)
        }
        if corners.contains(.bottomLeft) {
            cornerMasks.insert(.layerMinXMaxYCorner)
        }
        if corners.contains(.bottomRight) {
            cornerMasks.insert(.layerMaxXMaxYCorner)
        }
        
        layer.maskedCorners = cornerMasks
        layer.cornerRadius = radius
        clipsToBounds = true
    }
    
}
    extension UIScrollView {
        func addToScrollView(_ views: UIView...) {
            views.forEach { addSubview($0) }
        }
}

//UIView + TapGestuere
extension UIView {
    @discardableResult
    func addTapGesture(with closure: @escaping (UIGestureRecognizer.State) -> ()) -> UIGestureRecognizer {
        isUserInteractionEnabled = true
        let rec = ClosureTapGestureRecognizer(action: closure)
        self.addGestureRecognizer(rec)
        return rec
    }
}
