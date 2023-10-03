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
    
    
    let burgerImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "burgerImage"))
       imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let logoImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logoImage"))
        imageView.contentMode = .scaleAspectFit
      // imageView.alpha = 1.0 // Устанавливаем начальное значение прозрачности в 0
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupView()
       view.insertSubview(backgroundImage, at: 0)
    

        
        // Анимация появления logoImage с затуханием
//        UIView.animate(withDuration: 1.0) {
//            self.logoImage.alpha = 1.0 // Устанавливаем конечное значение прозрачности в 1
//        }

//        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [weak self] _ in
//            guard let self = self else { return }
//            let mainViewController = MainViewController()
//            mainViewController.modalPresentationStyle = .fullScreen
//            self.present(mainViewController, animated: true, completion: nil)
//        }
    }

    private func setupView() {
        view.addSubViews( logoImage, backgroundImage)
        
    }
    
    private func setupLayout() {
        
        logoImage.easy.layout(
        Top(30).to(view.safeAreaLayoutGuide, .top),
        CenterX(),
        Size(300)

        )
        
        burgerImage.easy.layout(
        Top(10).to(logoImage, .bottom),
        Right(30),
        Left(30)
        )
        
        backgroundImage.easy.layout(
            Edges()
        )
        
    }
}

