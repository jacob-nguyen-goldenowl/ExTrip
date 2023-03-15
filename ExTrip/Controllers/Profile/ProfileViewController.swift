//
//  ProfileViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 14/12/2022.
//

import UIKit

private struct ProfileModel {
    let lblSection: String?
    let lblCell: [CellModel]?
    
    init(lblSection: String?, lblCell: [CellModel]?) {
        self.lblSection = lblSection
        self.lblCell = lblCell
    }
}

private struct CellModel {
    let icon: UIImage?
    let title: String?
    let handler: (() -> Void)
}

class ProfileViewController: UIViewController {
    
    private var dataProfile = [ProfileModel]()
    private var profileViewModel = ProfileViewModel()
    
    var timer: Timer?
    
    enum Section: String {
        case manager, help, service, logout
        static let sections: [Section] = [.manager, .help, .service, .logout]
    }
    
    private let sections = Section.sections
    
    private lazy var loadingView = LottieView()
    
    var shouldHideSection: Bool = false
    
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
        receiverNotificationCenter()
        setupViews()
        setupBinder()
        setupNavigationBar()
        registerCell()
        setupDataForProfile()
        checkUserLogin()
    }
    
    private func setupNavigationBar() {
        navigationController?.configBackButton()
        let settingButton = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                            style: .done, 
                                            target: self,
                                            action: #selector(handleSetionAction))
        navigationItem.rightBarButtonItem = settingButton
    }
    
    // MARK: Setup binder
    private func setupBinder() {}
    
    // MARK: - Setup UI
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubviews(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        setupConstaintsView()
    }
    
    private func setupConstaintsView() {  
        tableView.fillAnchor(view)
    }
    
    private func registerCell() {
        tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
    }
    
    private func handleLogout() {
        profileViewModel.signOut { [weak self] error in
            guard error == nil else {
                self?.showAlert(title: "Log out error", style: .alert)
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.shouldHideSection = true
                self?.tableView.reloadData()
            }
        }
    }
    
    private func showAlertLogout() {
        let alert = UIAlertController(title: "Are you sure you want to log out?",
                                      message: nil, 
                                      preferredStyle: .alert)
        // 2. Creeate Actions
        alert.addAction(UIAlertAction(title: "OK", 
                                      style: .default, 
                                      handler: { _ in 
            self.handleLogout()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", 
                                      style: .cancel, 
                                      handler: nil))
        // 3. Snow
        present(alert, animated: true, completion: nil)
    }
    
    private func setupDataForProfile() {
        dataProfile.append(ProfileModel(lblSection: "Manager",
                                        lblCell: [CellModel(icon: UIImage(systemName: "person.circle"),
                                                            title: "Manager your account") { [weak self] in self?.handleManagerAccountAction() },
                                                  CellModel(icon: UIImage(systemName: "wallet.pass"),
                                                            title: "Reweards & Wallet") { [weak self] in self?.handleWalletAction() }, 
                                                  CellModel(icon: UIImage(systemName: "heart"),
                                                            title: "Save") { [weak self] in self?.handleSaveAction() },
                                                  CellModel(icon: UIImage(named: "booking"),
                                                            title: "Bookings") { [weak self] in self?.handleTrackBookingAction() }]))
        
        dataProfile.append(ProfileModel(lblSection: "Help and support",
                                        lblCell: [CellModel(icon: UIImage(systemName: "questionmark.circle"),
                                                            title: "Contact Customer Service") { [weak self] in self?.openURL(type: .service) }, 
                                                  CellModel(icon: UIImage(systemName: "lifepreserver"),
                                                            title: "About ExTrip.com") { [weak self] in self?.openURL(type: .about) }]))
        
        dataProfile.append(ProfileModel(lblSection: "Settings",
                                        lblCell: [CellModel(icon: UIImage(systemName: "gearshape"),
                                                            title: "Settings") { [weak self] in self?.handleSettingAction() }]))
        
        dataProfile.append(ProfileModel(lblSection: "Logout",
                                        lblCell: [CellModel(icon: UIImage(systemName: "arrow.backward.circle"),
                                                            title: "Sign out") { [weak self] in self?.showAlertLogout() }]))
    }
    
    private func starLoading() {
        view.addSubview(loadingView)
        loadingView.fillAnchor(view)
        loadingView.startAnimating()
    }
    
    private func stopLoading() {
        loadingView.stopAnimating()
    }

    func checkUserLogin() {
        let userID =  profileViewModel.currentUserID
        if userID != nil {
            shouldHideSection = false
        } else {
            shouldHideSection = true
        }
    }
    
    private func hiddenCell(_ indexPath: IndexPath, index: Int, section: Section, cell: UITableViewCell) {
        if sections[indexPath.section] == section {
            if indexPath.item == 0 {
                if shouldHideSection {
                    cell.isHidden = true
                } else {
                    cell.isHidden = false
                }
            }
        }
    }
    
    // MARK: Notification center
    private func receiverNotificationCenter() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loginSuccess),
                                               name: NSNotification.Name(UserDefaultKey.loginsuccessNotify),
                                               object: nil )
    }
    
    @objc func loginSuccess() {
        starLoading()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.9, repeats: false, block: { (_) in
            self.shouldHideSection = false
            self.tableView.reloadData()
            self.stopLoading()
        })
    }
    
    deinit { 
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(UserDefaultKey.loginsuccessNotify), object: nil) 
    }    
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = ProfileTableHeaderView(frame: CGRect(x: 0,
                                                              y: 0,
                                                              width: view.frame.size.width,
                                                              height: 110))
            header.delegate = self
            return header
        } else {
            return nil
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return dataProfile.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sections[section] {
        case .manager, .help, .service:
            return dataProfile[section].lblCell?.count ?? 0
        case .logout:
            return shouldHideSection ? 0 : 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as? ProfileTableViewCell else { return UITableViewCell() }
        
        let section = indexPath.section
        let icon = dataProfile[indexPath.section].lblCell?[indexPath.item].icon
        let title = dataProfile[indexPath.section].lblCell?[indexPath.item].title
        cell.setupProfile(icon: icon, title: title)
        
        if sections[section] == .logout {
            cell.setupProfile(icon: icon, title: title, color: .red)
        }
        hiddenCell(indexPath, index: 0, section: .manager, cell: cell)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if sections[indexPath.section] == .manager {
            if indexPath.row == 0 {
                return shouldHideSection ? 0 : 60
            }
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        dataProfile[indexPath.section].lblCell?[indexPath.item].handler()
    }
    
}

extension ProfileViewController: ProfileTableHeaderViewDelegate {
    func profileTableHeaderViewHandleSignInAction() {
        let vc = MainViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

// MARK: Handle action
extension ProfileViewController {
    private func handleManagerAccountAction() {
        let vc = EditProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleSaveAction() {
        let vc = WishListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleWalletAction() {
        let vc = TrackerBookingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleTrackBookingAction() {
        let vc = TrackerBookingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleSettingAction() {}
    
    @objc func handleSetionAction() {
            // Handle setting
    }
}
