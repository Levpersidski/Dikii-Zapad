//
//  GradientButton.swift
//  Dikii Zapad
//
//  Created by Glushchenko on 30.05.2024.
//

import UIKit

final class GradientButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        applyGradient(
            fromColor: UIColor(hex: "FF5929"),
            toColor: UIColor(hex: "993C1F"),
            fromPoint: CGPoint(x: 0.5, y: 0),
            toPoint: CGPoint(x: 0.5, y: 1),
            location: [0, 1]
        )
    }
}
