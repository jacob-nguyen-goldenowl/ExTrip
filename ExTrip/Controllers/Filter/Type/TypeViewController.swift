//
//  TypeViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 05/01/2023.
//

import UIKit

class TypeViewController: UIViewController {
    
    var valueAllTypes: [String] = []
    var selectedRows:[IndexPath] = []
    var doneHandler: (([String]) -> Void)?
    var saveCheckBoxPosition: (([IndexPath]) -> Void)?
    var currentValue: [String] = []
    
    var text: String? {
        didSet {
            titleLabel.text = text
        }
    }
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.bouncesZoom = false
        table.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        table.allowsSelection = false
        table.bounces = false
        return table
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(style: .bold)
        label.sizeToFit()
        return label
    }()
    
    private lazy var doneButton = ETGradientButton(title: .done, style: .mysticBlue)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubviews(tableView,
                         titleLabel,
                         doneButton)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TypeTableViewCell.self,
                           forCellReuseIdentifier: TypeTableViewCell.identifier)
        doneButton.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
        setupConstraintViews()
    }
    
    private func setupConstraintViews() {
        let padding: CGFloat = 20
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor,
                          paddingTop: padding,
                          paddingLeading: padding)
        
        tableView.anchor(top: titleLabel.bottomAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         leading: view.leadingAnchor,
                         trailing: view.trailingAnchor)
        
        doneButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                          leading: view.leadingAnchor, 
                          trailing: view.trailingAnchor,
                          paddingBottom: 50,
                          paddingLeading: 30, 
                          paddingTrailing: 30)
        doneButton.setHeight(height: 50)
    }
    
    private func cancel() {
        dismiss(animated: true)
    }
}

extension TypeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valueAllTypes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TypeTableViewCell.identifier) as! TypeTableViewCell
        cell.textLabel?.text = valueAllTypes[indexPath.row]
        if selectedRows.contains(indexPath)
        {
            cell.checkBox = UIImage(named: "checked")
        }
        else
        {
            cell.checkBox = UIImage(named: "unchecked")
        }
        cell.checkBoxButton.tag = indexPath.row
        cell.checkBoxButton.addTarget(self, action: #selector(checkBoxSelection(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func checkBoxSelection(_ sender: UIButton) {
        let selectedIndexPath = IndexPath(row: sender.tag, section: 0)
        
        if self.selectedRows.contains(selectedIndexPath)
        {
            let index = selectedRows.firstIndex(of: selectedIndexPath) ?? 0
            self.selectedRows.remove(at: index)
            currentValue.remove(at: index)
        }
        else
        {
            self.selectedRows.append(selectedIndexPath)
            currentValue.append(valueAllTypes[selectedIndexPath.row])
        }
        self.tableView.reloadData()
    }
    
}

extension TypeViewController {
    @objc func doneButtonAction() {
        doneHandler?(currentValue)
        saveCheckBoxPosition?(selectedRows)
        cancel() 
    }
}
