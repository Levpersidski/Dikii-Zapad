//
//  LaunchViewController.swift
//  Dikii Zapad
//
//  Created by Роман Бакаев on 03.10.2023.
//

import UIKit
import EasyPeasy

final class LaunchViewController: UIViewController {
    
    private var backgroundImage: UIImageView = {
        let View = UIImageView()
        View.contentMode = .scaleAspectFill
        View.image = UIImage(named: "backgroundImage")

        return View
    }()
    
    private lazy var blackOverlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 20
        view.alpha = 0.7
        return view
    }()
    
    
    let burgerImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "burgerImage"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let logoImage: UIImageView = {
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
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
      
       view.insertSubview(backgroundImage, at: 0)
        view.insertSubview(blackOverlayView, at: 1)
        view.insertSubview(logoImage, at: 2)

        
         // Анимация появления logoImage с затуханием
        UIView.animate(withDuration: 2.0) {
            self.logoImage.alpha = 1// Устанавливаем конечное значение прозрачности в 1
            self.logoLabel.alpha  = 1
        }

        Timer.scheduledTimer(withTimeInterval: 4.0, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            let mainViewController = MainTabBarController()
            navigationController?.setNavigationBarHidden(true, animated: false)
            navigationController?.pushViewController(mainViewController, animated: true)
        }
    }

    private func setupView() {
        view.addSubViews( logoImage, backgroundImage, burgerImage,logoLabel, blackOverlayView)
        
    }
    
    private func setupLayout() {
        
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
        
    }
}

