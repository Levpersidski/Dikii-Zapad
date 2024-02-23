//
//  UIView + extension.swift
//  Dikii Zapad
//
//  Created by Роман Бакаев on 26.09.2023.
//

import UIKit

//MAAK: - extension View
extension UIView {
    func addSubviews(_ views: UIView...) {
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
    
    func roundCorners(_ radius: CGFloat = 8.0) {
        layer.masksToBounds = true
        layer.cornerRadius = radius
        layer.mask = nil
        
        if #available(iOS 13.0, *) {
            layer.cornerCurve = .continuous
        }
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
    
    @discardableResult
    func addLongPressGesture(with closure: @escaping (UILongPressGestureRecognizer) -> ()) -> UIGestureRecognizer {
        isUserInteractionEnabled = true
        let rec = ClosureLongPressGestureRecognizer(action: closure)
        self.addGestureRecognizer(rec)
        return rec
    }
    
    @discardableResult
    func addPanGesture(with closure: @escaping (UIPanGestureRecognizer) -> ()) -> UIGestureRecognizer {
        isUserInteractionEnabled = true
        let rec = ClosurePanGestureRecognizer(action: closure)
        self.addGestureRecognizer(rec)
        return rec
    }
}

extension UIView {
    func applyGradient(fromColor: UIColor, toColor: UIColor, fromPoint: CGPoint, toPoint: CGPoint, location: [NSNumber]) {
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [fromColor.cgColor, toColor.cgColor]
        gradient.locations = location
        gradient.startPoint = fromPoint
        gradient.endPoint = toPoint
        self.layer.insertSublayer(gradient, at: 0)
    }
}
