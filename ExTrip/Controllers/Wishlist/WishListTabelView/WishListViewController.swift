//
//  FavoriteViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 14/12/2022.
//

import UIKit

class WishListViewController: UIViewController {
    
    lazy var viewModel: WishListViewModel = {
        return WishListViewModel()
    }()
    
    private lazy var refreshControl = UIRefreshControl()
        
    private lazy var loadingView = LottieView()
    private lazy var emptyView =  EmptyView()
            
    private let tableView: UITableView = {
        let table = UITableView()
        table.showsVerticalScrollIndicator = false
        table.clipsToBounds = true
        table.separatorColor = .clear
        table.backgroundColor = .systemBackground
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setupViewModel()
        setupViews()
        regiterCell()
        receiverNotify()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if FeatureFlags.isUpdateWishlist {
            setupViewModel()
            FeatureFlags.isUpdateWishlist = false
        }
        setupNavigationBar()
    }
    
    // MARK: - Setup UI
    private func setupViews() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        setupConstaintsView()
        setupRefreshControl()
    }

    private func setupConstaintsView() {  
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         bottom: view.bottomAnchor, 
                         leading: view.leadingAnchor,
                         trailing: view.trailingAnchor)
    }

    private func setupNavigationBar() {
        navigationItem.title = "Wishlist"
    }
    
    // MARK: - Fetch data
    private func setupViewModel() {
        
        viewModel.updateLoadingStatus = { [weak self] in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.startAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tableView.alpha = 1.0
                        self?.hiddenEmptyView()
                    })
                } else {
                    self?.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tableView.alpha = 1.0
                        self?.hiddenEmptyView()
                    })
                }
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.showEmptyViewClosure = { [weak self] in 
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.2, animations: {
                    self?.showEmptyView()
                })
            }
        }
        
        viewModel.fetchDataWishlist()
    }
    
    private func regiterCell() {
        tableView.register(WishListTableViewCell.self,
                           forCellReuseIdentifier: WishListTableViewCell.identifier)
    }
    
    private func setupRefreshControl() {
        refreshControl.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(handleRefreshTableViewAction), for: .valueChanged)
    }
    
    @objc func handleRefreshTableViewAction() {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    // MARK: - Animating 
    private func startAnimating() {
        view.addSubview(loadingView)
        loadingView.fillAnchor(view)
        loadingView.startAnimating()
    }
    
    private func stopAnimating() {
        loadingView.stopAnimating()
    }
    
    private func showEmptyView() {
        view.backgroundColor = .systemBackground
        tableView.isHidden = true
        view.addSubview(emptyView)
        emptyView.fillAnchor(view)
        emptyView.delegate = self
        emptyView.emptyString = viewModel.emptyString
        emptyView.showEmptyView()
    }
    
    private func hiddenEmptyView() {
        emptyView.hiddenEmptyView()
        tableView.isHidden = false
    }
    
    private func receiverNotify() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loginSuccess),
                                               name: NSNotification.Name(UserDefaultKey.loginsuccessNotify),
                                               object: nil)
    }
    
    @objc func loginSuccess() {
        setupViewModel()
    }
    
    deinit { 
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(UserDefaultKey.loginsuccessNotify),
                                                  object: nil) 
    }
}

    // MARK: - UITableViewDelegate, UITableViewDataSource
extension WishListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.isLoading ? 0 : viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WishListTableViewCell.identifier,
                                                       for: indexPath) as? WishListTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = .clear
        let hotel = viewModel.getCellViewModel(at: indexPath)
        cell.setupDataWishList(hotel: hotel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let lable: UILabel = UILabel(frame: CGRect(x: 0,
                                                   y: 0, 
                                                   width: view.frame.size.width,
                                                   height: view.frame.size.height))
        lable.textAlignment = .center
        lable.text = "No more results"
        lable.font = .poppins(style: .medium, size: 12)
        lable.textColor = UIColor.theme.lightGray
        return viewModel.isLoading ? nil : lable
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let hotel = viewModel.listOfData[indexPath.row]
        let vc = DetailViewController(data: hotel)
        navigationAction(vc)
    }
    
    func tableView(_ tableView: UITableView, 
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (_, _, _) in
            tableView.beginUpdates()
            let hoteID = self.viewModel.getCellViewModel(at: indexPath).id
            self.removeHotelFromWishList(hoteID)
            self.viewModel.listOfData.remove(at: indexPath.row)
            if indexPath.row == 0 {
                self.showEmptyView()
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeActions.performsFirstActionWithFullSwipe = false
        return swipeActions
    }
    
    private func removeHotelFromWishList(_ hotelID: String) {
        DispatchQueue.main.async { [weak self] in
            self?.viewModel.removeFromWishlist(with: hotelID)
            
        }
    }
}

extension WishListViewController: EmptyViewDelgate {
    func emptyViewHandleSignIn() {
        let vc = MainViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
