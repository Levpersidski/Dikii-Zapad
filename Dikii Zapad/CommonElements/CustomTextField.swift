//
//  CustomTextField.swift
//  Dikii Zapad
//
//  Created by mac on 27.01.2024.
//

import UIKit
import EasyPeasy

final class CustomTextField: UITextField {
    
    private let insets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    private let colorText = UIColor(hex: "#F39578")
    private let colorPlaceholderText = UIColor(hex: "#892B0E")
    
    override var placeholder: String? {
        didSet {
            attributedPlaceholder = NSAttributedString(
                string: placeholder ?? "",
                attributes: [NSAttributedString.Key.foregroundColor: colorPlaceholderText]
            )
        }
    }
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor.orange.cgColor
        view.isUserInteractionEnabled = false
        view.layer.cornerRadius = 10
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(containerView)
        containerView.easy.layout(
            Edges(), Height(59)
        )
        
        textColor = colorText
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + insets.left,
                      y: bounds.origin.x + insets.top,
                      width: bounds.width - insets.left - insets.right,
                      height: bounds.height - insets.top - insets.bottom)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + insets.left,
                      y: bounds.origin.x + insets.top,
                      width: bounds.width - insets.left - insets.right,
                      height: bounds.height - insets.top - insets.bottom)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
