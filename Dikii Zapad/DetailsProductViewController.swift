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
    
    private lazy var backgroundImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "mainImage")
        return image
    }()
    
    private lazy var pictureImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let text  = UILabel()
        text.textColor = .white
        text.numberOfLines = 0
        text.textAlignment = .left
        text.font = UIFont.systemFont(ofSize: 14)
        return text
    }()
    
    private lazy var orderButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hex: "#FE6F1F")
        button.layer.cornerRadius = 15
        button.setTitle("Добавить в корзину", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
       

        return button
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "#FE6F1F")
        label.textAlignment = .center
        label.font = UIFont(name: "Capture it", size: 50)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true // Разрешаем уменьшение размера шрифта
        label.minimumScaleFactor = 0.5 // Минимальный размер шрифта (по умолчанию 0.5)
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.textColor = UIColor.white
        priceLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 20, weight: .bold)
        priceLabel.font = UIFont.systemFont(ofSize: 25)
        return priceLabel
    }()
    
    
    
    let quantityStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 0
        stepper.maximumValue = 10
        stepper.tintColor = UIColor(hex: "#FE6F1F")
        stepper.value = 1 // начальное значение
        stepper.frame = CGRect(x: stepper.frame.origin.x, y: stepper.frame.origin.y, width: stepper.frame.size.width, height: 10)

        stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
        stepper.setDecrementImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
               stepper.setIncrementImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
               stepper.setIncrementImage(UIImage(systemName: "plus.circle"), for: .highlighted)
        return stepper
    }()
    
    
    let quantityLabel: UILabel = {
           let label = UILabel()
           label.text = ""
        label.backgroundColor = .clear
//        label.layer.borderColor = UIColor(hex: "#FE6F1F").cgColor
//        label.layer.borderWidth = 1
        label.textColor = UIColor(hex: "#FE6F1F")
           label.textAlignment = .center
           label.font = UIFont.systemFont(ofSize: 16)
        label.clipsToBounds = true
        label.layer.cornerRadius = 5
        label.isUserInteractionEnabled = false
           return label
       }()

    
    private lazy var widthImage: CGFloat = (UIScreen.main.bounds.size.width)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setupConstraints()
        view.insertSubview(backgroundImage, at: 0)
        pictureImage.image = modelProduct?.image
        descriptionLabel.text = modelProduct?.description
        nameLabel.text = modelProduct?.name
        quantityLabel.text = "\(Int(quantityStepper.value))"
        
        
        if let price = modelProduct?.price {
            priceLabel.text = "\(modelProduct?.price ?? 0 ) ₽"
        }


    
    }
}
private extension DetailsProductViewController {
    func addSubViews() {
        view.addSubViews(pictureImage,
                         descriptionLabel,
                         orderButton,
                         nameLabel,
                         quantityStepper,
                         quantityLabel,
                         priceLabel
        )
    }
    
    
    @objc func buttonTapped() {
        UIView.animate(withDuration: 0.5, animations: { [] in
           
            self.orderButton.backgroundColor = UIColor.green
            self.orderButton.layer.borderWidth = 2
            // Измените размер кнопки
            self.orderButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.pictureImage.transform = CGAffineTransform(scaleX: 2.2, y: 2.2)
            
        }) { _ in
            // По завершении анимации можете выполнить дополнительные действия
            self.dismiss(animated: true)
        }
    }
    
    @objc func stepperValueChanged(_ sender: UIStepper) {
        // Обновляем значение UILabel при изменении UIStepper
        let intValue = Int(sender.value)
        quantityLabel.text = "\(intValue)"

        // Расчет новой цены на основе количества
        if let price = modelProduct?.price {
            let totalPrice = intValue * price
            priceLabel.text = "\(totalPrice) ₽"
        }
    }


   
    
    func setupConstraints() {
        backgroundImage.easy.layout(
            Edges()
        )
        pictureImage.easy.layout(
            Top(20).to(nameLabel, .bottom),
            Left(20),
            Right(20),
            Height(widthImage)
            
        )
        descriptionLabel.easy.layout(
            Top(20).to(pictureImage, .bottom),
            Left(30),
            Right(30)
            
        )
        orderButton.easy.layout(
            Top(50).to(descriptionLabel, .bottom),
            Left(30),
            Right(30),
            Height(60)
            
        )
        nameLabel.easy.layout(
            Top(20).to(view.safeAreaLayoutGuide, .top),
            Left(20),
            Right(20)
            
        )
        
        quantityStepper.easy.layout(
            Bottom(10).to(orderButton, .top),
            Left(30),
            Height(30)
            
        )
        
        quantityLabel.easy.layout(
            CenterX().to(quantityStepper, .centerX),
            CenterY().to(quantityStepper, .centerY),
            Height().like(quantityStepper),
            Width(30)
            )
        
        priceLabel.easy.layout(
            Bottom(10).to(orderButton, .top),
            Right(30),
            Height(30)
            
        )
           
            
        
        
    }
}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}






