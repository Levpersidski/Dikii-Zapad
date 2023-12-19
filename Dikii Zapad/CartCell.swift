//
//  CartCell.swift
//  Dikii Zapad
//
//  Created by Роман Бакаев on 19.11.2023.
//

import UIKit
import EasyPeasy


struct CartCellVIewModel {
    let title: String
    let price: String
    let description: String
    let image: UIImage?
    
    let type: TypeCell
}

class cartCell: UICollectionViewCell {
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.borderColor = UIColor.customOrange.withAlphaComponent(0.5).cgColor
        image.layer.cornerRadius = 8
        image.layer.borderWidth = 1
        return image
    }()
    
    private var productNameLabel: UILabel = {
        let name = UILabel()
        name.font = UIFont(name: "Capture it", size: 12)
        name.textColor = .white
        name.textAlignment = .center
        name.numberOfLines = 0
        name.minimumScaleFactor = 0.5
    return name
        
    }()
    
    
    private var  descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Здесь должна быть ваша добавка", size: 12)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        return label
        
    }()
    
    private var priceLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 20, weight: .bold)
        label.font = UIFont.systemFont(ofSize: 25)
        return label
    }()
    
    let quantityStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 0
        stepper.maximumValue = 10
        stepper.tintColor = UIColor.customOrange
        stepper.value = 1 // начальное значение
        stepper.frame = CGRect(x: stepper.frame.origin.x, y: stepper.frame.origin.y, width: stepper.frame.size.width, height: 10)
        
      //  stepper.addTarget(self, action: #selector(), for: .valueChanged)
        stepper.setDecrementImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        stepper.setIncrementImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        stepper.setIncrementImage(UIImage(systemName: "plus.circle"), for: .highlighted)
        return stepper
    }()
    
    var model: CartCellVIewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstrains()
      //  shadowSettingCell()
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func update(_ model: CartCellVIewModel) {
        self.model = model
        productNameLabel.text = model.title
        image.image = model.image
        priceLabel.text = "\(model.price) РУБ."
        descriptionLabel.text = "\(model.description)"
    }
    
    private func setupView() {
        addSubview(image)
        addSubview(productNameLabel)
        addSubview(descriptionLabel)
        addSubview(priceLabel)
        addSubview(quantityStepper)
        
   
        
//        backgroundColor = .white.withAlphaComponent(0.2)
        image.clipsToBounds = true
    }
    
    
    private func setupConstrains() {
        image.easy.layout(
            Top(8), Left(8), Right(8), Height(40)
        )
        
        productNameLabel.easy.layout(
            Top(10).to(image, .bottom), Left(), Right()
        )
        
        priceLabel.easy.layout(
            Top(8).to(productNameLabel, .bottom),
            CenterX().to(productNameLabel)
        )
        descriptionLabel.easy.layout(
            Top(8).to(priceLabel, .bottom),
            CenterX().to(priceLabel)
        )
        
        quantityStepper.easy.layout(
            Top(8).to(descriptionLabel, .bottom),
            CenterX().to(descriptionLabel)
    )
    }
    
}
