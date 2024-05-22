//
//  HistoryOrdersViewController.swift
//  Dikii Zapad
//
//  Created by Glushchenko on 17.05.2024.
//

import UIKit
import EasyPeasy

final class HistoryOrdersViewController: UIViewController {
    private var userOrders: [UserOrder] {
        DataStore.shared.userOrders
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(HistoryOrdersCell.self, forCellReuseIdentifier: "HistoryOrdersCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        addSubViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.backItem?.title = ""

        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UIColor.customOrange
        navigationController?.navigationBar.barTintColor = .black
        
        tableView.reloadData()
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
extension HistoryOrdersViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryOrdersCell", for: indexPath) as? HistoryOrdersCell else {
            return UITableViewCell()
        }
        cell.model = userOrders[indexPath.row]
        cell.isLast = userOrders.count - 1 == indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 // Здесь можно указать оценочную высоту ячейки
    }
}
