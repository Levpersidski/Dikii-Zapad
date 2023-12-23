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

class CartViewController: UIViewController {
    
    private lazy var backgroundImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "mainImage")
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
        burgerImage.layer.opacity = 0.9
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
    
    private lazy var menuButton: UIButton = {
        let button = UIButton()
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
        
        containerEmpty.isHidden = !(model.cells.isEmpty)
        containerFull.isHidden = (model.cells.isEmpty)
        
        tableView.reloadData()
    }
}

private extension CartViewController {
    func addSubViews() {
        view.addSubViews(
            backgroundImage,
            containerEmpty,
            containerFull
        )
        
        containerEmpty.addSubViews(
            halfBlackView,
            emptyBurgerImage,
            titleLabel,
            descriptionLabel,
            menuButton
        )
        
        containerFull.addSubViews(
            tableView
        )
    }
    
    @objc private func openMainVC() {
        let vc = MainTabBarController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
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
        Edges()
        )
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
        let cartModel = model.cells[indexPath.row]
        cell.model = cartModel
        return cell
    }
}
