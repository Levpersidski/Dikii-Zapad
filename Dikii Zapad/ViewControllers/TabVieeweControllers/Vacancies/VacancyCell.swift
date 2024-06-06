//
//  VacancyCell.swift
//  Dikii Zapad
//
//  Created by Glushchenko on 22.05.2024.
//
import UIKit
import EasyPeasy

final class VacancyCell: UITableViewCell {
    var model: Vacancy? {
        didSet {
            guard let model = model else { return }
            
            nameLabel.text = model.name
            descriptionLabel.text = model.description
            salaryLabel.text = model.salary
            applyButton.isHidden = model.url.isEmpty
            salaryLabel.easy.reload()
        }
    }
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.2)
        view.roundCorners(10)
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white.withAlphaComponent(0.7)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    private lazy var salaryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .orange
        return label
    }()
    
    private lazy var applyButton: GradientButton = {
        let button = GradientButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.backgroundColor = .customOrange
        button.roundCorners(10)
        button.setTitle("Откликнуться на вакансию", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.contentEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 10)
        button.addTarget(self, action: #selector(applyButtonDidTap), for: .touchUpInside)
        return button
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

private extension VacancyCell {
    func setupView() {
        contentView.addSubview(containerView)
        
        containerView.addSubviews(
            nameLabel,
            descriptionLabel,
            salaryLabel,
            applyButton
        )
    }
    
    func setupConstrains() {
        
        containerView.easy.layout(
            Top(10),
            Left(16), Right(16),
            Bottom(10)
        )
        
        nameLabel.easy.layout(
            Top(16),
            Left(16), Right(16)
        )
        
        descriptionLabel.easy.layout(
            Top(10).to(nameLabel, .bottom),
            Left(16), Right(16)
        )
        
        salaryLabel.easy.layout(
            Top(10).to(descriptionLabel, .bottom).when{ [weak self] in
                guard let self = self else { return false }
                return applyButton.isHidden
            },
            Top(40).to(descriptionLabel, .bottom).when{ [weak self] in
                guard let self = self else { return false }
                return !applyButton.isHidden
            },
            Right(16).when{ [weak self] in
                guard let self = self else { return false }
                return applyButton.isHidden
            },
            Right(10).to(applyButton, .left).when{ [weak self] in
                guard let self = self else { return false }
                return !applyButton.isHidden
            },
            Bottom(16)
        )
        applyButton.easy.layout(
            Right(16),
            Height(40),
            Bottom(16)
        )
    }
    
    @objc private func applyButtonDidTap() {
        guard let url = URL(string: model?.url ?? "") else { return }
        UIApplication.shared.open(url)
    }
}
