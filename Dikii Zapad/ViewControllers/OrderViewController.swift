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
    
    private lazy var deliveryLabel: UILabel = {
        let label = UILabel()
        label.text = "Доставка"
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private lazy var deliveryTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Время доставки"
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.textColor = .white
        return label
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
    
    private lazy var backgroundImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "mainImage")
        image.clipsToBounds = true
//        image.alpha = 0.3
        return image
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
        
    }
    
    func addSubViews() {
        view.addSubViews(
            backgroundImage,
            deliveryLabel,
            deliveryTimeLabel,
            makeOrderButton
        )
        
        makeOrderButton.addSubview(activityIndicator)
    }
    
    func setupConstraints() {
        backgroundImage.easy.layout(
            Edges()
        )
        
        deliveryLabel.easy.layout(
            Top(10).to(view.safeAreaLayoutGuide, .top),
            Left(16), Right(16)
        )
        
        deliveryTimeLabel.easy.layout(
            Top(10).to(deliveryLabel, .bottom),
            Left(16), Right(16)
        )
      
        makeOrderButton.easy.layout(
            Bottom(20).to(view.safeAreaLayoutGuide, .bottom),
            CenterX(),
            Left(16),
            Right(16),
            Height(60)
        )
        
        activityIndicator.easy.layout(
            Center()
        )
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
