//
//  UIStackView + Extension.swift
//  Dikii Zapad
//
//  Created by mac on 28.01.2024.
//

import UIKit

extension UIStackView {
    func setCustomSpacingAfterLastView(_ spacing: CGFloat) {
        guard let view = self.arrangedSubviews.last else { return }
        self.setCustomSpacing(spacing, after: view)
    }
}
