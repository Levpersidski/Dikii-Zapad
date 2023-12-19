//
//  CustomButton.swift
//  LoginScreen
//
//  Created by brubru on 12.12.2022.
//

import UIKit
import EasyPeasy

final class CustomButton: UIButton {
    
    init(title: String, backgroundColor: UIColor, isShadow: Bool, titleColor: UIColor, tag: Int) {
        super.init(frame: .zero)

        setupSelfButton(title: title, backgroundColor: backgroundColor, isShadow: isShadow, titleColor: titleColor, tag: tag)
    }
    
    override var intrinsicContentSize: CGSize {
        let titleSize = titleLabel?.intrinsicContentSize ?? CGSize.zero
        let desiredWidth = titleSize.width + 30
        return CGSize(width: max(desiredWidth, 44), height: 35)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSelfButton(title: String, backgroundColor: UIColor, isShadow: Bool, titleColor: UIColor, tag: Int) {
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        setTitleColor(.gray, for: .highlighted)
        titleLabel?.font = .boldSystemFont(ofSize: 20)
        
        layer.cornerRadius = 10
        
        self.layer.borderColor = UIColor.customOrange.cgColor
        self.layer.borderWidth = 1
        
        self.easy.layout(
        Height(35)
        )

        // Присваиваем тег кнопке
        self.tag = tag
    }
}
