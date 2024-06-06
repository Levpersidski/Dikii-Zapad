//
//  HistoryOrdersCell.swift
//  Dikii Zapad
//
//  Created by Glushchenko on 21.05.2024.
//

import UIKit
import EasyPeasy

final class HistoryOrdersCell: UITableViewCell {
    var isLast: Bool = false {
        didSet {
            separatorView.isHidden = isLast
        }
    }
    
    var model: UserOrder? {
        didSet {
            
            guard let model = model else { return }
            
            numberLabel.text = "#\(model.number), сумма: \(model.allSum)"
            timeLabel.text = model.date.string(format: "dd MMMM HH:mm") ?? ""
            orderLabel.text = model.text
            
            if let adress = model.adress {
                additionalTextLabel.text = "• \(adress)"
            } else {
                additionalTextLabel.text = nil
            }
        }
    }
    
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .white.withAlphaComponent(0.7)
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white.withAlphaComponent(0.7)
        return label
    }()
    
    private lazy var orderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .white.withAlphaComponent(0.9)
        return label
    }()
    
    private lazy var additionalTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white.withAlphaComponent(0.7)
        return label
    }()
    
    private var separatorView: DotsView = {
        let view = DotsView()
        view.backgroundColor = .clear
        view.dotColor = UIColor.white.withAlphaComponent(0.7)
        view.dotSize = CGSize(width: 10, height: 1)
        view.dotSpacing = 10
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        
        setupView()
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension HistoryOrdersCell {
    func setupView() {
        addSubviews(
            numberLabel,
            timeLabel,
            orderLabel,
            numberLabel,
            additionalTextLabel,
            separatorView
        )
    }
    
    func setupConstrains() {
        numberLabel.easy.layout(
            Top(16),
            Left(16)
        )
        
        timeLabel.easy.layout(
            Top(16),
            Right(16)
        )
        
        orderLabel.easy.layout(
            Top(16).to(numberLabel, .bottom),
            Left(16), Right(16)
        )
        
        additionalTextLabel.easy.layout(
            Top(16).to(orderLabel, .bottom),
            Left(20), Right(16),
            Bottom(16)
        )
        
        separatorView.easy.layout(
            Bottom(),
            Left(), Right(),
            Height(1)
        )
    }
}
