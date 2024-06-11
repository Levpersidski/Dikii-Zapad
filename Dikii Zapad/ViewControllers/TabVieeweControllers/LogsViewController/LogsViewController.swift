//
//  LogsViewController.swift
//  Dikii Zapad
//
//  Created by Glushchenko on 11.06.2024.
//

import UIKit
import EasyPeasy

final class LogsViewController: UIViewController {
    var logs: [LogoModel] {
        return LogsCollector.shared.logs
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(LogoCell.self, forCellReuseIdentifier: "LogoCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 0)
        return tableView
    }()
    
    private lazy var copyLabel: UILabel = {
       let label = UILabel()
        label.text = "Текст скопирован"
        label.backgroundColor = .gray.withAlphaComponent(0.3)
        label.roundCorners(10)
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(copyLabel)
        
        tableView.easy.layout(Edges())
        copyLabel.easy.layout(Center(), Height(30), Width(170))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewLogEntryNotification), name: LogsCollector.newLogEntryNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: LogsCollector.newLogEntryNotification, object: nil)
    }
    
    @objc private func handleNewLogEntryNotification() {
        tableView.reloadData()
    }
}

extension LogsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        logs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LogoCell", for: indexPath) as? LogoCell else {
            return UITableViewCell()
        }
        cell.model = logs[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let text = logs[indexPath.row].text
        UIPasteboard.general.string = text
        copyLabel.fadeIn() { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.copyLabel.fadeOut()
            }
        }
    }
}


