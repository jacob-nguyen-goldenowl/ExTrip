//
//  HotelViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 04/01/2023.
//

import UIKit

class HotelViewController: UIViewController {
    
    private let errorView = FilterErrorView()
    private let filterViewModel = FilterViewModel()
    
    private var hotels: [HotelModel] = [] {
        didSet {
            tableView.reloadData()
            showNotFoundView()
        }
    }
    
    private lazy var activityIndicator : CustomLoadingView = {
        let image : UIImage = UIImage(named: "loading")!
        return CustomLoadingView(image: image)
    }()

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(HotelTableViewCell.self,
                       forCellReuseIdentifier: HotelTableViewCell.identifier)
        table.bouncesZoom = false
        table.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        table.bounces = false
        return table
    }()
    
    convenience init(_ data: [HotelModel]) {
        self.init()
        self.hotels = data
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
        addLoadingIndicator()
        setupNotificationCenter()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.fillAnchor(view)
    }
    
    private func setupNavigation() {
        navigationController?.configBackButton()
        
        let filterButton = UIButton(type: .custom)
        let image = UIImage(named: "slider")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        filterButton.setImage(tintedImage, for: .normal)
        filterButton.tintColor = UIColor.theme.lightBlue ?? .blue
        filterButton.addTarget(self, action: #selector(handleFilterButton), for: .touchUpInside)
        let item = UIBarButtonItem(customView: filterButton)
        
        self.navigationItem.setRightBarButton(item, animated: true)
    }
    
    private func addLoadingIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
    }
    
    // MARK: - Binder
    private func fetchFilterDatabase(filter: FilterModel) {
        filterViewModel.resultHotelByFilter(filter: filter)
    }
    
    private func setupBinder() {
        filterViewModel.hotelsFilter.bind { [weak self] result in
            guard let self = self else { return }
            if let result = result {
                self.hotels = result
            }
        }
    }
    
    private func setupErrorBinder() {
        filterViewModel.errorMsg.bind { [weak self] error in
            guard let self = self else { return }
            if error != nil {
                self.stopLoading()
                self.setupErrorView()
            }
        }
    }

    // MARK: - Setup loading 
    func starLoading() {
        activityIndicator.startAnimating()
        tableView.isHidden = true
        errorView.removeFromSuperview()
    }
    
    func stopLoading() {
        self.activityIndicator.stopAnimating()
    }

    private func showNotFoundView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.hotels.isEmpty {
                self.tableView.isHidden = true
                self.setupErrorView()
            } else {
                self.tableView.isHidden = false
            }
            self.stopLoading()
        }
    }
    
    private func navigationToHotelDetail(row: Int) {
        let data = hotels[row]
        let vc = DetailViewController(data: data)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupErrorView() {
        view.addSubview(errorView)
        errorView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         leading: view.leadingAnchor, 
                         trailing: view.trailingAnchor)
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension HotelViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HotelTableViewCell.identifier,
                                                       for: indexPath) as? HotelTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        let data = hotels[indexPath.row]
        cell.cofigureHotel(data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        navigationToHotelDetail(row: indexPath.row)
    }
}

extension HotelViewController {
    @objc func handleFilterButton() {
        let vc = FilterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Notification center
extension HotelViewController {
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleLoadingAction(_:)),
                                               name: NSNotification.Name(UserDefaultKey.loadingNotify),
                                               object: nil)
    }
    
    @objc func handleLoadingAction(_ notification: Notification) {
        guard let data = notification.object else { return }
        fetchFilterDatabase(filter: data as! FilterModel)
        starLoading()
        setupBinder()
        setupErrorBinder()
    }

}
