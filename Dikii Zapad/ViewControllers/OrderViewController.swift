//
//  OrderViewController.swift
//  Dikii Zapad
//
//  Created by Роман Бакаев on 15.02.2024.
//

import UIKit
import EasyPeasy

final class OrderViewController: UIViewController {
    var orderText: String =  ""
    
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
        return view
    }()
    
    private lazy var deliveryLabel: UILabel = {
        let label = UILabel()
        label.text = "Доставка"
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private lazy var addressButton: UIButtonTransform = {
        let button = UIButtonTransform(type: .system)
        button.backgroundColor = UIColor(hex: "1C1C1C")
        button.maskCorners(radius: 8)
        button.addTarget(self, action: #selector(addressButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var addressStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.addArrangedSubview(addressLabel)
        stackView.addArrangedSubview(arrowImage)
        stackView.isUserInteractionEnabled = false
        return stackView
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.text = "Ул. Харьковская 12"
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private lazy var arrowImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.image = UIImage(named: "arrow_img")?.withRenderingMode(.alwaysOriginal)
        imageView.easy.layout(Size(30))
        return imageView
    }()
    
    private lazy var deliveryTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Время доставки"
        label.font = .systemFont(ofSize: 24, weight: .medium)
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
        return button
    }()
    
    private  lazy var makeOrderButton: UIButton = {
        let button  = UIButton(type: .system)
        button.backgroundColor = UIColor.customOrange
        button.layer.cornerRadius = 15
        button.setTitle("ОФОРМИТЬ ЗАКАЗ", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        button.addTarget(self, action: #selector(makeOrderButtonDidTap), for: .touchUpInside)
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
    }
    
    func addSubViews() {
        view.addSubviews(
            backgroundImage,
            overLayView,
            deliveryLabel,
            addressButton,
            deliveryTimeLabel,
            timeFirstButton,
            timeSecondButton,
            makeOrderButton
        )
        
        addressButton.addSubview(addressStack)
        makeOrderButton.addSubview(activityIndicator)
    }
    
    func setupConstraints() {
        backgroundImage.easy.layout(
            Edges()
        )
        overLayView.easy.layout(
            Edges()
        )
        deliveryLabel.easy.layout(
            Top(10).to(view.safeAreaLayoutGuide, .top),
            Left(16), Right(16)
        )
        addressButton.easy.layout(
            Top(20).to(deliveryLabel, .bottom),
            Left(16), Right(16),
            Height(62)
        )
        addressStack.easy.layout(
            Top(),
            Left(16), Right(16),
            Bottom()
        )
        deliveryTimeLabel.easy.layout(
            Top(40).to(addressButton, .bottom),
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
        
        makeOrderButton.easy.layout(
            Bottom(20).to(view.safeAreaLayoutGuide, .bottom),
            CenterX(),
            Left(16),
            Right(16),
            Height(54)
        )
        activityIndicator.easy.layout(
            Center()
        )
    }
    
    private func setTimeDelivery() {
        let time = DataStore.shared.timeDelivery
        
        if let time = time {
            timeFirstButton.layer.borderColor = UIColor.clear.cgColor
            timeSecondButton.layer.borderColor = UIColor.orange.cgColor
            
            timeSecondButton.setTitle(time, for: .normal)
        } else {
            timeFirstButton.layer.borderColor = UIColor.orange.cgColor
            timeSecondButton.layer.borderColor = UIColor.clear.cgColor
            
            timeSecondButton.setTitle("Ко времени", for: .normal)
        }
    }
    
    @objc func addressButtonDidTap() {
        let viewController = MapDeliveryViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func makeOrderButtonDidTap() {
        startLoadingAnimation(true)
                
        sendTelegramMessage(orderText) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                self.showAlert("Успешно",
                          message: "Заказ оформлен",
                          okTitle: "ок", present: true)
                DataStore.shared.cartViewModel.cells = []
            case .failure(_):
                self.showAlert("Ошибка",
                          message: "Не удалось оформить заказ\nПопробуйте позже",
                          okTitle: "ок", present: true)
            }
            self.startLoadingAnimation(false)
        }
    }
    
    func startLoadingAnimation(_ value: Bool) {
        value ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = !value
        self.makeOrderButton.setTitle(value ? "" : "ОФОРМИТЬ ЗАКАЗ", for: .normal)
    }
    
    func sendTelegramMessage(_ text: String, completion: @escaping (Result<String, ErrorDZ>) -> Void) {
        let url = URL(string: "http://dikiyzapad-161.ru/test/index.php")!
        let secretToken = "0f2087abd0760c7faf0f67c0770d5a9081885394f7ad76c7cd0975e88d96fd41"
        let keyMessage = "text"
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(secretToken)", forHTTPHeaderField: "Authorization")
        request.httpBody = (keyMessage + "=" + text).data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completion(.failure(ErrorDZ.badData))
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    completion(.failure(ErrorDZ.badAuthorisations))
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response!)")
                }
                let responseString = String(data: data, encoding: .utf8)
                print("Response data = \(responseString ?? "No response")")
                completion(.success("Заказ успешно отправлен"))
            }
        }
        task.resume()
    }
}
