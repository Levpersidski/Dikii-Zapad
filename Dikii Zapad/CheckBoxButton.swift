//
//  CheckBoxButton.swift
//  Dikii Zapad
//
//  Created by Роман Бакаев on 09.11.2023.
//

import UIKit
import EasyPeasy

class CheckBoxButton: UIView {

    var isChecked = true
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "checkmark")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .customOrange
        return imageView
    }()
    
    let boxView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor.customOrange.cgColor
        return view
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        addSubview(imageView)
        addSubview(boxView)
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    public func toggle() {
        self.isChecked = !isChecked
        imageView.isHidden = isChecked
    }
    
    private func setupConstraint() {
        boxView.easy.layout(
            Edges(5)
        )
        
        imageView.easy.layout(
            Edges(7)
        )
    }
    
}
