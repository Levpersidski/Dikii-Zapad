//
//  ActionsViewController.swift
//  Dikii Zapad
//
//  Created by Роман Бакаев on 03.10.2023.
//

import UIKit
import EasyPeasy

class ActionsViewController: UIViewController {

    private lazy var backgroundImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "mainImage")
        return image
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        // Do any additional setup after loading the view.
    }
    

   

}

private extension ActionsViewController {
    
    func setupViews() {
        view.addSubViews(backgroundImage)
        
    }
    
    
    func setupConstraints() {
        backgroundImage.easy.layout(
            Edges()
        )
    }
}
