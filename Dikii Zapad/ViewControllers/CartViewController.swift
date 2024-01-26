//
//  CartViewController.swift
//  Dikii Zapad
//
//  Created by Роман Бакаев on 03.10.2023.
//

import UIKit
import EasyPeasy

struct CartViewModel {
    var cells: [CartCellViewModel] = []
}

enum ErrorDZ: Error {
    case badData
    case badAuthorisations
}

class CartViewController: UIViewController {
    
    private lazy var backgroundImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "mainImage")
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var halfBlackView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.opacity = 0.5
        return view
    }()
    
    private lazy var containerEmpty: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var containerFull: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var emptyBurgerImage: UIImageView = {
        let burgerImage = UIImageView()
        burgerImage.contentMode = .scaleAspectFill
        burgerImage.image = UIImage(named: "emptyBurger")
        burgerImage.alpha = 0.9
        return burgerImage
    }()
    
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.text = "ОЙ, пусто!"
        title.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        title.textAlignment = .center
        title.textColor = .white
        title.layer.opacity = 0.7
        return title
    }()
    
    private let descriptionLabel: UILabel = {
        let description = UILabel()
        description.text = """
Похоже что вы ничего не выбрали 😔
Откройте меню и выберите
понравившийся товар 😉
"""
        description.numberOfLines = 0
        description.textAlignment = .center
        description.textColor = .init(white: 18, alpha: 0.8)
        return description
    }()
    
    private lazy var sumLabel: UILabel = {
        let label  = UILabel()
        label.text = "Сумма заказа:"
        label.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private lazy var pricelabel: UILabel = {
        let label  = UILabel()
        label.text = "000"
        label.font = UIFont(name: "Capture it", size: 30)
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
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.color = .black
        loader.isHidden = true
        return loader
    }()
    
    private lazy var menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.customOrange
        button.layer.cornerRadius = 15
        button.setTitle("Перейти в меню", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(openMainVC), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CartCell.self, forCellReuseIdentifier: "CartCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private var model: CartViewModel {
        DataStore.shared.cartViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setupConstraints()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateViews()
    }
}

private extension CartViewController {
    func addSubViews() {
        view.addSubViews(
            backgroundImage,
            containerEmpty,
            containerFull
        )
        
        makeOrderButton.addSubview(activityIndicator)
        
        containerEmpty.addSubViews(
            halfBlackView,
            emptyBurgerImage,
            titleLabel,
            descriptionLabel,
            menuButton
        )
        
        containerFull.addSubViews(
            tableView,
            sumLabel,
            pricelabel,
            makeOrderButton
        )
    }
    
    func setupConstraints() {
        backgroundImage.easy.layout(
            Edges()
        )
        
        halfBlackView.easy.layout(
            Top(),
            Left(),
            Right(),
            Size(300)
        )
        
        containerEmpty.easy.layout(
            Top(20), CenterX(), Left(), Right()
        )
        
        containerFull.easy.layout(
            Top(20), Left(), Right(), Bottom()
        )
        
        emptyBurgerImage.easy.layout(
            Top(120),
            CenterX(),
            Size(300)
        )
        
        titleLabel.easy.layout(
            Bottom(30).to(emptyBurgerImage, .bottom),
            CenterX()
        )
        
        descriptionLabel.easy.layout(
            Top(20).to(titleLabel, .bottom),
            CenterX(),
            Right(20),
            Left(20)
        )
        
        menuButton.easy.layout(
            Top(20).to(descriptionLabel, .bottom),
            Left(30),
            Right(30),
            Height(60),
            Bottom()
        )
        
        tableView.easy.layout(
            Top().to(view.safeAreaLayoutGuide, .top),
            Left(), Right(),
            Bottom().to(sumLabel, .top)
        )
        
        makeOrderButton.easy.layout(
            Bottom(20).to(view.safeAreaLayoutGuide, .bottom),
            CenterX(),
            Left(16),
            Right(16),
            Height(60)
        )
        
        sumLabel.easy.layout(
            Bottom(25).to(makeOrderButton, .top),
            Left(16)
        )
        
        pricelabel.easy.layout(
            Bottom().to(sumLabel, .bottom),
            Right(16)
        )
        
        activityIndicator.easy.layout(
            Center()
        )
    }
    
    func updateViews() {
        containerEmpty.isHidden = !(model.cells.isEmpty)
        containerFull.isHidden = (model.cells.isEmpty)
        
        tableView.reloadData()
        
        let testSub = model.cells.map { Double($0.price) ?? 0 }.reduce(0, { $0 + $1 })
        pricelabel.text = "\(testSub)"
    }
    
    @objc func openMainVC() {
        let vc = MainTabBarController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    @objc func makeOrderButtonDidTap() {
        startLoadingAnimation(true)
        
       let message = createTextForMessage()
        
        sendTelegramMessage(message) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                self.showAlert("Успешно",
                          message: "Заказ оформлен",
                          okTitle: "ок", present: true)
                DataStore.shared.cartViewModel.cells = []
                self.updateViews()
            case .failure(_):
                self.showAlert("Ошибка",
                          message: "Не удалось оформить заказ\nПопробуйте позже",
                          okTitle: "ок", present: true)
            }
            self.startLoadingAnimation(false)
        }
    }
    
    func createTextForMessage() -> String {
        let price = pricelabel.text ?? "-"
        let order = model.cells.map{ "\($0.title)\($0.count > 1 ? "(x\($0.count))" : "")" + "\($0.additives.isEmpty ? "" : " - (\($0.additives.joined(separator: ", ")))")" }
        
        return "\(price) Руб.\n\(order.joined(separator: "\n\n"))"
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

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as? CartCell else {
            return UITableViewCell()
        }
                
        cell.model = model.cells[indexPath.row]
        cell.isLast = indexPath.row == model.cells.count - 1
        return cell
    }
}
