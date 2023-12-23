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
    var additives: [AdditiveProduct] = []
    
    private let heightCell: CGFloat = 40
    
    // MARK: - Private Propery
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(AdditiveCell.self, forCellReuseIdentifier: "AdditiveCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private lazy var contentView: UIView = {
        UIView(frame: .zero)
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrolview = UIScrollView(frame: .zero)
        scrolview.showsVerticalScrollIndicator = false
        scrolview.backgroundColor = .clear
        scrolview.contentSize = contentCize
        scrolview.frame  = view.bounds
        return scrolview
    }()
    
    private var contentCize: CGSize {
        CGSize(width: view.bounds.width, height: view.bounds.height + 200)
    }
    
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
        image.layer.borderColor = UIColor.customOrange.withAlphaComponent(0.5).cgColor
        image.layer.borderWidth = 1
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
        button.backgroundColor = UIColor.customOrange
        button.layer.cornerRadius = 15
        button.setTitle("Добавить в корзину", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.customOrange
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
    
    private lazy var quantityStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 1
        stepper.maximumValue = 99
        stepper.tintColor = UIColor.customOrange
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
        label.textColor = UIColor.customOrange
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.clipsToBounds = true
        label.layer.cornerRadius = 5
        label.isUserInteractionEnabled = false
        return label
    }()
    
    private lazy var widthImage: CGFloat = (UIScreen.main.bounds.size.width)
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setupConstraints()
        
        pictureImage.image = modelProduct?.image
        descriptionLabel.text = modelProduct?.description
        nameLabel.text = modelProduct?.name
        
        quantityLabel.text = "\(Int(quantityStepper.value))"
        
        if let price = modelProduct?.price {
            priceLabel.text = "\(modelProduct?.price ?? 0 ) ₽"
        }

    }
}

//MARK: - DetailsProductViewController
private extension DetailsProductViewController {
    func addSubViews() {
        view.addSubview(backgroundImage)
        view.addSubview(scrollView)

        scrollView.addSubview(contentView)
        contentView.addSubViews(pictureImage,
                                descriptionLabel,
                                orderButton,
                                nameLabel,
                                quantityStepper,
                                quantityLabel,
                                priceLabel,
                                tableView)
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
        
        //Все выбранные добавки
        let selectedAdditives = additives.filter({ $0.selected }).map { $0.name }
        guard let product = modelProduct else { return }
        
        let cell = CartCellViewModel(title: product.name,
                                     price: ("\(product.price)"),
                                     additives: selectedAdditives,
                                     image: product.image,
                                     count: 0)
        
        DataStore.shared.cartViewModel.cells.append(cell)
    }
    
    @objc func stepperValueChanged(_ sender: UIStepper) {
        priceLabel.text = "\(calculateSum()) ₽"
    }


    func setupConstraints() {
        contentView.easy.layout(
            Height(+200).like(scrollView),
            Width().like(scrollView)
        )
    
        
        backgroundImage.easy.layout(
            Edges()
        )
        
        nameLabel.easy.layout(
            Top(20).to(scrollView, .top),
            Left(20),
            Right(20)
        )
        
        pictureImage.easy.layout(
            Top(20).to(nameLabel, .bottom),
            Left(20),
            Right(20),
            Height(widthImage)
        )
        
        descriptionLabel.easy.layout(
            Top(35).to(pictureImage, .bottom),
            Left(30),
            Right(30)
        )
        
        tableView.easy.layout(
            Top(35).to(descriptionLabel, .bottom),
            Left(),
            Right(),
            Height(heightCell * CGFloat(additives.count))
        )
        
        orderButton.easy.layout(
            Top(50).to(tableView, .bottom),
            Left(30), Right(30),
            Height(60)
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
    
    func calculateSum() -> Int {
        let selectedAdditive = additives.filter { $0.selected }.map { $0.price }
        let priceProduct = modelProduct?.price ?? 0
        let counter = Int(quantityStepper.value)
    
        let totalSumAdditive = selectedAdditive.reduce(0, { $0 + $1 }) * counter
        let totalSumProducts = priceProduct * counter
        return totalSumAdditive + totalSumProducts
    }
}


//MARK: - UITableViewDataSource, UITableViewDelegate
extension DetailsProductViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return additives.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AdditiveCell", for: indexPath) as? AdditiveCell else {
            return UITableViewCell()
        }
        
        let additive = additives[indexPath.row]
        cell.delegate = self
        cell.index = indexPath.row
        cell.backgroundColor = UIColor.clear
        cell.configure(additive: additive)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        heightCell
    }
}

extension DetailsProductViewController: AdditiveCellDelegate {
    func checkBoxDidTap(index: Int) {
        additives[index].selected = !additives[index].selected
        priceLabel.text = "\(calculateSum()) ₽"
    }
}
