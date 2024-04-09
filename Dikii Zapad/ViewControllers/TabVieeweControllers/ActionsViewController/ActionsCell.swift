//
//  ActionsCell.swift
//  Dikii Zapad
//
//  Created by mac on 25.02.2024.
//

import UIKit
import EasyPeasy
import Kingfisher

struct ActionCellViewModel {
    let urlString: String
}

final class ActionCell: UICollectionViewCell {
    var model: ActionCellViewModel? {
        didSet {
            guard let model = model else { return }
            skeletonView.isHidden = false
            skeletonView.startAnimating()
            
            if let url = URL(string: model.urlString) {
                image.kf.setImage(with: url)
                skeletonView.stopAnimating()
                skeletonView.isHidden = true
            }
        }
    }
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 15
        image.roundCorners(20)
        image.contentMode = .scaleAspectFill
        image.layer.borderColor = UIColor.customOrange.withAlphaComponent(0.5).cgColor
        image.layer.borderWidth = 1
        image.backgroundColor = .black
        return image
    }()
    
    private lazy var skeletonView: SkeletonView = {
        let view = SkeletonView()
        view.alpha = 0.3
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(image)
        image.addSubview(skeletonView)
    }
    
    func setupConstrains() {
        image.easy.layout(Edges())
        skeletonView.easy.layout(Edges())
    }
}
