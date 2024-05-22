//
//  VacanciesViewController.swift
//  Dikii Zapad
//
//  Created by Glushchenko on 22.05.2024.
//

import UIKit
import EasyPeasy

final class VacanciesViewController: UIViewController {
    var vacancies: [Vacancy] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(VacancyCell.self, forCellReuseIdentifier: "VacancyCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 0)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        addSubViews()
        setupConstraints()
    }
    
    
    func addSubViews() {
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.easy.layout(
            Top().to(view.safeAreaLayoutGuide, .top),
            Left(),
            Right(),
            Bottom()
        )
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension VacanciesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vacancies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VacancyCell", for: indexPath) as? VacancyCell else {
            return UITableViewCell()
        }
        cell.model = vacancies[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 // Здесь можно указать оценочную высоту ячейки
    }
}
