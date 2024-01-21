//
//  CustomRegisterTextfield.swift
//  Dikii Zapad
//
//  Created by Роман Бакаев on 10.10.2023.
//

import UIKit

//MARK: - RegisterTextField
final class CustomRegisterTextField: UITextField {
    
    //MARK: - Initilazer
    init(placeholder: String, isPrivate: Bool = false) {
        super.init(frame: .zero)
        setupTextField(placeholder: placeholder, isPrivate: isPrivate)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Methods
    private func setupTextField(placeholder: String, isPrivate: Bool) {
        textColor = .white
        
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.withAlphaComponent(0.8).cgColor
        layer.backgroundColor = UIColor.customClearGray.cgColor
        
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.7)])
        font = .boldSystemFont(ofSize: 18)
        heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        if isPrivate {
            isSecureTextEntry = true
        }
    }
}
