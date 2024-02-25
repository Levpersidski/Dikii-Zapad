//
//  OrderViewController.swift
//  Dikii Zapad
//
//  Created by Роман Бакаев on 15.02.2024.
//

import UIKit
import EasyPeasy

final class OrderViewController: UIViewController {
//    var orderText: String =  ""
//    var priceAllProduct: String = ""
    
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
    
    private lazy var dataPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.isHidden = true
        picker.undoManager?.runLoopModes = [.tracking]
        picker.backgroundColor = .white
        picker.maskCorners(radius: 10)
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
        button.setTitle("ОФОРМИТЬ ЗАКАЗ", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        setTimeDelivery()
        isValidDeliveryTime = checkValidTimeInDataSore()
        
        deliveryDropList.viewModel = prepareDeliveryListModel()
        payDropList.viewModel = preparePayListModel()
        
        let sumModel = prepareSumDelivery()
        sumValueDeliveryLabel.text = sumModel.0
        sumValueOrderLabel.text = sumModel.1
        
        sumDeliveryLabel.isHidden = sumModel.0.isEmpty
    }
    
    private func prepareSumDelivery() -> (String, String) {
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
                sumDelivery = priceAllProduct > 700 ? "Бесплатно" : "\(price) РУБ."
                sumOrder = priceAllProduct > 700 ? priceAllProduct : priceAllProduct + price
                
                priceDelivery = priceAllProduct > 700 ? 0 : price
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
                DropDownItemViewModel(title: "На вынос", isSelected: !isOutSideOrder) {
                    DataStore.shared.outSideOrder = false
                },
                DropDownItemViewModel(title: "Указать новый адресс", isSelected: false) { [weak self] in
                    DataStore.shared.outSideOrder = true
                    let mapView = MapDeliveryViewController()
                    self?.navigationController?.pushViewController(mapView, animated: true)
                }
            ]
        )
        if let address = address {
            let item = DropDownItemViewModel(title: address, isSelected: isOutSideOrder) {
                DataStore.shared.outSideOrder = true
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
                DropDownItemViewModel(title: "Картой", isSelected: false),
                DropDownItemViewModel(title: "СБП", isSelected: false)
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
        activityIndicator.easy.layout(
            Center()
        )
        dataPicker.easy.layout(
            Top(10).to(timeSecondButton, .bottom),
            Right().to(timeSecondButton, .right),
            Height(180),
            Width().like(timeSecondButton)
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
            
            timeSecondButton.setTitle(time, for: .normal)
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
        guard let values = DataStore.shared.timeDelivery?.components(separatedBy: ":"),
              values.count == 2,
              dataPicker.numberOfComponents == 2
        else {
            return
        }
        
        values.enumerated().forEach {
            guard let indexComponent = $0.offset == 0 ? hours.firstIndex(of: $0.element) : minutes.firstIndex(of: $0.element) else { return }
            dataPicker.selectRow(indexComponent, inComponent: $0.offset, animated: false)
        }
    }
    
    private func startLoadingAnimation(_ value: Bool) {
        value ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = !value
        self.makeOrderButton.setTitle(value ? "" : "ОФОРМИТЬ ЗАКАЗ", for: .normal)
    }
    
    private func createTextForMessage() -> String {
        let name = DataStore.shared.name ?? "Нет имени"
        let model = DataStore.shared.cartViewModel
        let userModel = DataStore.shared.userDeliveryLocation
        let address = DataStore.shared.outSideOrder ? (userModel?.address ?? "") : "На вынос"
        let time = DataStore.shared.timeDelivery ?? "как можно скорее"
        
        let price = Int(model.cells.map { Double($0.price) }.reduce(0, { $0 + $1 }))
        let order = model.cells.map{ "\($0.title)\($0.count > 1 ? "(x\($0.count))" : "")" + "\($0.additives.isEmpty ? "" : " - (\($0.additives.joined(separator: ", ")))")" }
        
        return "\(price + priceDelivery) Руб.\n\(order.joined(separator: "\n\n")) \n\n• \(address)\n• \(time)\n• \(name) т: +\(DataStore.shared.phoneNumber ?? "")"
    }
    
    @objc private func makeOrderButtonDidTap() {
        guard checkValidTimeInDataSore() else { return }
        
        payDropList.hiddenItems(true)
        deliveryDropList.hiddenItems(true)
        dataPicker.fadeOut()
        startLoadingAnimation(true)
        
        TelegramManager.shared.sendMessage(createTextForMessage()) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                if let window =  UIApplication.appDelegate.window {
                    let model = CustomAlertViewModel(title: "Благодарим за заказ!", subtitle: "Мы перезвоним вам в течении 15 минут для подтверждения заказа!")
                    CustomAlert.open(in: window, model: model)
                }
                self.navigationController?.popViewController(animated: true)
           
//                self.showAlert("Успешно",
//                               message: "Заказ оформлен",
//                               okTitle: "ок", present: true)
                DataStore.shared.cartViewModel.cells = []
            case .failure(_):
                
                if let window =  UIApplication.appDelegate.window {
                    let model = CustomAlertViewModel(title: "Ошибка", subtitle: "Не удалось оформить заказ\nПопробуйте позже")
                    CustomAlert.open(in: window, model: model)
                }
//                self.showAlert("Ошибка",
//                               message: "Не удалось оформить заказ\nПопробуйте позже",
//                               okTitle: "ок", present: true)
            }
            self.startLoadingAnimation(false)
        }
    }
    
    @objc private func timeFirstButtonDidTap() {
        isValidDeliveryTime = true
        payDropList.hiddenItems(true)
        deliveryDropList.hiddenItems(true)
        
        DataStore.shared.timeDelivery = nil
        dataPicker.fadeOut()
        setTimeDelivery()
        isValidDeliveryTime = checkValidTimeInDataSore()
    }
    
    @objc private func timeSecondButtonDidTap() {
        payDropList.hiddenItems(true)
        deliveryDropList.hiddenItems(true)
        setSelectDadaPucker()
        
        let selectedHour = hours[dataPicker.selectedRow(inComponent: 0)]
        let selectedMinute = minutes[dataPicker.selectedRow(inComponent: 1)]
        DataStore.shared.timeDelivery = "\(selectedHour):\(selectedMinute)"
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
        return 2 // Два компонента: часы и минуты
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return hours.count
        } else {
            return minutes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(hours[row])"
        } else {
            return "\(minutes[row])"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedHour = hours[pickerView.selectedRow(inComponent: 0)]
        let selectedMinute = minutes[pickerView.selectedRow(inComponent: 1)]
        
        print("Selected time: \(selectedHour):\(selectedMinute)")
        timeSecondButton.setTitle("\(selectedHour):\(selectedMinute)", for: .normal)
        DataStore.shared.timeDelivery = "\(selectedHour):\(selectedMinute)"
        
        setTimeDelivery()
        isValidDeliveryTime = checkValidTimeInDataSore()
    }
    
    @discardableResult
    func checkValidTimeInDataSore() -> Bool {
        guard let timeToDelivery = DataStore.shared.timeDelivery else {
            isValidDeliveryTime = true
            return true
        }
        
        let components = timeToDelivery.components(separatedBy: ":")
        guard components.count == 2 else {
            isValidDeliveryTime = true
            return true
        }
    
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        dateComponents.hour = Int(components[0]) // Устанавливаем часы
        dateComponents.minute = Int(components[1]) // Устанавливаем минуты
        let date = calendar.date(from: dateComponents) ?? Date()
        return date > Date()
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
