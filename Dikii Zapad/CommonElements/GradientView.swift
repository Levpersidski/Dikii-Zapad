//
//  GradientView.swift
//  Dikii Zapad
//
//  Created by mac on 28.01.2024.
//

import UIKit

class GradientView: UIView {
    var gradientLayer: CAGradientLayer {
        return self.layer as! CAGradientLayer
    }

    override class var layerClass: AnyClass {
        CAGradientLayer.self
    }

    func applyGradient(fromColor: UIColor, toColor: UIColor, fromPoint: CGPoint, toPoint: CGPoint) {
        self.gradientLayer.bounds = self.bounds
        self.gradientLayer.startPoint = fromPoint
        self.gradientLayer.endPoint = toPoint
        self.gradientLayer.colors = [fromColor.cgColor, toColor.cgColor]
        self.gradientLayer.locations = [0.0, 1.0]
    }
    
    func applyGradient(colors: [UIColor], at: [NSNumber], from: CGPoint, to: CGPoint) {
        self.gradientLayer.bounds = self.bounds
        self.gradientLayer.startPoint = from
        self.gradientLayer.endPoint = to
        self.gradientLayer.colors = colors.map({ $0.cgColor })
        self.gradientLayer.locations = at
    }

    override func layoutSublayers(of layer: CALayer) {
        guard layer === self.layer else {
            return
        }

        layer.bounds = self.bounds
    }
}
