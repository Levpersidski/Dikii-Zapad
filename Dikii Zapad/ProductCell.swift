//
//  ProductCell.swift
//  Dikii Zapad
//
//  Created by Роман Бакаев on 26.09.2023.
//

import UIKit
import EasyPeasy

enum TypeProduct: Int {
    case burger
    case pizza
    case hotDog
    case snack
    case milkshake
    case coffeeDrinks
    case desserts
    case drink
}

struct ProductCellViewModel {
    let title: String
    let price: String
    let image: UIImage?
    let imageURL: URL? = nil
    
    let type: TypeProduct
}

class ProductCell: UICollectionViewCell {
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .customClearGray
        view.layer.cornerRadius = 15
        return view
    }()
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.borderColor = UIColor.customOrange.withAlphaComponent(0.5).cgColor
        image.layer.cornerRadius = 8
        image.layer.borderWidth = 1
        return image
    }()
    
    private lazy var whiteOverlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.0 // Задайте нужную прозрачность (от 0.0 до 1.0)
        view.layer.cornerRadius = 20
        return view
    }()

    
    private lazy var labelName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Capture it", size: 13)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        //label.adjustsFontSizeToFitWidth = true // Разрешаем уменьшение размера шрифта
        label.minimumScaleFactor = 0.5 //
        return label
    }()
  
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .customOrange
        label.textAlignment = .center
        return label
    }()
    
    
    var model: ProductCellViewModel?
    private lazy var widthCell: CGFloat = (UIScreen.main.bounds.size.width / 2) - 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstrains()
      //  shadowSettingCell()
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //методы по нажатию и отпусканию на экран
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        UIView.animate(withDuration: 0.1) {
           // self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.whiteOverlayView.alpha = 0.5
            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
           resetCellState()
    }
    
    // Если касание было отменено (например, при скроллинге)...
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        resetCellState()
    }

    // Эта функция восстанавливает исходное состояние ячейки после касания.
    private func resetCellState() {
        UIView.animate(withDuration: 0.2) {
            self.transform = .identity
            self.whiteOverlayView.alpha = 0.0
        }
    }
    
    func update(_ model: ProductCellViewModel) {
        self.model = model
        labelName.text = model.title
        image.image = model.image
        priceLabel.text = "\(model.price) РУБ."
        
//        image.image = Ui
    }
    
    private func setupView() {
        addSubview(containerView)
        addSubview(image)
        addSubview(labelName)
        addSubview(priceLabel)
        addSubview(whiteOverlayView)
//        backgroundColor = .white.withAlphaComponent(0.2)
        image.clipsToBounds = true
    }
    
//    private func shadowSettingCell() {
//        let path = UIBezierPath(roundedRect: bounds, cornerRadius: 20).cgPath
//        self.backgroundColor = .clear
//        self.layer.cornerRadius = 20
//        self.layer.shadowColor = UIColor.customOrange.cgColor
//        self.layer.shadowOffset = CGSize(width: 4, height: 4)
//        self.layer.shadowOpacity = 0.2
//        self.layer.shadowRadius = 5
//        self.layer.shadowOffset = CGSize(width: 0, height: 3)
//        self.layer.shadowPath = path
//        
//    }
    
    private func setupConstrains() {
        let heightImage = (widthCell * 1.25) * 0.7
        
        containerView.easy.layout(
            Edges()
        )
        image.easy.layout(
            Top(8), Left(8), Right(8), Height(heightImage)
        )
        labelName.easy.layout(
            Top(10).to(image, .bottom), Left(), Right()
        )
        priceLabel.easy.layout(
            Top(8).to(labelName, .bottom),
            CenterX().to(labelName)
        )
        whiteOverlayView.easy.layout(
            Top(), Left(), Right(), Height(heightImage)
        )
    }
}
