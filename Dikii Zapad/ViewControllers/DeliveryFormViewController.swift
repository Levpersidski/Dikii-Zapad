//
//  DeliveryFormViewController.swift
//  Dikii Zapad
//
//  Created by Роман Бакаев on 13.10.2023.
//

import UIKit
import EasyPeasy
import InputMask

class DeliveryFormViewController: UIViewController {
    private var topScrollViewConstraint: NSLayoutConstraint!
    
    let phoneListener = PhoneInputListener { _, string, completed, _ in
        DataStore.shared.phoneNumber = completed ? string : nil
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        scrollView.addTapGesture { [weak self] _ in
            self?.view.endEditing(true)
        }
        return scrollView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private var backgroundView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "mainImage")
        imageView.alpha = 0.3
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.text = "Укажите адрес"
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var streetTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Улица"
        textField.delegate = self
        return textField
    }()
    
    private lazy var houseTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Дом"
        textField.delegate = self
        return textField
    }()
    
    private lazy var contactsLabel: UILabel = {
        let label = UILabel()
        label.text = "Как с вами связаться?"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .regular)
        return label
    }()
    
    private lazy var nameTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Ваше имя"
        textField.delegate = self
        return textField
    }()
    
    private lazy var numberPhoneTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Номер телефона"
        textField.visibleMask = "+7 (XXX) XXX-XX-XX"
        textField.keyboardType = .phonePad
        textField.delegate = phoneListener
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setupView()
        setupConstrains()
        phoneListener.textFieldDelegate = self
        addObserverKeyboard()
    }
    
    deinit {
        removeObserverKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        streetTextField.text = DataStore.shared.userDeliveryLocation?.address
        numberPhoneTextField.text = DataStore.shared.phoneNumber?.maskAsPhone()
       
        nameTextField.text = DataStore.shared.name
    }
    
    func setupView() {
        view.addSubview(backgroundView)
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        containerView.addSubviews(
            addressLabel,
            streetTextField,
            houseTextField,
            
            contactsLabel,
            nameTextField,
            numberPhoneTextField
        )
    }
    
    func setupConstrains() {
        backgroundView.easy.layout(
            Edges()
        )
        
        scrollView.easy.layout(
            Top().to(view.safeAreaLayoutGuide, .top),
            Left(), Right(),
            Bottom()
        )
        
        topScrollViewConstraint = scrollView.easy.layout(Top().to(view.safeAreaLayoutGuide, .top)).first
        
        containerView.easy.layout(
            Edges(),
            Width(UIScreen.main.bounds.width)
        )
        
        addressLabel.easy.layout(
            Top(40),
            Left(16), Right(16)
        )
        
        streetTextField.easy.layout(
            Top(20).to(addressLabel, .bottom),
            Left(16),
            Right(16)
        )

        houseTextField.easy.layout(
            Top(7).to(streetTextField, .bottom),
            Left(16),
            Right(16)
        )
        
        //MOCK
        contactsLabel.easy.layout(
            Top(79).to(houseTextField, .bottom),
            Left(16), Right(16)
        )
        
        nameTextField.easy.layout(
            Top(20).to(contactsLabel, .bottom),
            Left(16),
            Right(16)
        )
        
        numberPhoneTextField.easy.layout(
            Top(7).to(nameTextField, .bottom),
            Left(16),
            Right(16),
            Bottom(40)
        )
    }
}

//MARK: - Private func
private extension DeliveryFormViewController {
    func openMapDeliveryViewController() {
        let isVisibleKeyboard = nameTextField.isFirstResponder || numberPhoneTextField.isFirstResponder
        
        if isVisibleKeyboard {
            view.endEditing(true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                let mapVC = MapDeliveryViewController()
                self?.navigationController?.pushViewController(mapVC, animated: true)
            }
        } else {
            let mapVC = MapDeliveryViewController()
            navigationController?.pushViewController(mapVC, animated: true)
        }
    }
}

//MARK: - UITextFieldDelegate
extension DeliveryFormViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == nameTextField {
            DataStore.shared.name = textField.text
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            textField.endEditing(true)
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == streetTextField || textField == houseTextField {
            openMapDeliveryViewController()
            return false
        } else {
            return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let startEditPhone = (textField.text == "" || textField.text == "+") && textField == numberPhoneTextField
        
        if startEditPhone {
            numberPhoneTextField.text = "+7"
            return false
        } else {
            return true
        }
    }
}

//MARK: -Observer
extension DeliveryFormViewController {
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
        
        topScrollViewConstraint.constant = -kbFrameSize.height/2
        UIView.animate(withDuration: 0.27, animations: {
            self.view.layoutSubviews()
        })
    }
    
    @objc private func kbWillHide() {
        
        topScrollViewConstraint.constant = 0
        UIView.animate(withDuration: 0.27, animations: {
            self.view.layoutSubviews()
        })
    }
}
