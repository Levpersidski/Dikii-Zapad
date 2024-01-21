//
//  ViewController.swift
//  Dikii Zapad
//
//  Created by Роман Бакаев on 24.09.2023.
//

import UIKit
import EasyPeasy

final class MainViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    //MARK: - Private Property

    private var sectionLabels: [String] = ["Бургеры", "Пиццы", "Хот-Доги",
                                           "Снеки", "Милкшейки", "Лимонады",
                                           "Кофе", "Десерты", "Напитки"]
    
    
    private var backgroundView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "mainImage")
        return imageView
    }()
    
    private lazy var blackOverlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 10
        view.alpha = 0.7
        return view
    }()
    
    private lazy var greyOverlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .customClearGray
        view.layer.cornerRadius = 10
        view.alpha = 1
        return view
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["На доставку", "На вынос"])
        segment.selectedSegmentTintColor = .customOrange
        segment.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        segment.selectedSegmentIndex = 1
        segment.layer.cornerRadius = 8
        segment.addTarget(self, action: #selector(segmentedValueChanged), for: .valueChanged)
        segment.backgroundColor = .customClearGray
        return segment
    }()
    
    private lazy var stripsView: UIView = {
        let strips = UIView()
        strips.backgroundColor = .customGrey
        strips.layer.cornerRadius = 2
        return strips
    }()
    
    private lazy var buttonToDelivery: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("Ул. Советской конституции 21", for: .normal)
        button.addTarget(self, action: #selector(didTouchToToDelivery), for: .touchUpInside)
        button.setTitleColor(.customOrange, for: .normal)
        button.isEnabled = false
        return button
    }()
    
    private lazy var scrollForButtons: UIScrollView = {
        let scroll = UIScrollView()
        scroll.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    }()
    
    private lazy var stackButtons: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }()
    
    private lazy var verticalСollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        
        //Отступ между ячейками (верх низ)
        collectionViewLayout.minimumLineSpacing = 30
        
        //отступ между ячейками (лево право)
        collectionViewLayout.minimumInteritemSpacing = 5
        
        collectionViewLayout.itemSize = CGSize(width: sizeCell, height: sizeCell * 1.25)
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 30, left: 10, bottom: 20, right: 10)
        //        collectionViewLayout.minimumLineSpacing = 20
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //тут неповторяющее название TestCellIdent
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: "ProductCell")
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = true
        return collectionView
    }()
    
    private lazy var sizeCell: CGFloat = (UIScreen.main.bounds.size.width / 2) - 20
    private lazy var minimumLineSpacing: CGFloat = 2
    
    var burgers: [Product]?
    var pizzas: [Product]?
    var hotdogs:[Product]?
    var snacks:[Product]?
    var milkshakes:[Product]?
    var lemonades:[Product]?
    var coffeeDrinks:[Product]?
    var desserts:[Product]?
    var drinks: [Product]?
    
    //MARK: - ViewDidLOad()
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setupConstraints()
        setupModels()
        setupScrollButtons()

        navigationController?.setNavigationBarHidden(true, animated: false)
        
        //регистрация вью  для заголовков секций
        verticalСollectionView.register(SectionHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
    }
    
    private func openDetailProductVC(_ modelProduct: Product, _ modelAdditive: [AdditiveProduct]) {
        let vc = DetailsProductViewController()
        vc.modelProduct = modelProduct
        vc.additives = modelAdditive
        present(vc, animated: true)
    }
    
    @objc func didTouchToToDrinks(sender: UIButton) {
        let section = sender.tag
        guard verticalСollectionView.numberOfSections > section else { return }
        
        verticalСollectionView.scrollToItem(at: IndexPath(item: 0, section: section), at: .top, animated: true)
    }
    
    @objc func segmentedValueChanged(sender: UISegmentedControl) {
        
        let selectedIndex = sender.selectedSegmentIndex
        if selectedIndex == 0 {
            buttonToDelivery.setTitle("Указать адресс доставки >", for: .normal)
            buttonToDelivery.isEnabled = true
        } else {
            buttonToDelivery.setTitle("Ул. Советской конституции 21", for: .normal)
        }
    }
    
    @objc func didTouchToToDelivery() {
        let deliveryFormVC = DeliveryFormViewController()
        navigationController?.pushViewController(deliveryFormVC, animated: true)
    }

}

