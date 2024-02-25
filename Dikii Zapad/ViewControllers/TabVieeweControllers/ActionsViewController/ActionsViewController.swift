//
//  ActionsViewController.swift
//  Dikii Zapad
//
//  Created by Роман Бакаев on 03.10.2023.
//

import UIKit
import EasyPeasy

class ActionsViewController: UIViewController {
    
    private var items: [ActionCellViewModel] = [
        ActionCellViewModel(urlString: "http://dikiyzapad-161.ru/test/testImage.png"),
        ActionCellViewModel(urlString: "https://dikiyzapad-161.ru/test/Group%201@3x.png"),
        ActionCellViewModel(urlString: "http://dikiyzapad-161.ru/wp-content/uploads/2024/01/hot.webp"),
        ActionCellViewModel(urlString: "https://dikiyzapad-161.ru/test/Group%201@3x.png")
    ]
    
    private lazy var backgroundImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "mainImage")
        image.alpha = 0.3
        return image
    }()
    
    private lazy var verticalCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        
        //Отступ между ячейками (верх низ)
        collectionViewLayout.minimumLineSpacing = 30
        
        //отступ между ячейками (лево право)
        collectionViewLayout.minimumInteritemSpacing = 5
        
        collectionViewLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: UIScreen.main.bounds.height / 3)
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 30, left: 10, bottom: 20, right: 10)
        //        collectionViewLayout.minimumLineSpacing = 20
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(ActionCell.self, forCellWithReuseIdentifier: "ActionCell")
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = true
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
}

//MARK: - Private
private extension ActionsViewController {
    func setupViews() {
        view.addSubviews(backgroundImage)
        view.addSubview(verticalCollectionView)
    }
    
    func setupConstraints() {
        backgroundImage.easy.layout(
            Edges()
        )
        
        verticalCollectionView.easy.layout(
            Top().to(view.safeAreaLayoutGuide, .top),
            Left(16), Right(16),
            Bottom()
        )
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ActionsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActionCell", for: indexPath) as! ActionCell
        
        let modelCell = items[indexPath.item]
        cell.model = modelCell
        
        return cell
    }
    
}
