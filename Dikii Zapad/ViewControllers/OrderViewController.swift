//
//  OrderViewController.swift
//  Dikii Zapad
//
//  Created by Роман Бакаев on 15.02.2024.
//

import UIKit
import InputMask
import EasyPeasy

enum DayType: Int {
    case today = 0
    case tomorrow = 1
    
    var description: String {
        switch self {
        case .today:
            return "Сегодня"
        case .tomorrow:
            return "Завтра"
        }
    }
}

final class OrderViewController: UIViewController {
    let phoneListener = PhoneInputListener {_, string, completed, _ in }
    
    private var uuidNumber: String = "0"
    
    private var isValidDeliveryTime: Bool = true {
        didSet {
            timeSecondButton.titleLabel?.tintColor = isValidDeliveryTime ? .white : .red
            makeOrderButton.isEnabled = isValidDeliveryTime
            makeOrderButton.alpha = isValidDeliveryTime ? 1 : 0.3
        }
    }
    
    private var priceDelivery: Int = 0
    
    private let hours = [
        "00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"
    ]
    private let minutes = [
        "00", "05", "10", "15", "20", "25", "30", "35", "40", "45", "50",  "55"
    ]
    
    private let days: [DayType] = [.today, .tomorrow]
    
    private lazy var backgroundImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "mainImage")
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var overLayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.7)
        view.addTapGesture { [weak self] _ in
            self?.dataPicker.fadeOut()
            self?.view.endEditing(true)
            self?.payDropList.hiddenItems(true)
            self?.deliveryDropList.hiddenItems(true)
        }
        return view
    }()
    
    private lazy var deliveryLabel: UILabel = {
        let label = UILabel()
        label.text = "Оформление"
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private lazy var deliveryDropList: DropDownList = {
        let view = DropDownList(mode: .down)
        view.delegate = self
        view.viewModel = DropDownListViewModel(
            title: "Введите адрес доставки",
            items: []
        )
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var deliveryTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Время доставки"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var timeFirstButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Как можно скорее", for: .normal)
        button.titleLabel?.tintColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor(hex: "1C1C1C")
        button.maskCorners(radius: 6)
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(timeFirstButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var timeSecondButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Ко времени", for: .normal)
        button.titleLabel?.tintColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor(hex: "1C1C1C")
        button.maskCorners(radius: 6)
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(timeSecondButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var numberPhoneTextField: CustomTextField = {
        let textField = CustomTextField(
            frame: .zero,
            colorText: .white,
            colorPlaceholderText: .white.withAlphaComponent(0.6),
            fontPlaceholder: .systemFont(ofSize: 16, weight: .medium)
        )
            
        textField.placeholder = "Номер телефона"
        textField.visibleMask = "+7 (XXX) XXX-XX-XX"
        textField.keyboardType = .phonePad
        textField.delegate = phoneListener
        textField.backgroundColor = UIColor(hex: "1C1C1C").withAlphaComponent(0.6)
        textField.borderBolor = .clear
        textField.roundCorners(10)
        textField.borderWidth = 1
        return textField
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor(hex: "1C1C1C").withAlphaComponent(0.6)
        textView.layer.borderWidth = 1
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 16, weight: .medium)
        textView.textColor = .white.withAlphaComponent(0.8)
        textView.delegate = self
        textView.roundCorners(8)
        textView.textContainer.lineFragmentPadding = 16
        textView.adjustsFontForContentSizeCategory = true
        return textView
    }()
    
    private lazy var textViewPlaceholder: UILabel = {
        let label = UILabel()
        label.text = "Комментарии к заказу"
        label.textColor = .white.withAlphaComponent(0.6)
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var dataPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.isHidden = true
        picker.undoManager?.runLoopModes = [.tracking]
        picker.backgroundColor = .white
        picker.maskCorners(radius: 10)
        picker.tintColor = .red
        return picker
    }()
    
    private lazy var payDropList: DropDownList = {
        let view = DropDownList(mode: .up)
        view.delegate = self
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var sumDeliveryStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.addArrangedSubview(sumDeliveryLabel)
        stack.addArrangedSubview(sumValueDeliveryLabel)
        return stack
    }()
    
    private lazy var sumDeliveryLabel: UILabel = {
        let label = UILabel()
        label.text = "Доставка:"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private lazy var sumValueDeliveryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.textAlignment = .right
        return label
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "FE6F1F")
        return view
    }()
    
    private lazy var sumOrderStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.addArrangedSubview(sumOrderLabel)
        stack.addArrangedSubview(sumValueOrderLabel)
        return stack
    }()
    
    private lazy var sumOrderLabel: UILabel = {
        let label = UILabel()
        label.text = "Сумма заказа:"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private lazy var sumValueOrderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.textAlignment = .right
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private  lazy var makeOrderButton: UIButton = {
        let button  = UIButton(type: .system)
        button.maskCorners(radius: 15)
        button.setTitle("Оформить заказ", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(makeOrderButtonDidTap), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32 , height: 54)
        button.applyGradient(fromColor: UIColor(hex: "FF5929"),
                             toColor: UIColor(hex: "993C1F"),
                             fromPoint: CGPoint(x: 0.5, y: 0),
                             toPoint: CGPoint(x: 0.5, y: 1),
                             location: [0, 1])
        
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.color = .black
        loader.isHidden = true
        return loader
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setupConstraints()
        phoneListener.textFieldDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.backItem?.title = ""
        navigationController?.navigationBar.tintColor = UIColor.customOrange
        
        setTimeDelivery()
        isValidDeliveryTime = checkValidTimeInDataSore()
        
        deliveryDropList.viewModel = prepareDeliveryListModel()
        payDropList.viewModel = preparePayListModel()
        
        let sumModel = prepareSumDelivery()
        sumValueDeliveryLabel.text = sumModel.0
        sumValueOrderLabel.text = sumModel.1
        
        sumDeliveryLabel.isHidden = sumModel.0.isEmpty
        numberPhoneTextField.text = DataStore.shared.phoneNumber?.maskAsPhone()
        
        deliveryTimeLabel.text = DataStore.shared.outSideOrder ? "Время доставки" : "Время выдачи"
    }
    
    private func prepareSumDelivery() -> (String, String) {
        let minPriceSale: Int = DataStore.shared.generalSettings?.deliveryInfo.saleInfo.minPrice ?? 0
        let productsModel = DataStore.shared.cartViewModel
        let userModel = DataStore.shared.userDeliveryLocation
        let isOutSideOrder = DataStore.shared.outSideOrder
        let priceAllProduct = Int(productsModel.cells.map { Double($0.price) }.reduce(0, { $0 + $1 }))
        
        var sumDelivery = ""
        var priceDelivery = 0
        var sumOrder: Int = 0
        
        if let userModel = userModel, isOutSideOrder {
            let price = userModel.priceDelivery
            
            if userModel.hasSale {
                sumDelivery = priceAllProduct > minPriceSale ? "Бесплатно" : "\(price) РУБ."
                sumOrder = priceAllProduct > minPriceSale ? priceAllProduct : priceAllProduct + price
                
                priceDelivery = priceAllProduct > minPriceSale ? 0 : price
            } else {
                sumDelivery = "\(price) РУБ."
                sumOrder = priceAllProduct + price
                
                priceDelivery = price
            }
        } else {
            sumDelivery = isOutSideOrder ? "Не известно" : ""
            sumOrder = priceAllProduct
            
            priceDelivery = 0
        }
        
        self.priceDelivery = priceDelivery
        return (sumDelivery, "\(sumOrder) РУБ.")
    }
    
    private func prepareDeliveryListModel() -> DropDownListViewModel{
        let address = DataStore.shared.userDeliveryLocation?.address
        let isOutSideOrder = DataStore.shared.outSideOrder
        var model = DropDownListViewModel(
            title: isOutSideOrder ? (address ?? "Выберите тип заказа") : "На вынос",
            items: [
                DropDownItemViewModel(title: "На вынос", isSelected: !isOutSideOrder) { [weak self] in
                    DataStore.shared.outSideOrder = false
                    self?.deliveryTimeLabel.text = "Время выдачи"
                    let sumModel = self?.prepareSumDelivery()
                    self?.sumValueDeliveryLabel.text = sumModel?.0
                    self?.sumValueOrderLabel.text = sumModel?.1
                },
                DropDownItemViewModel(title: "Указать новый адрес", isSelected: false) { [weak self] in
                    DataStore.shared.outSideOrder = true
                    self?.deliveryTimeLabel.text = "Время доставки"
                    let mapView = MapDeliveryViewController()
                    self?.navigationController?.pushViewController(mapView, animated: true)
                }
            ]
        )
        if let address = address {
            let item = DropDownItemViewModel(title: address, isSelected: isOutSideOrder) { [weak self] in
                DataStore.shared.outSideOrder = true
                self?.deliveryTimeLabel.text = "Время доставки"
                let sumModel = self?.prepareSumDelivery()
                self?.sumValueDeliveryLabel.text = sumModel?.0
                self?.sumValueOrderLabel.text = sumModel?.1
            }
            
            model.items.insert(item, at: 0)
        }
        
        return model
    }
    
    private func preparePayListModel() -> DropDownListViewModel {
        let model = DropDownListViewModel(
            title: "Оплата: Наличными",
            items: [
                DropDownItemViewModel(title: "Наличными", isSelected: true),
                DropDownItemViewModel(title: "Картой (при получении)", isSelected: false)
            ]
        )
        return model
    }
    
    func addSubViews() {
        view.addSubviews(
            backgroundImage,
            overLayView,
            deliveryLabel,
            deliveryDropList,
            deliveryTimeLabel,
            timeFirstButton,
            timeSecondButton,
            numberPhoneTextField,
            textView,
            textViewPlaceholder,
            makeOrderButton,
            sumDeliveryStack,
            separatorView,
            sumOrderStack,
            payDropList,
            dataPicker
        )
        
        makeOrderButton.addSubview(activityIndicator)
    }
    
    func setupConstraints() {
        backgroundImage.easy.layout(Edges())
        overLayView.easy.layout(Edges())
        deliveryLabel.easy.layout(
            Top(10).to(view.safeAreaLayoutGuide, .top),
            Left(16), Right(16)
        )
       
        deliveryDropList.easy.layout(
            Top(20).to(deliveryLabel, .bottom),
            Left(), Right()
        )
        
        deliveryTimeLabel.easy.layout(
            Top(40).to(deliveryDropList, .bottom),
            Left(16), Right(16)
        )
        
        timeFirstButton.easy.layout(
            Top(20).to(deliveryTimeLabel, .bottom),
            Left(16), Width(*1.2).like(timeSecondButton),
            Height(40)
        )
        timeSecondButton.easy.layout(
            Top(20).to(deliveryTimeLabel, .bottom),
            Left(16).to(timeFirstButton, .right), Right(16),
            Height(40)
        )
        
        numberPhoneTextField.easy.layout(
            Top(20).to(timeSecondButton, .bottom),
            Left(16), Right(16),
            Height(40)
        )
        
        textView.easy.layout(
            Top(20).to(numberPhoneTextField, .bottom),
            Height(>=40),
            Left(16), Right(16),
            Bottom(<=16).to(payDropList, .top)
        )
        
        textViewPlaceholder.easy.layout(
            Top().to(textView, .top),
            Left(16).to(textView, .left), Right(16).to(textView, .right),
            Height(40)
        )
        
        activityIndicator.easy.layout(
            Center()
        )
        dataPicker.easy.layout(
            Top(10).to(timeSecondButton, .bottom),
            Left().to(timeFirstButton, .left), Right().to(timeSecondButton, .right),
            Height(180)
        )
        makeOrderButton.easy.layout(
            Bottom(20).to(view.safeAreaLayoutGuide, .bottom),
            CenterX(),
            Left(16),
            Right(16),
            Height(54)
        )
        sumOrderStack.easy.layout(
            Bottom(16).to(makeOrderButton, .top),
            Left(16), Right(16)
        )
        separatorView.easy.layout(
            Bottom(13).to(sumOrderStack, .top),
            Left(16), Right(16),
            Height(0.5)
        )
        sumDeliveryStack.easy.layout(
            Bottom(13).to(separatorView, .top),
            Left(16), Right(16)
        )
        payDropList.easy.layout(
            Bottom(20).to(sumDeliveryStack, .top),
            Left(), Right()
        )
    }
    
    private func setTimeDelivery() {
        let time = DataStore.shared.timeDelivery
        
        if let time = time {
            loadViewIfNeeded()
            UIView.animate(withDuration: 0.2) {
                self.timeFirstButton.layer.borderColor = UIColor.clear.cgColor
                self.timeSecondButton.layer.borderColor = UIColor.orange.cgColor
            }
            
            timeSecondButton.setTitle(time.1, for: .normal)
        } else {
            loadViewIfNeeded()
            UIView.animate(withDuration: 0.2) {
                self.timeFirstButton.layer.borderColor = UIColor.orange.cgColor
                self.timeSecondButton.layer.borderColor = UIColor.clear.cgColor
            }
            timeSecondButton.setTitle("Ко времени", for: .normal)
        }
    }
    
    private func setSelectDadaPucker() {
        guard let time = DataStore.shared.timeDelivery else {
            setCurrentTime(plus: 20)
            return
        }
        let componentsTime = time.1.components(separatedBy: ":")
        guard componentsTime.count == 2, dataPicker.numberOfComponents == 3 else {
            return
        }
        
        dataPicker.selectRow(time.0.rawValue, inComponent: 0, animated: false)
        dataPicker.selectRow(hours.firstIndex(of: componentsTime[0]) ?? 0, inComponent: 1, animated: false)
        dataPicker.selectRow(minutes.firstIndex(of: componentsTime[1]) ?? 0, inComponent: 2, animated: false)
    }
    
    private func setCurrentTime(plus minute: Int = 0) {
        let currentDate = Date()
        let calendar = Calendar.current
        let futureDate = calendar.date(byAdding: .minute, value: minute, to: currentDate) ?? Date()
        var components = calendar.dateComponents([.hour, .minute, .second], from: futureDate)
        if components.minute ?? 0 >= 55 {
            components.hour = (components.hour ?? 0) + 1
            components.minute = 0
        }
        
        let hoursIndex = self.hours.compactMap{ Int($0) }.closestIndexGreaterOrEqual(to: components.hour ?? 0)
        let minuteIndex = self.minutes.compactMap{ Int($0) }.closestIndexGreaterOrEqual(to: components.minute ?? 0)
        
        if let hoursIndex, let minuteIndex {
            dataPicker.selectRow(DayType.today.rawValue, inComponent: 0, animated: false)
            dataPicker.selectRow(hoursIndex, inComponent: 1, animated: false)
            dataPicker.selectRow(minuteIndex, inComponent: 2, animated: false)
        }
    }
    
    private func startLoadingAnimation(_ value: Bool) {
        value ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = !value
        self.makeOrderButton.setTitle(value ? "" : "ОФОРМИТЬ ЗАКАЗ", for: .normal)
    }
    
    private func createTextForMessage() -> String {
        let model = DataStore.shared.cartViewModel
        let userModel = DataStore.shared.userDeliveryLocation
        
        let name = DataStore.shared.name ?? "Нет имени"
        let price = Int(model.cells.map { Double($0.price) }.reduce(0, { $0 + $1 }))
        
        var time: String = "\(deliveryTimeLabel.text ?? ""): "
        if let timeDelivery = DataStore.shared.timeDelivery {
            time += timeDelivery.0.description + " " + timeDelivery.1
        } else {
            time += "как можно скорее"
        }
        
        let address: String
        if DataStore.shared.outSideOrder {
            let priceDelivery = sumValueDeliveryLabel.text ?? ""
            address = "Доставка: \(priceDelivery)" + "\n• " + "Адрес: \(userModel?.address ?? "")"
        } else {
            address = "На вынос"
        }
        
        let comment = textView.text ?? ""
        
        let orderText = model.cells.enumerated().map { index, model in
            let count = "\(model.price)" + " (\(model.count) x " + "\(model.price/model.count))"
            
            let category = DataStore.shared.allCategories.first(where: { $0.id == model.categoryId })?.name ?? ""
            let isDisplayCategory = DataStore.shared.generalSettings?.displayCategory.contains(category.lowercased()) ?? false
    
            return """
\(index + 1). \(isDisplayCategory ? category + " " : "")\(model.title): \(count) \(model.additives.isEmpty ? "" : " - (\(model.additives.joined(separator: ", ")))")
"""
        }
        
        let payTape = "Оплата: " + (payDropList.viewModel?.items.first(where: { $0.isSelected })?.title ?? "")
        
        return "номер: \(uuidNumber)\n\n\(orderText.joined(separator: "\n\n")) \n\n• \(address)\n• \(time)\n• \(payTape)\n• \(name) Тел: +\(DataStore.shared.phoneNumber ?? "")\(comment.isEmpty ? "" : "\n• Комментарий: \(comment)")\n• Сумма платежа: \(price + priceDelivery) Руб. "
    }
    
    func createCustomUUID() -> String {
        var uuid = ""
        for _ in (0...4) {
            uuid += "\(Int.random(in: 1..<10))"
        }
        return uuid
    }
    
    @objc private func makeOrderButtonDidTap() {
        view.endEditing(true)
        payDropList.hiddenItems(true)
        deliveryDropList.hiddenItems(true)
        dataPicker.fadeOut()
        numberPhoneTextField.hideError()

        guard checkValidTimeInDataSore() else { return }
        
        guard checkValidationPhone() else {
            numberPhoneTextField.showError()
            return
        }
        
        guard let name = DataStore.shared.name, !name.isEmpty else {
            let window = UIApplication.appDelegate.window ?? UIView()
            let model = CustomAlertViewModel(
                title: "Укажите имя для заказа",
                hasTextField: true,
                titleButton: "Сохранить"
            )
            
            CustomAlert.open(in: window, model: model)
            return
        }
        
        startLoadingAnimation(true)
        uuidNumber = createCustomUUID()
        
        TelegramManager.shared.sendMessage(createTextForMessage()) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                if let window =  UIApplication.appDelegate.window {
                    let model = CustomAlertViewModel(title: "Благодарим за заказ!", subtitle: "Мы перезвоним вам на номер: \(DataStore.shared.phoneNumber?.maskAsPhone() ?? "") в течении 15 минут для подтверждения заказа!\n Номер заказа: \(uuidNumber)")
                    CustomAlert.open(in: window, model: model)
                }
                self.navigationController?.popViewController(animated: true)
                DataStore.shared.cartViewModel.cells = []
            case .failure(_):
                
                if let window =  UIApplication.appDelegate.window {
                    let model = CustomAlertViewModel(title: "Ошибка", subtitle: "Не удалось оформить заказ\nПопробуйте позже")
                    CustomAlert.open(in: window, model: model)
                }
            }
            self.startLoadingAnimation(false)
        }
    }
    
    @objc private func timeFirstButtonDidTap() {
        view.endEditing(true)
        isValidDeliveryTime = true
        payDropList.hiddenItems(true)
        deliveryDropList.hiddenItems(true)
        
        DataStore.shared.timeDelivery = nil
        dataPicker.fadeOut()
        setTimeDelivery()
        isValidDeliveryTime = checkValidTimeInDataSore()
    }
    
    @objc private func timeSecondButtonDidTap() {
        view.endEditing(true)
        payDropList.hiddenItems(true)
        deliveryDropList.hiddenItems(true)
        setSelectDadaPucker()
        
        let selectedDay = days[dataPicker.selectedRow(inComponent: 0)]
        let selectedHour = hours[dataPicker.selectedRow(inComponent: 1)]
        let selectedMinute = minutes[dataPicker.selectedRow(inComponent: 2)]
        DataStore.shared.timeDelivery = (selectedDay, "\(selectedHour):\(selectedMinute)")
        setTimeDelivery()
        isValidDeliveryTime = checkValidTimeInDataSore()

        if dataPicker.isHidden {
            dataPicker.fadeIn()
        } else {
            dataPicker.fadeOut()
        }
    }
}

//MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension OrderViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3 // Три компонента: Дни, часы и минуты
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return days.count
        } else if component == 1 {
            return hours.count
        } else {
            return minutes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let string: String
        
        if component == 0 {
            string = days[row].description
        } else if component == 1 {
            string = hours[row]
        } else {
            string = minutes[row]
        }
        return NSAttributedString(string: string, attributes: [.foregroundColor: UIColor.black])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedDay = days[pickerView.selectedRow(inComponent: 0)]
        let selectedHour = hours[pickerView.selectedRow(inComponent: 1)]
        let selectedMinute = minutes[pickerView.selectedRow(inComponent: 2)]
        
        print("Selected time: \(selectedDay.description) \(selectedHour):\(selectedMinute)")
        timeSecondButton.setTitle("\(selectedHour):\(selectedMinute)", for: .normal)
        DataStore.shared.timeDelivery = (selectedDay, "\(selectedHour):\(selectedMinute)")
        
        setTimeDelivery()
        isValidDeliveryTime = checkValidTimeInDataSore()
    }
    
    @discardableResult
    func checkValidTimeInDataSore() -> Bool {
        guard let timeToDelivery = DataStore.shared.timeDelivery else {
            isValidDeliveryTime = true
            return true
        }
        
        let components = timeToDelivery.1.components(separatedBy: ":")
        guard components.count == 2 else {
            isValidDeliveryTime = true
            return true
        }
        
        let futureDate = Date().plus(minutes: 20)
        var customDate = Date().set(hours: Int(components[0]), minutes: Int(components[1]))
        
        if timeToDelivery.0 == .tomorrow {
            customDate = customDate?.plus(days: 1)
        }
        return customDate ?? Date() >= futureDate ?? Date()
    }
}

