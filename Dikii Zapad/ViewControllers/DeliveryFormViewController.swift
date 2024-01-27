//
//  DeliveryFormViewController.swift
//  Dikii Zapad
//
//  Created by Роман Бакаев on 13.10.2023.
//

import UIKit
import EasyPeasy

class DeliveryFormViewController: UIViewController {
    
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
        textField.delegate = self
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setupView()
        setupConstrains()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setupView() {
        view.addSubview(backgroundView)
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        containerView.addSubViews(
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

//MARK: - UITextFieldDelegate
extension DeliveryFormViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//
//    }
}
