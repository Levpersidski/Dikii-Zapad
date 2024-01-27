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
