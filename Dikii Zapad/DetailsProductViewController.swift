//
//  DetailsProductViewController.swift
//  Dikii Zapad
//
//  Created by Роман Бакаев on 26.09.2023.
//

import UIKit
import EasyPeasy

class DetailsProductViewController: UIViewController {
    
    var modelProduct: Product?
    
    private lazy var pictureImage: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pictureImage.image = modelProduct?.image
        view.addSubview(pictureImage)
        view.backgroundColor = .white
        
        pictureImage.easy.layout(
            Center(), Size(300)
        )
    }
}