//MARK: - Setting
    private extension MainViewController {
        func addSubViews() {
            view.addSubViews(
                backgroundView,
                blackOverlayView,
                greyOverlayView,
                stripsView,
                buttonToDelivery,
                segmentedControl,
                scrollForButtons,
                verticalСollectionView
            )
            
            scrollForButtons.addToScrollView(stackButtons)
        }
        
        func setupConstraints() {
            backgroundView.easy.layout(
                Edges()
            )
            blackOverlayView.easy.layout(
                Edges()
            )
            greyOverlayView.easy.layout(
                Top(25).to(view.safeAreaLayoutGuide, .top),
                CenterX(),
                Right(16),
                Left(16),
                Height(122)
            )
            segmentedControl.easy.layout(
                Top(20).to(greyOverlayView, .top),
                CenterX(),
                Right(27),
                Left(27),
                Height(35)
            )
            stripsView.easy.layout(
                Top(15).to(segmentedControl, .bottom),
                Width().like(segmentedControl),
                Height(1.5),
                CenterX()
            )
            buttonToDelivery.easy.layout(
                Top(10).to(stripsView, .bottom),
                Width(-40).like(stripsView),
                Height(30),
                CenterX()
            )
            
            scrollForButtons.easy.layout(
                Top(20).to(greyOverlayView, .bottom),
                Left(), Right(),
                Height(35)
            )
            
            stackButtons.easy.layout( Edges() )
            
            verticalСollectionView.easy.layout(
                Top(10).to(stackButtons, .bottom),
                Left(),
                Right(),
                Bottom()
            )
        }
        
        func setupModels() {
            burgers = DataStore.shared.burgers
            pizzas = DataStore.shared.pizzas
            hotdogs = DataStore.shared.hotdogs
            snacks = DataStore.shared.snacks
            milkshakes = DataStore.shared.milkshakes
            lemonades = DataStore.shared.lemonades
            coffeeDrinks = DataStore.shared.coffeeDrinks
            desserts = DataStore.shared.desserts
            drinks = DataStore.shared.drinks
            
            verticalСollectionView.reloadData()
        }
        
        func setupScrollButtons() {
            let titleButtons: [String] = ["Бургеры", "Пицца", "Хот-Доги", "Снеки", "Милкшейки", "Лимонады", "Кофе", "Десерты", "Напитки" ]
            
            titleButtons.enumerated().forEach { (index, title) in
                let btn = CustomButton(title: title,
                                       backgroundColor: .customClearGray,
                                       isShadow: true,
                                       titleColor: .white,
                                       tag: index)
                
                btn.addTarget(self, action: #selector(didTouchToToDrinks), for: .touchUpInside)
                stackButtons.addArrangedSubview(btn)
            }
        }
       
    }

//MAKR: - UICollectionViewDelegate, UICollectionViewDataSource
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        9
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return (burgers?.count ?? 0)
        }
        
        if section == 1 {
            return (pizzas?.count ?? 0)
        }
        
        if section == 2 {
            return (hotdogs?.count ?? 0)
        }
        
        if section == 3 {
            return (snacks?.count ?? 0)
        }
        
        if section == 4 {
            return (milkshakes?.count ?? 0)
        }
        if section == 5 {
            return (lemonades?.count ?? 0)
        }
        
        if section == 6 {
            return (coffeeDrinks?.count ?? 0)
        }
        
        if section == 7 {
            return (desserts?.count ?? 0)
        }
        
        if section == 8 {
            return (drinks?.count ?? 0)
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        
        //Секция 0 - Бургеры
        if indexPath.section == 0 {
      


            guard let model = burgers?[indexPath.item] else { return cell }
            let modelCell = ProductCellViewModel(title: model.name,
                                                 price: String(model.price),
                                                 image: model.image,
                                                 imageURL: model.imageURL,
                                                 type: .burger)
            
            cell.update(modelCell)
        
        }
        
        //Секция 1 - Пицца
        if indexPath.section == 1 {
            guard let model = pizzas?[indexPath.item] else { return cell }
            let modelCell = ProductCellViewModel(title: model.name,
                                                 price: String(model.price),
                                                 image: model.image,
                                                 imageURL: nil,
                                                 type: .pizza)

            cell.update(modelCell)
        }
        
        if indexPath.section == 2 {
            guard let model = hotdogs?[indexPath.item] else { return cell }
            let modelCell = ProductCellViewModel(title: model.name,
                                                 price: String(model.price),
                                                 image: model.image,
                                                 imageURL: nil,
                                                 type: .hotDog)
            cell.update(modelCell)
        }
       
        
        if indexPath.section == 3 {
            guard let model = snacks?[indexPath.item] else { return cell }
            let modelCell = ProductCellViewModel(title: model.name,
                                                 price: String(model.price),
                                                 image: model.image,
                                                 imageURL: nil,
                                                 type: .snack)
            cell.update(modelCell)
        }
        
        if indexPath.section == 4 {
            guard let model = milkshakes?[indexPath.item] else { return cell }
            let modelCell = ProductCellViewModel(title: model.name,
                                                 price: String(model.price),
                                                 image: model.image,
                                                 imageURL: nil,
                                                 type: .milkshake)
            cell.update(modelCell)
        }
        
        if indexPath.section == 5 {
            guard let model = lemonades?[indexPath.item] else { return cell }
            let modelCell = ProductCellViewModel(title: model.name,
                                                 price: String(model.price),
                                                 image: model.image,
                                                 imageURL: nil,
                                                 type: .milkshake)
            cell.update(modelCell)
        }
        
        if indexPath.section == 6 {
            guard let model = coffeeDrinks?[indexPath.item] else { return cell }
            let modelCell = ProductCellViewModel(title: model.name,
                                                 price: String(model.price),
                                                 image: model.image,
                                                 imageURL: nil,
                                                 type: .milkshake)
            cell.update(modelCell)
        }
        
        if indexPath.section == 7 {
            guard let model = desserts?[indexPath.item] else { return cell }
            let modelCell = ProductCellViewModel(title: model.name,
                                                 price: String(model.price),
                                                 image: model.image,
                                                 imageURL: nil,
                                                 type: .milkshake)
            cell.update(modelCell)
        }
        
        if indexPath.section == 8 {
            guard let model = drinks?[indexPath.item] else { return cell }
            let modelCell = ProductCellViewModel(title: model.name,
                                                 price: String(model.price),
                                                 image: model.image,
                                                 imageURL: nil,
                                                 type: .milkshake)
            cell.update(modelCell)
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeaderReusableView
            headerView.titleLabel.text = sectionLabels[indexPath.section]
            return headerView
        }
        print("sect \(indexPath.section)")

        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 99) // Здесь вы можете настроить высоту заголовка секции
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard let model = burgers?[indexPath.item] else { return }
            openDetailProductVC(model, DataStore.shared.additiveBurger)
        }
        if indexPath.section == 1 {
            guard let model = pizzas?[indexPath.item] else { return }
            openDetailProductVC(model, DataStore.shared.additivePizza)
        }
        if indexPath.section == 2 {
            guard let model = hotdogs?[indexPath.item] else { return }
            openDetailProductVC(model, [])
        }
        
        if indexPath.section == 3 {
            guard let model = snacks?[indexPath.item] else { return }
            openDetailProductVC(model, [])
        }
        
        if indexPath.section == 4 {
            guard let model = milkshakes?[indexPath.item] else { return }
            openDetailProductVC(model, [])
        }
        
        if indexPath.section == 5 {
            guard let model = lemonades?[indexPath.item] else { return }
            openDetailProductVC(model, [])
        }
        
        if indexPath.section == 6 {
            guard let model = coffeeDrinks?[indexPath.item] else { return }
            openDetailProductVC(model, [])
        }
        
        if indexPath.section == 7 {
            guard let model = desserts?[indexPath.item] else { return }
            openDetailProductVC(model, [])
        }
        
        if indexPath.section == 8 {
            guard let model = drinks?[indexPath.item] else { return }
            openDetailProductVC(model, [])
        }
    }
    
    
    #warning("Это тест для скрола таблицы")
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cells = verticalСollectionView.visibleCells as? [ProductCell]
        let type = cells?.sorted(by: { $0.frame.origin.y < $1.frame.origin.y }).last?.model?.type
    }
    
    
}
