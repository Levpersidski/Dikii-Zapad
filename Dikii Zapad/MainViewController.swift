//
//  ViewController.swift
//  Dikii Zapad
//
//  Created by Роман Бакаев on 24.09.2023.
//

import UIKit
import EasyPeasy

final class MainViewController: UIViewController {
    //MARK: - Private Property
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        // Настройка режима отображения изображения (чтобы оно занимало всю область экрана)
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "mainImage")
        // чтобы изображение было в фоне и на него можно было размещать другие элементы, то используйте view.insertSubview(imageView, at: 0)
        return imageView
    }()
    
    private var buttonGoToDrinks: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .green
        btn.setTitle("test", for: .normal)
        btn.addTarget(self, action: #selector(didTouchToToDrinks), for: .touchUpInside)
        return btn
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        
        //Отступ между ячейками (верх низ)
        collectionViewLayout.minimumLineSpacing = 20
        
        //отступ между ячейками (лево право)
        collectionViewLayout.minimumInteritemSpacing = 5
        
        collectionViewLayout.itemSize = CGSize(width: sizeCell, height: sizeCell * 1.25)
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        //        collectionViewLayout.minimumLineSpacing = 20
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //тут неповторяющее название TestCellIdent
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: "ProductCell")
        
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = true
        collectionView.contentInset = .zero
        return collectionView
    }()
    
    private lazy var sizeCell: CGFloat = (UIScreen.main.bounds.size.width / 2) - 20
    private lazy var minimumLineSpacing: CGFloat = 2
    
    var burgers: [Product]?
    var pizzas: [Product]?
    var drinks: [Product]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setupConstraints()
        setupModels()
    }
    
    private func openDetailProductVC(_ model: Product) {
        let vc = DetailsProductViewController()
        vc.modelProduct = model
//        navigationController?.pushViewController(vc, animated: true)
        present(vc, animated: true)
    }
    
    @objc func didTouchToToDrinks() {
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 2), at: .top, animated: true)
    }
}

//MARK: - Setting
    private extension MainViewController {
        func addSubViews() {
            view.addSubViews(imageView, buttonGoToDrinks, collectionView)
        }
        
        func setupConstraints() {
            imageView.easy.layout(
                Edges()
            )
            
            buttonGoToDrinks.easy.layout(
                Top().to(view.safeAreaLayoutGuide, .top),
                Left(30),
                Height(30),
                Width(250)
            )
            
            collectionView.easy.layout(
                Top().to(buttonGoToDrinks, .bottom),
                Left(),
                Right(),
                Bottom()
            )
        }
        
        func setupModels() {
            burgers = DataStore.shared.burgers
            pizzas = DataStore.shared.pizzas
            drinks = DataStore.shared.drinks
        }
    }

//MAKR: - UICollectionViewDelegate, UICollectionViewDataSource
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return (burgers?.count ?? 0)
        }
        if section == 1 {
            return (pizzas?.count ?? 0)
        }
        if section == 2 {
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
                                                 type: .burger)
//            let modelCell = ProductCellViewModel(title: model.name,
//                                                 price: String(model.price),
//                                                 image: UIImage(named: "bill"))
            cell.update(modelCell)
        }
        
        //Секция 1 - Пицца
        if indexPath.section == 1 {
            guard let model = pizzas?[indexPath.item] else { return cell }
            let modelCell = ProductCellViewModel(title: model.name,
                                                 price: String(model.price),
                                                 image: model.image,
                                                 type: .pizza)
//            let modelCell = ProductCellViewModel(title: model.name,
//                                                 price: String(model.price),
//                                                 image: UIImage(named: "bill"))

            cell.update(modelCell)
        }
        
        if indexPath.section == 2 {
            guard let model = drinks?[indexPath.item] else { return cell }
            let modelCell = ProductCellViewModel(title: model.name,
                                                 price: String(model.price),
                                                 image: model.image,
                                                 type: .drink)


            cell.update(modelCell)
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard let model = burgers?[indexPath.item] else { return }
            openDetailProductVC(model)
        }
        if indexPath.section == 1 {
            guard let model = pizzas?[indexPath.item] else { return }
            openDetailProductVC(model)
        }
        if indexPath.section == 2 {
            guard let model = drinks?[indexPath.item] else { return }
            openDetailProductVC(model)
        }
    }
    
    
    #warning("Это тест для скрола таблицы")
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cells = collectionView.visibleCells as? [ProductCell]
        let type = cells?.sorted(by: { $0.frame.origin.y < $1.frame.origin.y }).last?.model?.type
        
        print("\(type)")
    }
}
