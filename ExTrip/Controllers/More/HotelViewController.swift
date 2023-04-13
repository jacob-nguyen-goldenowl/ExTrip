//
//  HotelViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 04/01/2023.
//

import UIKit

class HotelViewController: UIViewController {
    
    private let hotelViewModel = HotelViewModel()

    private let errorView = FilterErrorView()
    var valueFilter = FilterModel(price: Price(maximun: 1000.0, minimun: 0.0),
                                  star: 0,
                                  service: [],
                                  rating: 0,
                                  positionService: [],
                                  property: [], 
                                  positionProperty: [],
                                  bed: [],
                                  positionBed: [],
                                  payment: [],
                                  positionPayment: [])

    // MARK: Properties
    private lazy var loadingView = LottieView()

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(HotelTableViewCell.self,
                       forCellReuseIdentifier: HotelTableViewCell.identifier)
        table.bouncesZoom = false
        table.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        table.bounces = false
        return table
    }()
    
    private lazy var filterButton = UIButton(type: .custom)

    convenience init(_ countryID: String?) {
        self.init()
        self.hotelViewModel.countryID = countryID
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setupViewModel()
        setupNavigation()
        fetchDataHotel()
        setupView()
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
        
        let image = UIImage(named: "slider")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        filterButton.setImage(tintedImage, for: .normal)
        filterButton.tintColor = UIColor.theme.lightBlue ?? .blue
        filterButton.addTarget(self, action: #selector(handleFilterButton), for: .touchUpInside)
        let item = UIBarButtonItem(customView: filterButton)
        
        self.navigationItem.setRightBarButton(item, animated: true)
    }
    
    // MARK: Setup view model
    private func setupViewModel() {
        hotelViewModel.updateLoadingStatus = { [weak self] in
            DispatchQueue.main.async {
                let isLoading = self?.hotelViewModel.isLoading ?? false
                if isLoading {
                    self?.startAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tableView.alpha = 0.0
                    })
                } else {
                    self?.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tableView.alpha = 1.0
                    })
                }
            }
        }
        
        hotelViewModel.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.showNotFoundView()
            }
        }
        
        hotelViewModel.showEmptyViewClosure = { [weak self] in 
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.2, animations: {
                    self?.stopAnimating()
                    self?.showNotFoundView()
                })
            }
        }
    }

    // MARK: Fetch data
    private func fetchDataHotel() {
        hotelViewModel.fetchAllData(destinationID: hotelViewModel.countryID)
    }
    private func fetchFilterDatabase(filter: FilterModel) {
        hotelViewModel.resultHotelByFilter(filter: filter)
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

    private func showNotFoundView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            if self.hotelViewModel.listOfData.isEmpty {
                self.tableView.isHidden = true
                self.startAnimating()
                self.setupErrorView()
                self.errorView.isHidden = false
            } else {
                self.errorView.removeFromSuperview()
                self.tableView.isHidden = false
            }
            self.stopAnimating()
        }
    }
    
    private func navigationToHotelDetail(row: Int) {
        let data = hotelViewModel.listOfData[row]
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

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 { 
            filterButton.tintColor = UIColor.theme.black ?? .black
        } else {   
            filterButton.tintColor = UIColor.theme.lightBlue ?? .blue
        }   
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(UserDefaultKey.loadingNotify), object: nil)
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension HotelViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotelViewModel.listOfData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HotelTableViewCell.identifier,
                                                       for: indexPath) as? HotelTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        let hotel = hotelViewModel.getCellViewModel(at: indexPath)
        cell.cofigureHotel(hotel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        navigationToHotelDetail(row: indexPath.row)
    }
}

extension HotelViewController {
    @objc func handleFilterButton() {
        let vc = FilterViewController(valueFilter)
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
        valueFilter = data as! FilterModel
        errorView.isHidden = true
        setupViewModel()
    }

}
