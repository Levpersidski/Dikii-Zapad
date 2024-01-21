//
//  CartCell.swift
//  Dikii Zapad
//
//  Created by Роман Бакаев on 19.11.2023.
//

import UIKit
import EasyPeasy


struct CartCellViewModel {
    let title: String
    let price: String
    let additives: [String]
    let imageURL: URL?
    
    let count: Int
}

class CartCell: UITableViewCell {
    
    var isLast: Bool = false {
        didSet {
            separatorView.isHidden = isLast
        }
    }
    
    private lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.borderColor = UIColor.customOrange.withAlphaComponent(0.5).cgColor
        image.layer.cornerRadius = 8
        image.layer.borderWidth = 1
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var productNameLabel: UILabel = {
        let name = UILabel()
        name.font = UIFont(name: "Capture it", size: 20)
        name.textColor = .white
        name.numberOfLines = 0
        return name
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        return stack
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.font = UIFont.systemFont(ofSize: 25)
        return label
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.font = UIFont.systemFont(ofSize: 25)
        return label
    }()
    
    private lazy var separatorView: UIView = {
       let view = UIView()
        view.backgroundColor = .orange
        return view
    }()
    
    var model: CartCellViewModel? = nil {
        didSet {
            guard let model = model else { return }
            
            productNameLabel.text = model.title
            if let url = model.imageURL {
                image.kf.setImage(with: url)
            }
            
            priceLabel.text = "\(model.price) РУБ."
            countLabel.text = "\(model.count) шт."
            
            stack.removeAllArrangedSubviews()
            
            if !model.additives.isEmpty {
                model.additives.forEach { additiveName in
                    let label = UILabel()
                    label.font = .systemFont(ofSize: 16)
                    label.text = "+ \(additiveName)"
                    label.textColor = .white
                    
                    stack.addArrangedSubview(label)
                }
            }
            
        }
    }
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        
        setupView()
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        contentView.addSubview(containerView)
        
        containerView.addSubViews(
            image,
            productNameLabel,
            stack,
            priceLabel,
            countLabel,
            separatorView
        )
    }
    
    private func setupConstrains() {
        containerView.easy.layout(
            Edges(),
            Height(>=148)
        )
      
        image.easy.layout(
            Top(16),
            Left(16),
            Size(116)
        )
        
        productNameLabel.easy.layout(
            Top(26),
            Left(17).to(image, .right),
            Right(17)
        )
        
        stack.easy.layout(
            Top(10).to(productNameLabel, .bottom),
            Left(17).to(image, .right),
            Right(17)
        )
        
        priceLabel.easy.layout(
            Top(26).to(stack, .bottom),
            Right(30)
        )
        
        countLabel.easy.layout(
            Top().to(priceLabel, .top),
            Left().to(productNameLabel, .left)
        )

        separatorView.easy.layout(
            Top(25).to(priceLabel, .bottom),
            Height(1),
            Left(16), Right(16),
            Bottom()
        )
    }
}

extension UIStackView {
    func removeAllArrangedSubviews() {
        for subView in arrangedSubviews {
            removeArrangedSubview(subView)
            subView.removeFromSuperview()
        }
    }
}
