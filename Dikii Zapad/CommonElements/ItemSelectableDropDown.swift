//
//  ItemSelectableDropDown.swift
//  Dikii Zapad
//
//  Created by mac on 23.02.2024.
//

import UIKit
import EasyPeasy

protocol ItemSelectableDropDownDelegate: AnyObject {
    func didSelectItem(model: DropDownItemViewModel?)
}

final class ItemSelectableDropDown: UIButtonTransform {
    
    weak var delegate: ItemSelectableDropDownDelegate?
    
    var viewModel: DropDownItemViewModel? {
        didSet {
            guard let model = viewModel else { return }
            
            checkBoxImageView.image = model.isSelected ? nil : nil
            titleTextLabel.text = model.title
        }
    }
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "1C1C1C")
        view.layer.cornerRadius = 8
        view.isUserInteractionEnabled = false

        return view
    }()
    
    private lazy var checkBoxImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "")?.withRenderingMode(.alwaysOriginal)
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    private lazy var titleTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .white
        label.isUserInteractionEnabled = false

        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        
        self.addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addSubview(containerView)
        
        containerView.addSubviews(
            checkBoxImageView,
            titleTextLabel
        )
    }
    
    private func setupConstraints() {
        self.easy.layout(
            Height(50)
        )
        
        containerView.easy.layout(
            Edges()
        )
        
        checkBoxImageView.easy.layout(
            CenterY(), Left(15), Size(15)
        )
        
        titleTextLabel.easy.layout(
            CenterY(),
            Left(8).to(checkBoxImageView, .right),
            Right(8)
        )
    }
    
    @objc private func touchUpInside() {
        delegate?.didSelectItem(model: viewModel)
    }
}

