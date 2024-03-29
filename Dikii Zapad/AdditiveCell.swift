//
//  AdditiveCell.swift
//  Dikii Zapad
//
//  Created by Роман Бакаев on 22.10.2023.
//

import UIKit
import EasyPeasy

protocol AdditiveCellDelegate: AnyObject {
    func checkBoxDidTap(index: Int)
}

class AdditiveCell: UITableViewCell {
    
    weak var delegate: AdditiveCellDelegate?
    var index: Int = 0
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19)
        label.textColor = .white
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    private lazy var overlayButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapOverlayButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var checkBox: CheckBoxButton = {
        let checkBox = CheckBoxButton()
        return checkBox
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        contentView.addSubviews(
            nameLabel,
            priceLabel,
            checkBox,
            overlayButton
        )
        
        checkBox.easy.layout(
            Left(20),
            Height(40),
            Width(40)
        )
        
        nameLabel.easy.layout(
            Left(5).to(checkBox),
            Top(5),
            Bottom(5)
        )
        
        priceLabel.easy.layout(
            Right(20),
            CenterY()
        )
        overlayButton.easy.layout( Edges() )
    }
    
    func configure(additive: AdditiveProduct) {
        nameLabel.text = additive.name
        priceLabel.text = "+\(additive.price)руб."
    }
    
    @objc func didTapOverlayButton() {
        checkBox.toggle()
        delegate?.checkBoxDidTap(index: index)
    }
}
