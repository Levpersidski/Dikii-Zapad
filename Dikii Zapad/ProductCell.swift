//
//  ProductCell.swift
//  Dikii Zapad
//
//  Created by Роман Бакаев on 26.09.2023.
//

import UIKit
import EasyPeasy

enum TypeCell {
    case burger
    case drink
    case pizza
}

struct ProductCellViewModel {
    let title: String
    let price: String
    let image: UIImage?
    
    let type: TypeCell
}

class ProductCell: UICollectionViewCell {
//    private lazy var containerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .white.withAlphaComponent(0.2)
//        view.layer.cornerRadius = 20
//        return view
//    }()
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.layer.borderColor = UIColor.orange.cgColor
        image.layer.cornerRadius = 20
        image.layer.borderWidth = 1
        return image
    }()
    
    private lazy var labelName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
  
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    var model: ProductCellViewModel?
    private lazy var widthCell: CGFloat = (UIScreen.main.bounds.size.width / 2) - 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//
//        UIView.animate(withDuration: 0.2) {
//            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//        }
//    }
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesEnded(touches, with: event)
//        UIView.animate(withDuration: 0.2) {
//            self.transform = .identity
//        }
//    }
    
    func update(_ model: ProductCellViewModel) {
        self.model = model
        labelName.text = model.title
        image.image = model.image
        priceLabel.text = model.price
    }
    
    private func setupView() {
        addSubview(image)
        addSubview(labelName)
        addSubview(priceLabel)
        
//        backgroundColor = .white.withAlphaComponent(0.2)
        image.clipsToBounds = true
    }
    
    private func setupConstrains() {
        let heightImage = (widthCell * 1.25) * 0.7
        
        image.easy.layout(
            Top(), Left(), Right(), Height(heightImage)
        )
        
        labelName.easy.layout(
            Top(10).to(image, .bottom), Left(), Right()
        )
        
        priceLabel.easy.layout(
            Top(10).to(labelName, .bottom), Left(), Right()
        )
    }
    
    override func prepareForReuse() {
        labelName.text = nil
        image.image = nil
        priceLabel.text = nil
        super.prepareForReuse()
    }
}
