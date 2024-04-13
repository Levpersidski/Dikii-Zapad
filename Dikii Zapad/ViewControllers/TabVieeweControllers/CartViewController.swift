//
//  CartViewController.swift
//  Dikii Zapad
//
//  Created by Роман Бакаев on 03.10.2023.
//

import UIKit
import EasyPeasy

struct CartViewModel {
    var cells: [CartCellViewModel] = [] {
        didSet {
            let count = cells.map({ $0.count }).reduce(0, { $0 + $1 })
            UIApplication.tabBar?.tabBar.setBageValue(.cart, value: count)
        }
    }
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
        image.alpha = 0.3
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
        label.font = UIFont.systemFont(ofSize: 30, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private  lazy var makeOrderButton: UIButton = {
        let button  = UIButton(type: .system)
        button.backgroundColor = UIColor.customOrange
        button.roundCorners(15)
        button.setTitle("Продолжить", for: .normal)
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
    
    private lazy var menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.customOrange
        button.maskCorners(radius: 15)
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
        tableView.separatorStyle = .none
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

        navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.navigationBar.backItem?.title = ""

    }
}

private extension CartViewController {
    func addSubViews() {
        view.addSubviews(
            backgroundImage,
            containerEmpty,
            containerFull
        )
        
        makeOrderButton.addSubview(activityIndicator)
        
        containerEmpty.addSubviews(
            halfBlackView,
            emptyBurgerImage,
            titleLabel,
            descriptionLabel,
            menuButton
        )
        
        containerFull.addSubviews(
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
            Height(54),
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
            Height(54)
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
    
    func updateViews(reload: Bool = true) {
        containerEmpty.isHidden = !(model.cells.isEmpty)
        containerFull.isHidden = (model.cells.isEmpty)
        
        let testSub = model.cells.map { Double($0.price) }.reduce(0, { $0 + $1 })
        pricelabel.text = "\(Int(testSub))"
        
        if reload {
            tableView.reloadData()
        }
    }
    
    @objc func openMainVC() {
        UIApplication.tabBar?.selectedIndex = 0
    }
    
    @objc func makeOrderButtonDidTap() {
        let orderVC = OrderViewController()
        navigationController?.pushViewController(orderVC, animated: true)
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
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 // Здесь можно указать оценочную высоту ячейки
    }

}

//MARK: - CartCellDelegate
extension CartViewController: CartCellDelegate {
    func removeButtonDidTap(uuid: UUID) {
        if let index = DataStore.shared.cartViewModel.cells.firstIndex(where: { $0.uuid == uuid }) {
            DataStore.shared.cartViewModel.cells.remove(at: index)
            tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .left)
        }
        updateViews(reload: false)
    }

}
