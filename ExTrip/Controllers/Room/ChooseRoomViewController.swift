//
//  ChooseRoomViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 16/02/2023.
//

import UIKit

class ChooseRoomViewController: UIViewController {
    
    var valueAllTypes: [String] = []
    var selectedRows = IndexPath(item: 0, section: 0)
    var doneHandler: ((Int) -> Void)?
    var saveCheckBoxPosition: ((IndexPath) -> Void)?
    var currentValue: Int = 0
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        title = "Choose room"
        view.backgroundColor = .systemBackground
        view.addSubviews(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TypeTableViewCell.self,
                           forCellReuseIdentifier: TypeTableViewCell.identifier)
        setupConstraintViews()
    }
    
    private func setupConstraintViews() {
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         bottom: view.bottomAnchor, 
                         leading: view.leadingAnchor,
                         trailing: view.trailingAnchor)
    }
    
    private func cancel() {
        dismiss(animated: true)
    }
    
    private func checkBoxSelection(_ selectedIndexPath: IndexPath) {
        let index = selectedIndexPath.item
        self.selectedRows = selectedIndexPath
        currentValue = index + 1       
    }
    
}

extension ChooseRoomViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valueAllTypes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TypeTableViewCell.identifier) as! TypeTableViewCell
        cell.textLabel?.text = valueAllTypes[indexPath.row]
        if selectedRows == indexPath {
            cell.checkBox = UIImage(named: "select")
            
        } else {
            cell.checkBox = UIImage(named: "unselect")
        }
        cell.checkBoxButton.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        checkBoxSelection(indexPath)
        doneHandler?(currentValue)
        saveCheckBoxPosition?(selectedRows)
        cancel()
    }
}
