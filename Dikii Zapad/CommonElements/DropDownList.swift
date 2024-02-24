//
//  DropDownList.swift
//  Dikii Zapad
//
//  Created by mac on 23.02.2024.
//

import UIKit
import EasyPeasy

struct DropDownListViewModel {
    var title: String
    var items: [DropDownItemViewModel]
}

struct DropDownItemViewModel {
    let title: String
    var isSelected: Bool
    var index: Int = 0
    
    var completion: (() -> Void)? = nil
}

protocol DropDownListDelegate: AnyObject {
    func dropDownListOpen(_ dropDown: DropDownList)
    func dropDownListClose(_ dropDown: DropDownList)
    
    func selectItem(dropDown: DropDownList, itemModel: DropDownItemViewModel)
}

enum ModeDrop {
    case up
    case down
}

final class DropDownList: UIView {
    weak var delegate: DropDownListDelegate?
    let modeDrop: ModeDrop
    let canUnselect: Bool = false
    
    var viewModel: DropDownListViewModel? {
        didSet {
            guard let model = viewModel else { return }
            addressLabel.text = model.title

            itemsContainerStack.removeAllArrangedSubviews()
            
            model.items.enumerated().forEach { item in
                let view = ItemSelectableDropDown()
                view.viewModel = item.element
                view.viewModel?.index = item.offset
                view.delegate = self
                itemsContainerStack.addArrangedSubview(view)
            }
        }
    }
    
    private lazy var mainContainerStack: UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    private lazy var addressButton: UIButtonTransform = {
        let button = UIButtonTransform(type: .system)
        button.backgroundColor = UIColor(hex: "1C1C1C")
        button.maskCorners(radius: 8)
        button.addTarget(self, action: #selector(addressButtonDidTap), for: .touchUpInside)
        button.layer.zPosition = 1
        return button
    }()
    
    private lazy var addressStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.addArrangedSubview(addressLabel)
        stackView.addArrangedSubview(arrowImage)
        stackView.isUserInteractionEnabled = false
        return stackView
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private lazy var arrowImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.image = UIImage(named: "arrow_img")?.withRenderingMode(.alwaysOriginal)
        imageView.easy.layout(Size(30))
        return imageView
    }()
    
    private lazy var itemsContainerStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.isHidden = true
        return stackView
    }()
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//        setupConstraints()
//    }
    
    init(mode: ModeDrop) {
        self.modeDrop = mode
        super.init(frame: .zero)
        
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(mainContainerStack)

        switch modeDrop {
        case .up:
            mainContainerStack.addArrangedSubview(itemsContainerStack)
            mainContainerStack.addArrangedSubview(addressButton)
        case .down:
            mainContainerStack.addArrangedSubview(addressButton)
            mainContainerStack.addArrangedSubview(itemsContainerStack)
        }
        
        addressButton.addSubview(addressStack)
    }
    
    private func setupConstraints() {
        mainContainerStack.easy.layout(
            Top(),
            Left(16), Right(16),
            Bottom()
        )
        addressButton.easy.layout(
            Height(50)
        )
        addressStack.easy.layout(
            Top(),
            Left(16), Right(16),
            Bottom()
        )
    }
    
    @objc private func addressButtonDidTap() {
        itemsContainerStack.isHidden ? delegate?.dropDownListOpen(self) : delegate?.dropDownListClose(self)
        hiddenItems(!itemsContainerStack.isHidden)
    }
    
    func hiddenItems(_ value: Bool) {
        if value {
            self.layoutIfNeeded()
            UIView.animate(withDuration: 0.2) {
                self.itemsContainerStack.isHidden = true
                self.arrowImage.transform = .identity
            } completion: { _ in
                self.itemsContainerStack.isHidden = true
                self.arrowImage.transform = .identity
            }
        } else {
            self.layoutIfNeeded()
            UIView.animate(withDuration: 0.2) {
                self.itemsContainerStack.isHidden = false
                let angle: CGFloat = self.modeDrop == .down ? CGFloat.pi/2 : -CGFloat.pi/2
                self.arrowImage.transform = CGAffineTransform(rotationAngle: angle)
            } completion: { _ in
                self.itemsContainerStack.isHidden = false
                let angle: CGFloat = self.modeDrop == .down ? CGFloat.pi/2 : -CGFloat.pi/2
                self.arrowImage.transform = CGAffineTransform(rotationAngle: angle)
            }
        }
    }
}

//MARK: - ItemSelectableDropDownDelegate
extension DropDownList: ItemSelectableDropDownDelegate {
    func didSelectItem(model: DropDownItemViewModel?) {
        guard let model = model else { return }
        
        hiddenItems(true)
        
        var updatedViewModel = viewModel
        updatedViewModel?.items.enumerated().forEach({ enumItem in
            updatedViewModel?.items[enumItem.offset].isSelected = false
        })
        updatedViewModel?.items[model.index].isSelected = canUnselect ? !model.isSelected : true
        updatedViewModel?.title = model.title
        addressLabel.text = model.title
        
        viewModel = updatedViewModel
        delegate?.selectItem(dropDown: self, itemModel: model)
    }
}
