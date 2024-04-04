//
//  SkeletonView.swift
//  Dikii Zapad
//
//  Created by Glushchenko on 04.04.2024.
//


import UIKit

class SkeletonView: UIView {

    var startLocations: [NSNumber] = [-1.0, -0.5, 0.0]
    var endLocations: [NSNumber] = [1.0, 1.5, 2.0]

    var gradientBackgroundColor: CGColor = UIColor.black.cgColor
    var gradientMovingColor: CGColor = UIColor.white.cgColor

    var movingAnimationDuration: CFTimeInterval = 0.8
    var delayBetweenAnimationLoops: CFTimeInterval = 1.0

    lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [
            gradientBackgroundColor,
            gradientMovingColor,
            gradientBackgroundColor
        ]

        gradientLayer.locations = startLocations
        self.layer.addSublayer(gradientLayer)
        return gradientLayer
    }()

    func startAnimating() {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = startLocations
        animation.toValue = endLocations
        animation.duration = movingAnimationDuration
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        let animationGroup = CAAnimationGroup()
        animationGroup.duration = movingAnimationDuration + delayBetweenAnimationLoops
        animationGroup.animations = [animation]
        animationGroup.repeatCount = .infinity
        animationGroup.isRemovedOnCompletion = false

        gradientLayer.add(animationGroup, forKey: animation.keyPath)
    }

    func stopAnimating() {
        gradientLayer.removeAllAnimations()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
