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
    private let fontPlaceholder: UIFont = UIFont.systemFont(ofSize: 16)
    
    private var oldText: String? = nil

    
    var fontText: UIFont = UIFont.systemFont(ofSize: 16) {
        didSet {
            font = fontText
            maskLabel.font = fontText
        }
    }
    
    var visibleMask: String = ""
    
    private lazy var maskLabel: UILabel = {
        let label = UILabel()
        label.textColor = colorPlaceholderText.withAlphaComponent(0.4)
        label.font = fontText
        label.isHidden = true
        return label
    }()
    
    override var placeholder: String? {
        didSet {
            attributedPlaceholder = NSAttributedString(
                string: placeholder ?? "",
                attributes: [
                    .foregroundColor: colorPlaceholderText,
                    .font: fontPlaceholder
                ]
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
        
        self.addSubviews(containerView, maskLabel)
        containerView.easy.layout(
            Edges(), Height(59)
        )
        
        maskLabel.easy.layout(
            Top(),
            Left(insets.left), Right(insets.right),
            Bottom()
        )
        
        textColor = colorText
        addTarget(self, action: #selector(handleEditingDidBegin), for: .editingDidBegin)
//        addObserver(self, forKeyPath: "text", options: NSKeyValueObservingOptions.new, context: nil)
        addTarget(self, action: #selector(handleEditingDidBegin), for: .editingChanged)

    }
    
    deinit {
//        removeObserver(self, forKeyPath: "text")
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
    
    func showError() {
        containerView.layer.borderColor = UIColor.red.cgColor
    }
    
    func hideError() {
        containerView.layer.borderColor = UIColor.orange.cgColor
    }
    
    private func displayMaskLabelIfNeeded() {
        if let text = text, !text.isEmpty, !visibleMask.isEmpty {
            maskLabel.isHidden = false
        } else {
            maskLabel.isHidden = true
        }
    }
    
    func setupMaskText() {
        let text = text ?? ""
        
        guard text.count <= visibleMask.count else { return }
        
        let maskText = visibleMask
        if !maskText.isEmpty {
            let attr = NSMutableAttributedString(string: maskText,
                                                 attributes: [.font : text.isEmpty ? fontPlaceholder : fontText])
            attr.addAttributes([.foregroundColor : colorPlaceholderText],
                               range: NSRange(location: 0, length: maskText.count))
            attr.addAttributes([.foregroundColor : UIColor.clear],
                               range: NSRange(location: 0, length: text.count))
            maskLabel.attributedText = attr
        } else {
            maskLabel.font = fontPlaceholder
        }
    }
    
    
    @objc private func handleEditingDidBegin() {
        displayMaskLabelIfNeeded()
        setupMaskText()
    }
    
    override internal func observeValue(forKeyPath keyPath: String?,
                                       of object: Any?,
                                       change: [NSKeyValueChangeKey : Any]?,
                                       context: UnsafeMutableRawPointer?) {
        guard let key = keyPath, key == "text",
            let sourceTextField = object as? UITextField, self == sourceTextField,
            oldText != text
        else {
            return
        }
        
        setupMaskText()
    }
}
