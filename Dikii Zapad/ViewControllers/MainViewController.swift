//
//  ViewController.swift
//  Dikii Zapad
//
//  Created by Роман Бакаев on 24.09.2023.
//

import UIKit
import EasyPeasy

final class MainViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    private lazy var testButton: UIButton = {
       let btn = UIButton(frame: CGRect(x: 50, y: 100, width: 50, height: 50))
        btn.backgroundColor = .orange
        btn.addTapGesture { _ in
//            let window = UIApplication.appDelegate.window!
//            let model = CustomAlertViewModel(title: "Тест алерта",
//                                             subtitle: "Тут сбатайтл и описание алерта")
//            CustomAlert.open(in: window, model: model)
        }
        return btn
    }()
    
    private var categoriesSection: [String] {
        DataStore.shared.allCategories.compactMap { $0.name }
    }
    
    private var backgroundView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "mainImage")
        imageView.alpha = 0.3
        return imageView
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
    
    private lazy var verticalCollectionView: UICollectionView = {
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
        //регистрация вью  для заголовков секций
        collectionView.register(SectionHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        return collectionView
    }()
    
    private lazy var sizeCell: CGFloat = (UIScreen.main.bounds.size.width / 2) - 20
    private lazy var minimumLineSpacing: CGFloat = 2
    
    //MARK: - ViewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        addSubViews()
        setupConstraints()
        setupModels()
        setupScrollButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        navigationController?.navigationBar.backItem?.title = ""
        navigationController?.navigationBar.tintColor = UIColor.customOrange
        segmentedControl.selectedSegmentIndex = DataStore.shared.outSideOrder ? 0 : 1
        segmentedValueChanged()
    }
    
    private func openDetailProductVC(_ modelProduct: Product, _ modelAdditive: [AdditiveProduct]) {
        let vc = DetailsProductViewController()
        vc.modelProduct = modelProduct
        vc.additives = modelAdditive
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTouchToToDrinks(sender: UIButton) {
        let section = sender.tag
        guard verticalCollectionView.numberOfSections > section else { return }
        guard verticalCollectionView.numberOfItems(inSection: section) > 0 else { return }
        
        verticalCollectionView.scrollToItem(at: IndexPath(item: 0, section: section), at: .top, animated: true)
    }
    
    @objc func segmentedValueChanged() {
        if segmentedControl.selectedSegmentIndex == 0 {
            buttonToDelivery.isEnabled = true
            
            if let address = DataStore.shared.userDeliveryLocation?.address {
                buttonToDelivery.setTitle(address, for: .normal)
            } else {
                buttonToDelivery.setTitle("Указать адресс доставки >", for: .normal)
            }
        } else {
            buttonToDelivery.isEnabled = false
            buttonToDelivery.setTitle("Ул. Советской конституции 21", for: .normal)
        }
        
        DataStore.shared.outSideOrder = segmentedControl.selectedSegmentIndex == 0
    }
    
    @objc func didTouchToToDelivery() {
        let deliveryFormVC = DeliveryFormViewController()
        navigationController?.pushViewController(deliveryFormVC, animated: true)
    }

}

//MARK: - Setting
    private extension MainViewController {
        func addSubViews() {
            view.addSubviews(
                backgroundView,
                greyOverlayView,
                stripsView,
                buttonToDelivery,
                segmentedControl,
                scrollForButtons,
                verticalCollectionView
//                testButton
            )
            
            scrollForButtons.addToScrollView(stackButtons)
        }
        
        func setupConstraints() {
            backgroundView.easy.layout(
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
            
            verticalCollectionView.easy.layout(
                Top(10).to(stackButtons, .bottom),
                Left(),
                Right(),
                Bottom()
            )
        }
        
        func setupModels() {
            verticalCollectionView.reloadData()
        }
        
        func setupScrollButtons() {
            let titleButtons: [String] = categoriesSection
            
            titleButtons.enumerated().forEach { (index, title) in
                let btn = CustomButton(title: title,
                                       backgroundColor: .customClearGray,
                                       isShadow: true,
                                       titleColor: .white,
                                       tag: index)
//                btn.backgroundColor = index == 0 ? .orange : .clear
                btn.addTarget(self, action: #selector(didTouchToToDrinks), for: .touchUpInside)
                stackButtons.addArrangedSubview(btn)
            }
        }
       
    }

//MAKR: - UICollectionViewDelegate, UICollectionViewDataSource
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        categoriesSection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let allProducts = DataStore.shared.allProducts
        let isCategory = DataStore.shared.allCategories[section].id
        let productCategory = allProducts.filter { $0.categories.first?.id == isCategory }
        return productCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        
        let idCategory = DataStore.shared.allCategories[indexPath.section].id
        let productsCategory = DataStore.shared.allProducts.filter { $0.categories.first?.id == idCategory }
        
        let product = productsCategory[indexPath.row]
        let modelCell = ProductCellViewModel(title: product.name,
                                             price: String(product.price),
                                             image: nil,
                                             imageURL: product.imageURL,
                                             stockStatusType: product.stockStatusType)
        
        cell.update(modelCell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeaderReusableView
            headerView.titleLabel.text = categoriesSection[indexPath.section]
            return headerView
        }
        print("sect \(indexPath.section)")

        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 99) // Здесь вы можете настроить высоту заголовка секции
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let idCategory = DataStore.shared.allCategories[indexPath.section].id
        let productsCategory = DataStore.shared.allProducts.filter { $0.categories.first?.id == idCategory }
        let product = productsCategory[indexPath.row]
        
        guard product.stockStatusType != .outOfStock else { return }

        let additivesFromServer = product.attributes.compactMap { $0.options }.reduce([], { $0 + $1 })
        let additivesTest: [AdditiveProduct] = additivesFromServer.compactMap { createAdditivesModel($0) }
        
        openDetailProductVC(product, additivesTest)
    }
    
    func createAdditivesModel(_ from: String ) -> AdditiveProduct? {
        let separatedString = from.components(separatedBy: "+")
        
        guard separatedString.count == 2 else { return nil }
        guard let title = separatedString.first else { return nil }
        guard let valueStr = separatedString.last?.replacingOccurrences(of: " ", with: "") else { return nil }
        guard let value = Int(valueStr) else { return nil }

        return AdditiveProduct(name: title, price: value)
    }
    
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let sections = verticalCollectionView.indexPathsForVisibleItems.map { $0.section }.sorted { $0 < $1 }
//
//        if let section = sections.first {
//            stackButtons.arrangedSubviews.enumerated().forEach { (index, view) in
//                view.backgroundColor = index == section ? .orange : .clear
//            }
//
//            print("=--= Currently visible section: \(section)")
//        }
//    }
}
