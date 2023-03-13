//
//  EditProfileViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 02/03/2023.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    // MARK: - Properties
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = UIColor.theme.tertiarySystemFill
        table.separatorColor = UIColor.theme.tertiarySystemFill
        return table
    }()
    
        // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setupViews()
        setupBinder()
        setupNavigationBar()
        registerCell()
    }
    private func setupNavigationBar() {
        title = "Edit Profile"
        navigationController?.configBackButton()
    }
    
    // MARK: Setup binder
    private func setupBinder() {}
    
    // MARK: - Setup UI
    private func setupViews() {
        view.addSubviews(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        setupConstaintsView()
    }
    
    private func setupConstaintsView() {        
        tableView.fillAnchor(view)
    }
    
    private func registerCell() {
        tableView.register(EditProfileTableViewCell.self,
                           forCellReuseIdentifier: EditProfileTableViewCell.identifier)
    }
    
    @objc func handleSetionAction() {
        print("Setting")
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension EditProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section != 0 ? 3 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EditProfileTableViewCell.identifier,
                                                           for: indexPath) as? EditProfileTableViewCell else { return UITableViewCell() }
            return cell  
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
