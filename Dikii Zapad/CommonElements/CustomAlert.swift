//
//  CustomAlert.swift
//  Dikii Zapad
//
//  Created by mac on 24.02.2024.
//

import UIKit
import EasyPeasy

struct CustomAlertViewModel {
    var title: String = ""
    var subtitle: String = ""
    var hasTextField: Bool = false
    
    var titleButton: String = ""
    var actionButton: (() -> Void)? = nil
}

class CustomAlert: UIView {
    
    var model: CustomAlertViewModel {
        didSet {            
            titleLabel.text = model.title
            subtitleLabel.text = model.subtitle
            textField.isHidden = !model.hasTextField
            actionButton.isHidden = model.titleButton.isEmpty
            actionButton.setTitle(model.titleButton, for: .normal)
        }
    }
    
    private var bottomContainerConstraint: NSLayoutConstraint!
    private var offset: CGFloat = 0
    private var screenHeight: CGFloat = UIScreen.main.bounds.height
    private var isClosing: Bool = false
    
    private lazy var overlayView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.isUserInteractionEnabled = true
        blurredEffectView.alpha = 0
        blurredEffectView.addTapGesture { [weak self] _ in
            self?.close()
        }
        return blurredEffectView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.roundCorners(24)
        return view
    }()
    
    private lazy var logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.roundCorners(13.5)
        imageView.image = UIImage(named: "LogoAlert")?.withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .center
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = model.title
        lbl.font = UIFont(name: "Capture it", size: 22)
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = model.subtitle
        lbl.font = .systemFont(ofSize: 20, weight: .medium)
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private lazy var textField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Ваше имя"
        textField.autocorrectionType = .no
        textField.isHidden = !model.hasTextField
        textField.delegate = self
        return textField
    }()
    
    private  lazy var actionButton: UIButton = {
        let button  = UIButton(type: .system)
        button.maskCorners(radius: 15)
        button.isHidden = model.titleButton.isEmpty
        button.setTitle(model.titleButton, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        button.addTarget(self, action: #selector(actionButtonDidTap), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32 , height: 54)
        button.applyGradient(fromColor: UIColor(hex: "FF5929"),
                             toColor: UIColor(hex: "993C1F"),
                             fromPoint: CGPoint(x: 0.5, y: 0),
                             toPoint: CGPoint(x: 0.5, y: 1),
                             location: [0, 1])
        
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let btn = UIButton()
        btn.contentMode = .center
        btn.setImage(UIImage(named: "closeAlert")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(closeButtonDidTap), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Init
    init(model: CustomAlertViewModel) {
        self.model = model
        super.init(frame: .zero)
        backgroundColor = .clear
        setupViews()
        setupConstraints()
        addObserverKeyboard()
    }
    
    deinit {
        removeObserverKeyboard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //  MARK: - Public
    @discardableResult
    public static func open(in view: UIView, model: CustomAlertViewModel, offset: CGFloat = 0) -> CustomAlert {
        var productView: CustomAlert
        if let existingView = view.subviews.first(where: { $0 is CustomAlert }) as? CustomAlert {
            existingView.model = model
            productView = existingView
        } else {
            productView = CustomAlert(model: model)
        }
        productView.offset = offset
        productView.open(in: view)
        return productView
    }
    
    @discardableResult
    public static func close(from view: UIView) -> CustomAlert? {
        if let view = view.subviews.first(where: { $0 is CustomAlert }),
           let productView = view as? CustomAlert {
            productView.close()
            return productView
        } else {
            return nil
        }
    }
    
    func open(in view: UIView) {
        if self.superview == nil {
            view.addSubview(self)
            self.easy.layout(Edges())
        }
        
        view.layoutIfNeeded()
            bottomContainerConstraint.constant = -self.offset
            UIView.springAnimate {
                self.layoutSubviews()
                self.overlayView.alpha = 1
            }
    }
    
    func close() {
        guard !isClosing else {
            return
        }
        
        isClosing = true
        
        self.bottomContainerConstraint.constant = screenHeight
        UIView.animate(withDuration: 0.27, animations: {
            self.layoutSubviews()
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.alpha = 0
            } completion: { _ in
                self.isClosing = false
                self.removeFromSuperview()
            }
        }
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        addSubviews(
            overlayView,
            containerView
        )
        
        containerView.addSubviews(
            closeButton,
            logoImage,
            titleLabel,
            subtitleLabel,
            textField,
            actionButton
        )
    }
    
    private func setupConstraints() {
        overlayView.easy.layout(
            Edges()
        )
        containerView.easy.layout(
            Left(32), Right(32), Height(>=320)
        )
        
        bottomContainerConstraint = containerView.easy.layout(CenterY(-screenHeight)).first
        
        closeButton.easy.layout(
            Top(25), Right(16), Size(34)
        )
        
        logoImage.easy.layout(
            Top(30),
            CenterX(),
            Width(167), Height(68)
        )
        
        titleLabel.easy.layout(
            Top(30).to(logoImage, .bottom),
            Left(16),
            Right(16)
        )
        
        subtitleLabel.easy.layout(
            Top(25).to(titleLabel, .bottom),
            Left(16),
            Right(16),
            Bottom(62)
        )
        
        textField.easy.layout(
            Top(25).to(titleLabel, .bottom),
            Left(16),
            Right(16),
            Height(40)
        )
        
        actionButton.easy.layout(
            Bottom(16),
            Left(20),
            Right(20),
            Height(40)
        )
    }
    
    @objc
    private func closeButtonDidTap() {
        close()
    }
    
    @objc
    private func actionButtonDidTap() {
        DataStore.shared.name = textField.text
        close()
        model.actionButton?()
    }
    
    private func addObserverKeyboard() {
        NotificationCenter.default.addObserver( self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver( self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeObserverKeyboard() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func kbWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let kbFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        bottomContainerConstraint.constant = -self.offset - kbFrameSize.height / 2
        UIView.animate(withDuration: 0.27, animations: {
            self.layoutSubviews()
        })
    }
    
    @objc private func kbWillHide() {
        
        bottomContainerConstraint.constant = -self.offset
        UIView.animate(withDuration: 0.27, animations: {
            self.layoutSubviews()
        })
    }
}

extension CustomAlert: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        close()
        model.actionButton?()
        return true
    }
}
