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
    
    private lazy var backgroundImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "mainImage")
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var overLayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.7)
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(AdditiveCell.self, forCellReuseIdentifier: "AdditiveCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
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
        let button = UIButton(type: .system)
        button.maskCorners(radius: 15)
        button.setTitle("Добавить в корзину", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32 , height: 54)
        button.applyGradient(fromColor: UIColor(hex: "FF5929"),
                             toColor: UIColor(hex: "993C1F"),
                             fromPoint: CGPoint(x: 0.5, y: 0),
                             toPoint: CGPoint(x: 0.5, y: 1),
                             location: [0, 1])
        
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
        
        if let url = modelProduct?.imageURL {
            pictureImage.kf.setImage(with: url)
        }
        
        //TO DO: move replacingOccurrences in maping
        var descriptionText = modelProduct?.description
        descriptionText = descriptionText?.replacingOccurrences(of: "<p>", with: "")
        descriptionText = descriptionText?.replacingOccurrences(of: "</p>", with: "")

        descriptionLabel.text = descriptionText
        nameLabel.text = modelProduct?.name
        
        quantityLabel.text = "\(Int(quantityStepper.value))"
        
        if let price = modelProduct?.price {
            priceLabel.text = "\(price) ₽"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }    
}

//MARK: - DetailsProductViewController
private extension DetailsProductViewController {
    func addSubViews() {
        view.addSubviews(backgroundImage, overLayView)
        view.addSubview(scrollView)

        scrollView.addSubview(contentView)
        contentView.addSubviews(pictureImage,
                                descriptionLabel,
                                orderButton,
                                nameLabel,
                                quantityStepper,
                                quantityLabel,
                                priceLabel,
                                tableView)
    }
    
    
    @objc func buttonTapped() {
        //Все выбранные добавки
        let selectedAdditives = additives.filter({ $0.selected }).map { $0.name }
        guard let product = modelProduct else { return }
        
        let cell = CartCellViewModel(title: product.name,
                                     price: calculateSum(),
                                     additives: selectedAdditives,
                                     imageURL: product.imageURL,
                                     count: Int(quantityStepper.value),
                                     categoryId: product.categories.first?.id ?? 0,
                                     uuid: UUID())
        
        mergeDoubleOrAddInDataStore(cell)
        showDoneView()
        navigationController?.popViewController(animated: true)
    }
    
    private func mergeDoubleOrAddInDataStore(_ cell: CartCellViewModel) {
        let copy = DataStore.shared.cartViewModel.cells.filter { $0.title == cell.title }.first(where: { product in
            let isCopy: Bool
            
            if product.additives.count == cell.additives.count {
                isCopy = product.additives.allSatisfy({ cell.additives.contains($0) })
            } else {
                isCopy = false
            }
            return isCopy
        })

        //Если нашли копию то увеличиваем счетчик
        if copy != nil, let index = DataStore.shared.cartViewModel.cells.firstIndex(where: { $0.uuid == copy?.uuid }) {
            DataStore.shared.cartViewModel.cells[index].count += cell.count
            DataStore.shared.cartViewModel.cells[index].price += cell.price
        }
        //Иначе добавляем новый эллемент
        else {
            DataStore.shared.cartViewModel.cells.append(cell)
        }
    }
    
    @objc func stepperValueChanged(_ sender: UIStepper) {
        let intValue = Int(sender.value)
        quantityLabel.text = "\(intValue)"
        priceLabel.text = "\(calculateSum()) ₽"
    }


    func setupConstraints() {
        backgroundImage.easy.layout(
            Edges()
        )
        overLayView.easy.layout(
            Edges()
        )
        scrollView.easy.layout(
            Top().to(view.safeAreaLayoutGuide, .top),
            Left(), Right(),
            Bottom()
        )
        contentView.easy.layout(
            Edges(),
            Width(UIScreen.main.bounds.width)
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
            Height(54),
            Bottom(10)
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
        let selectedAdditive = additives.filter { $0.selected }.compactMap { Double($0.price) }
        let priceProduct = Double(modelProduct?.price ?? "") ?? 0
        let counter = Double(quantityStepper.value)
    
        let totalSumAdditive = selectedAdditive.reduce(0, { $0 + $1 }) * counter
        let totalSumProducts = priceProduct * counter
        return Int(totalSumAdditive + totalSumProducts)
    }
    
    func showDoneView() {
        let window = UIApplication.appDelegate.window ?? UIView()
        let containerView = UIView()
        containerView.alpha = 0
        containerView.backgroundColor = .black.withAlphaComponent(0.8)
        containerView.maskCorners(radius: 10)
        containerView.frame = CGRect(x: (window.frame.width / 2) - 50,
                                     y: (window.frame.height / 2) - 50,
                                     width: 100,
                                     height: 100)
        
        let imageView = UIImageView(image: UIImage(named: "done")?.withRenderingMode(.alwaysOriginal))
        imageView.frame = CGRect(x: 12.5, y: 12.5, width: 75, height: 75)
        
        window.addSubview(containerView)
        containerView.addSubview(imageView)
        
        containerView.fadeIn {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                containerView.fadeOut {
                    containerView.removeFromSuperview()
                }
            }
        }
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
