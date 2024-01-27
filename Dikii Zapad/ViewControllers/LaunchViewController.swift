//
//  LaunchViewController.swift
//  Dikii Zapad
//
//  Created by Роман Бакаев on 03.10.2023.
//

import UIKit
import EasyPeasy

final class LaunchViewController: UIViewController {
    private var endedWelcomeTime = false
    private var hasData = false
    private let dataService = ProductsDataService.shared
    
    private var backgroundImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "backgroundImage")
        return view
    }()
    
    private lazy var blackOverlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 20
        view.alpha = 0.7
        return view
    }()
    
    private lazy var burgerImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "burgerImage"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var logoImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logoImage"))
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.0 // Устанавливаем начальное значение прозрачности в 0
        return imageView
    }()
    
    private lazy var logoLabel: UILabel = {
        let label = UILabel()
        label.text = "ДИКИЙ ЗАПАД"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Capture it", size: 50)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true // Разрешаем уменьшение размера шрифта
        label.minimumScaleFactor = 0.5 // Минимальный размер шрифта (по умолчанию 0.5)
        label.alpha = 0.0
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.tintColor = .white
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstrains()
        
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logoImage.fadeIn(1.5)
        logoLabel.fadeIn(1.5)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.endedWelcomeTime = true
            self?.tryOpenApp()
        }
    }
    
    private func setupView() {
        view.addSubViews(backgroundImage,
                         logoImage,
                         burgerImage,
                         logoLabel,
                         blackOverlayView,
                         activityIndicator)
    }
    
    private func setupConstrains() {
        logoImage.easy.layout(
            Top(100).to(view.safeAreaLayoutGuide, .top),
            CenterX(),
            Size(60)
        )
        logoLabel.easy.layout(
            Top(30).to(logoImage, .bottom),
            CenterX(),
            Left(30),
            Right(30)
        )
        burgerImage.easy.layout(
            Bottom(-200),
            CenterX(15),
            Size(930)
        )
        backgroundImage.easy.layout(
            Edges()
        )
        blackOverlayView.easy.layout(
            Edges()
        )
        activityIndicator.easy.layout(
            Top(20).to(logoLabel, .bottom),
            CenterX(),
            Size(20)
        )
        
        activityIndicator.transform = CGAffineTransform.init(scaleX: 2, y: 2)
    }
    
    private func tryOpenApp() {
        guard endedWelcomeTime && hasData else {
            return
        }
        let mainViewController = MainTabBarController()
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.pushViewController(mainViewController, animated: true)
    }
    
    
    private func loadData() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()

        dataService.downloadProduct() { [weak self] hasData in
            guard let self = self else { return }
            self.hasData = hasData
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            
            if hasData {
                self.tryOpenApp()
            } else {
                self.showAlert("Что то пошло не так",
                               message: "Не удалось загрузить меню",
                               okTitle: "Повторить",
                               present: true,
                               completion: { [weak self] in
                    self?.loadData()
                })
            }
        }
    }
}

