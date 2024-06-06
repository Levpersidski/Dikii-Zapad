//
//  DeliveryFormViewController.swift
//  Dikii Zapad
//
//  Created by Роман Бакаев on 13.10.2023.
//

import UIKit
import EasyPeasy
import InputMask
import CoreLocation

class DeliveryFormViewController: UIViewController {
    
    private let generalSetting = DataStore.shared.generalSettings
    private let locationManager = LocationDataManager.shared

    private var topScrollViewConstraint: NSLayoutConstraint!
    private var bottomButtonConstraint: NSLayoutConstraint!

    let phoneListener = PhoneInputListener {_, string, completed, _ in }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        scrollView.addTapGesture { [weak self] _ in
            self?.view.endEditing(true)
        }
        return scrollView
    }()
    
    private lazy var gradientView: GradientView = {
        let view = GradientView()
        view.applyGradient(fromColor: .black,
                           toColor: .clear,
                           fromPoint: CGPoint(x: 0.5, y: 0),
                           toPoint: CGPoint(x: 0.5, y: 1))
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private lazy var confirmButton: GradientButton = {
        let button  = GradientButton(type: .system)
        button.backgroundColor = UIColor.customOrange
        button.roundCorners(15)
        button.setTitle("Применить", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(confirmButtonDidTap), for: .touchUpInside)
        button.isHidden = true
        return button
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
        let textField = CustomTextField(colorText: .white, colorPlaceholderText: .white)
        textField.placeholder = "Улица"
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var openMapButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Указать на карте", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        let image = UIImage(named: "arrowMap")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 26, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(openMapButtonDidTap), for: .touchUpInside)
        button.contentHorizontalAlignment = .left
        return button
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
        let textField = CustomTextField(colorText: .white, colorPlaceholderText: .white)
        textField.placeholder = "Ваше имя"
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        textField.delegate = self
        textField.autocorrectionType = .no
        return textField
    }()
    
    private lazy var numberPhoneTextField: CustomTextField = {
        let textField = CustomTextField(colorText: .white, colorPlaceholderText: .white)
        textField.placeholder = "Номер телефона"
        textField.visibleMask = "+7 (XXX) XXX-XX-XX"
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
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
        view.addSubviews(scrollView, gradientView, confirmButton)
        scrollView.addSubview(containerView)
        
        containerView.addSubviews(
            addressLabel,
            streetTextField,
            openMapButton,
            contactsLabel,
            nameTextField,
            numberPhoneTextField
        )
    }
    
    func setupConstrains() {
        backgroundView.easy.layout(
            Edges()
        )
        
        gradientView.easy.layout(
            Top(),
            Left(), Right(),
            Bottom(-40).to(view.safeAreaLayoutGuide, .top)
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
            Top(10),
            Left(16), Right(16)
        )
        
        streetTextField.easy.layout(
            Top(20).to(addressLabel, .bottom),
            Left(16),
            Right(16)
        )

        openMapButton.easy.layout(
            Top(12).to(streetTextField, .bottom),
            Left(16),
            Right(16),
            Height(40)
        )
        
        //MOCK
        contactsLabel.easy.layout(
            Top(79).to(openMapButton, .bottom),
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
        
        confirmButton.easy.layout(
            Height(54),
            Left(16), Right(16)
        )
        
        bottomButtonConstraint = confirmButton.easy.layout(Bottom(40)).first
    }
    
    private func datasWasChanged() -> Bool {
        let phoneInDataStore = DataStore.shared.phoneNumber ?? ""
        let name = DataStore.shared.name ?? ""
        let address = DataStore.shared.userDeliveryLocation?.address ?? ""
        
        let newPhone = (numberPhoneTextField.text ?? "").numbers
        let validCountPhone = newPhone.count == 11 || newPhone.count == 0
        let newName = nameTextField.text
        let newAddress = streetTextField.text
        
        return (phoneInDataStore != newPhone && validCountPhone) || (name != newName) || (address != newAddress)
    }
    
    private func displayConformButtonIfNeeded() {
        confirmButton.isHidden = !datasWasChanged()
    }
    
    
    @objc private func textFieldEditingChanged() {
        displayConformButtonIfNeeded()
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
    
    @objc
    func openMapButtonDidTap() {
        openMapDeliveryViewController()
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
        if textField == nameTextField || textField == streetTextField {
            textField.endEditing(true)
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == streetTextField {
            return true
        } else {
            return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField == numberPhoneTextField {
            let startEditPhone = (textField.text == "" || textField.text == "+") && textField == numberPhoneTextField
            
            if startEditPhone {
                numberPhoneTextField.text = "+7"
                return false
            } else {
                return true
            }
        }
        return true
    }
    
    func searchLocation(_ string: String) {
        locationManager.cleanLocations()
        
        //Вначале загружаю локации
        locationManager.getLocations(
            prefixSearch: generalSetting?.deliveryInfo.searchLocation ?? "",
            name: string
        ) { [weak self] placemarks in
            guard let placemark = placemarks.first else {
                self?.streetTextField.showError()
                self?.showAlert("Ошибка", message: "Не удалось построить по вашему адрессу")
                return
            }
            let startLocation = CLLocationCoordinate2D(
                latitude: self?.generalSetting?.shopLocation.latitude ?? 0,
                longitude: self?.generalSetting?.shopLocation.longitude ?? 0
            )
            let endLocation = CLLocationCoordinate2D(
                latitude: placemark.location?.coordinate.latitude ?? 0,
                longitude: placemark.location?.coordinate.longitude ?? 0
            )
            //По получ. локациям строю ммаршрут
            LocationDataManager.shared.buildingWay(
                startLocation: startLocation,
                endLocation: endLocation) { [weak self] error, rout in
                    guard let self = self, error == nil, let rout = rout else {
                        self?.streetTextField.showError()
                        self?.showAlert("Ошибка", message: "Не удалось построить по вашему адрессу")
                        return
                    }
                    
                    let cortage = self.locationManager.getSumDelyvery(rout.distance)
                    let value = cortage.0
                    let hasSale = cortage.1
                    
                    guard value != 9999 else {
                        self.streetTextField.showError()
                        
                        let max = self.generalSetting?.deliveryInfo.distances.map{$0.maxDistance}.sorted(by: {$0 > $1}).first ?? 0
                        self.showAlert("Ошибка", message: "Не удалось построить по вашему адрессу\nМаксимальная дальность доставки \(max)м.")
                        return
                    }
                    self.streetTextField.hideError()
                    
                    DataStore.shared.userDeliveryLocation = UserDeliveryLocationModel(
                        address: placemark.name ?? "",
                        hasSale: hasSale,
                        priceDelivery: Int(value)
                    )
                }
        }
    }
}

//MARK: -Observer
extension DeliveryFormViewController {
    
    @objc
    func confirmButtonDidTap() {
        view.endEditing(true)
        DataStore.shared.name = nameTextField.text ?? ""
        if let number = numberPhoneTextField.text?.numbers, number.count == 11 || number.count == 0 {
            DataStore.shared.phoneNumber = number
        }
        
        let addressInDataStore = DataStore.shared.userDeliveryLocation?.address ?? ""
        if addressInDataStore != streetTextField.text {
            searchLocation(streetTextField.text ?? "")
        }
        confirmButton.isHidden = true
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
        
        if !streetTextField.isFirstResponder {
            topScrollViewConstraint.constant = -kbFrameSize.height/2
        }
        bottomButtonConstraint.constant = -20 - kbFrameSize.height
        UIView.animate(withDuration: 0.27, animations: {
            self.view.layoutSubviews()
        })
    }
    
    @objc private func kbWillHide() {
        
        topScrollViewConstraint.constant = 0
        bottomButtonConstraint.constant = -40
        UIView.animate(withDuration: 0.27, animations: {
            self.view.layoutSubviews()
        })
    }
}
