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
            
            if let url = URL(string: model.urlString) {
                image.kf.setImage(with:url)
            }
        }
    }
    
    private lazy var containerView: UIView = {
        let view = UIView()
//        view.backgroundColor = .customClearGray
        view.layer.cornerRadius = 15
        view.roundCorners(20)
        view.layer.borderColor = UIColor.customOrange.withAlphaComponent(0.5).cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
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
        addSubview(containerView)
        containerView.addSubview(image)
    }
    
    func setupConstrains() {
        containerView.easy.layout(Edges())
        image.easy.layout(Edges())
    }
    
//    //методы по нажатию и отпусканию на экран
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//
//        UIView.animate(withDuration: 0.1) {
//            self.alpha = 0.5
//            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//        }
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesEnded(touches, with: event)
//           resetCellState()
//    }
//
//    // Если касание было отменено (например, при скроллинге)...
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesCancelled(touches, with: event)
//        resetCellState()
//    }
//
//    // Эта функция восстанавливает исходное состояние ячейки после касания.
//    private func resetCellState() {
//        UIView.animate(withDuration: 0.2) {
//            self.transform = .identity
//            self.alpha = 0.0
//        }
//    }
}
