//
//  BottomSheetMapView.swift
//  Dikii Zapad
//
//  Created by mac on 28.01.2024.
//

import UIKit
import EasyPeasy
import MapKit

struct BottomSheetMapViewModel {
    let distance: Double
    let price: String
    let hasDiscount: Bool
    
    let state: BottomSheetMapState
}

enum BottomSheetMapState {
    case notCalculated
    case calculated
}

protocol BottomSheetMapViewDelegate: AnyObject {
    func buttonDidTouch(state: BottomSheetMapState)
    func cleanLocations()
    func updateLocations(newText: String)
    func showSearchAnnotationWithName(placeMark: CLPlacemark)
}

final class BottomSheetMapView: UIView {
    
    //variables for gesture
    private let screenHeight: CGFloat = UIScreen.main.bounds.height
    private var bottomContainerConstraint: NSLayoutConstraint!
    
//    var bottomConstraint: CGFloat = 0

    private let offset: CGFloat = 0
    private var panOrigin: CGPoint = .zero
    private let secondOffset: CGFloat = 80
    
    weak var delegate: BottomSheetMapViewDelegate?
    
    var model: BottomSheetMapViewModel? {
        didSet {
            guard let model else { return }
            
            priceLabel.text = "\(model.price)"
            distanceLabel.text = "\(model.distance) метров"
        }
    }
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.8)
        view.maskCorners(radius: 24, [.topLeft, .topRight])
        view.addPanGesture { [weak self] rec in
            self?.panDetected(rec)
        }
        return view
    }()
    
    private lazy var dragView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2.5
        view.backgroundColor = .orange
        return view
    }()
    
    private(set) lazy var addressTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Введите адресс"
        textField.delegate = self
        textField.font = .systemFont(ofSize: 14)
        return textField
    }()
    
    private lazy var hintsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    private lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .customGrey
        label.text = "- км"
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .orange
        label.text = "-"
        label.numberOfLines = 0
        label.textAlignment = .right
        return label
    }()
    
    private lazy var confirmButton: UIButton = {
        let button  = UIButton(type: .system)
        button.backgroundColor = UIColor.customOrange
        button.layer.cornerRadius = 15
        button.setTitle("ПОДТВЕРДИТЬ", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        button.addTarget(self, action: #selector(confirmButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var extraView: UIView = {
        let view = UIView()
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
        setupConstrains()
        addObserverKeyboard()
    }
    
    deinit {
        removeObserverKeyboard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(containerView)
        containerView.addSubViews(
            dragView,
            addressTextField,
            hintsStackView,
            distanceLabel,
            priceLabel,
            confirmButton
        )
    }
    
    func setupConstrains() {
        containerView.easy.layout(
            Top(),
            Left(),
            Right(),
            Bottom()
        )
        dragView.easy.layout(
            Top(11),
            CenterX(),
            Height(6),
            Width(42)
        )
        
        addressTextField.easy.layout(
            Top(30),
            Left(10),
            Right(10)
        )
        hintsStackView.easy.layout(
            Top().to(addressTextField, .bottom),
            Left(16), Right(16),
            Bottom(20).to(distanceLabel, .top)
        )
        distanceLabel.easy.layout(
            Top(20).to(hintsStackView, .bottom),
            Left(16)
        )
        priceLabel.easy.layout(
            CenterY().to(distanceLabel, .centerY),
            Left(10).to(distanceLabel, .right),
            Right(16)
        )
        confirmButton.easy.layout(
            Top(10).to(priceLabel, .bottom),
            Height(250),
            Left(16),
            Right(16),
            Bottom(20)
        )
        
        bottomContainerConstraint = containerView.easy.layout(Bottom()).first
    }
    
    @objc private func confirmButtonDidTap() {
        delegate?.buttonDidTouch(state: model?.state ?? .notCalculated)
    }
    
    func setStackView(locations: [CLPlacemark]) {
        hintsStackView.removeAllArrangedSubviews()
        
        locations.enumerated().forEach { (index, placeMark) in
            let label = UILabel()
            label.font = .systemFont(ofSize: 14, weight: .bold)
            label.textColor = .orange.withAlphaComponent(0.7)
            label.addTapGesture { [weak self, placeMark] _ in
                guard let self = self else { return }
                
                
                self.addressTextField.text = label.text
                self.hintsStackView.removeAllArrangedSubviews()
                self.endEditing(true)
                
                //TO DO: MOCK
                self.priceLabel.text = "-"
                self.distanceLabel.text = "- км"
                
                self.delegate?.showSearchAnnotationWithName(placeMark: placeMark)
            }
            
            label.easy.layout(
                Height(50)
            )
            
            label.text = createNameLocation(from: placeMark)
            
            hintsStackView.addArrangedSubview(label)
        }
    }
    
    private func createNameLocation(from placeMark: CLPlacemark) -> String {
        let string: String
        
        let name = placeMark.name ?? "" //Улица, дом
        let locality = placeMark.locality ?? "" //Город
//        let thoroughfare = placeMark.thoroughfare ?? "" // Улица
//        let subThoroughfare = placeMark.subThoroughfare ?? "" //Дом
//        let administrativeArea = placeMark.administrativeArea
//        let region = placeMark.region
        
        if locality != name {
            string = name + ", " + locality
        } else {
            string = locality
        }
        return string
    }
}


//MARK: - UITextFieldDelegate
extension BottomSheetMapView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else {
            return true
        }
        
        if newText.isEmpty || newText == "" {
            delegate?.cleanLocations()
        } else {
            delegate?.updateLocations(newText: newText)
        }
        
        return true
    }
}

//Observer
extension BottomSheetMapView {
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
        
        bottomContainerConstraint.constant = offset - kbFrameSize.height
        UIView.animate(withDuration: 0.27, animations: {
            self.layoutSubviews()
        })
    }
    
    @objc private func kbWillHide() {
        bottomContainerConstraint.constant = offset
        UIView.animate(withDuration: 0.27, animations: {
            self.layoutSubviews()
        })
    }
}


//MARK: - Gesture
extension BottomSheetMapView {
    private func returnToPlace() {
        self.layoutIfNeeded()
        bottomContainerConstraint.constant = offset
        UIView.animate(withDuration: 0.27, animations: {
            self.layoutSubviews()
        })
    }
    
    private func returnToSecondPlace() {
        self.layoutIfNeeded()
        bottomContainerConstraint.constant = 0
        UIView.animate(withDuration: 0.27, animations: {
            self.layoutSubviews()
        })
    }
    
    @objc
    private func panDetected(_ recognizer: UIPanGestureRecognizer) {
        let state = recognizer.state
        switch state {
        case .possible:
            break
        case .began:
            self.panOrigin = recognizer.translation(in: containerView)
        case .changed:
            let point = recognizer.translation(in: containerView)
            let panProgress = point.y - self.panOrigin.y
            let constant = max(-offset , bottomContainerConstraint.constant + panProgress)
            
            bottomContainerConstraint.constant = constant
            
            self.panOrigin = point
        case .ended, .cancelled:
            self.panOrigin = .zero
            
            let point = recognizer.translation(in: containerView)
            let panProgress = point.y - self.panOrigin.y
//            if panProgress > 50 {
//                returnToSecondPlace()
//            } else {
                returnToPlace()
//            }
        default:
            self.panOrigin = .zero
        }
    }
}
