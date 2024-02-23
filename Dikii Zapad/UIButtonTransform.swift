//
//  UIButtonTransform.swift
//  Dikii Zapad
//
//  Created by mac on 23.02.2024.
//

import UIKit

class UIButtonTransform: UIButton {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animate()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animateIdentity()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animateIdentity()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
         super.touchesMoved(touches, with: event)
         
         if let touch = touches.first {
             let touchLocation = touch.location(in: self)
             if !self.bounds.contains(touchLocation) {
                 // Палец увел далеко от кнопки
                 if self.subviews.first?.transform.isIdentity == false {
                     animateIdentity()
                 }
             } else {
                 if self.subviews.first?.transform.isIdentity == true {
                     animate()
                 }
             }
         }
     }
    
    private func animate() {
        UIView.animate(withDuration: 0.2) {
            self.subviews.first?.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
            self.subviews.first?.alpha = 0.7
        }
    }
    
    private func animateIdentity() {
        UIView.animate(withDuration: 0.2) {
            self.subviews.first?.transform = .identity
            self.subviews.first?.alpha = 1
        }
    }
}