//MARK: - DropDownListDelegate
extension OrderViewController: DropDownListDelegate {
    func selectItem(dropDown: DropDownList, itemModel: DropDownItemViewModel) {
        if dropDown == deliveryDropList {
            itemModel.completion?()
            
            let sumModel = prepareSumDelivery()
            sumValueDeliveryLabel.text = sumModel.0
            sumDeliveryLabel.isHidden = sumModel.0.isEmpty
        }
    }
    
    func dropDownListOpen(_ dropDown: DropDownList) {
        view.endEditing(true)
        dataPicker.fadeOut()

        if dropDown === payDropList {
            deliveryDropList.hiddenItems(true)
        }
        if dropDown === deliveryDropList {
            payDropList.hiddenItems(true)
        }
    }
    
    func dropDownListClose(_ dropDown: DropDownList) {
    }
}

//MARK: - UITextViewDelegate
extension OrderViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let isEmptyText = textView.text.isEmpty
        textViewPlaceholder.isHidden = !isEmptyText
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        dataPicker.fadeOut()
        payDropList.hiddenItems(true)
        deliveryDropList.hiddenItems(true)
        
        let isEmptyText = textView.text.isEmpty
        textViewPlaceholder.isHidden = !isEmptyText
        textView.layer.borderColor = UIColor.orange.cgColor
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let isEmptyText = textView.text.isEmpty
        textViewPlaceholder.isHidden = !isEmptyText
        textView.layer.borderColor = UIColor.clear.cgColor
    }
}

//MARK: - UITextFieldDelegate
extension OrderViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        guard textField == numberPhoneTextField else { return }
        numberPhoneTextField.hideError()
        
        guard checkValidationPhone() else { return }
        DataStore.shared.phoneNumber = textField.text?.numbers
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard textField == numberPhoneTextField else { return }
        numberPhoneTextField.showFocusBorder()
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
    
    private func checkValidationPhone() -> Bool {
        let phone = (numberPhoneTextField.text ?? "").numbers
        return phone.count == 11
    }
}
