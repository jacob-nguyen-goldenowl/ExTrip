//
//  TrackerBookingViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 14/03/2023.
//

import UIKit
import BetterSegmentedControl

private enum SegmentType {
    case active 
    case pass
    case canceled
    
    var segmentTitle: String {
        switch self {
        case .active:
            return "active"
        case .pass:
            return "pass"
        case .canceled:
            return "cancel"
        }
    }
    
    static let segmented: [SegmentType] = [.active, .pass, .canceled]
}

class TrackerBookingViewController: UIViewController {
    
    lazy var viewModel: TrackerBookingViewModel = {
        return TrackerBookingViewModel()
    }()
    
    private let segmented = SegmentType.segmented
    private var segmentIndex: Int = 0
    
    private lazy var titleSegmentedControl = ["Active", "Pass", "Canceled"]
    
    // MARK: Create properties
    private lazy var containerView = UIView() 
    private lazy var containerTableView = UIView()
    
    private lazy var refreshControl = UIRefreshControl()
    private lazy var loadingView = LottieView()
    
    private lazy var segmentedControl: BetterSegmentedControl = {
        let control = BetterSegmentedControl()
        control.segments = LabelSegment.segments(withTitles: titleSegmentedControl,
                                                 normalFont: .poppins(style: .medium, size: 14),
                                                 normalTextColor: .label,
                                                 selectedFont: .poppins(style: .medium, size: 14),
                                                 selectedTextColor: UIColor.theme.primary ?? .blue)
        control.setOptions([.backgroundColor(.clear),
                            .indicatorViewBackgroundColor(UIColor.theme.primary?.withAlphaComponent(0.1) ?? .blue.withAlphaComponent(0.1)),
                            .indicatorViewBorderWidth(0.9),
                            .indicatorViewInset(5),
                            .indicatorViewBorderColor(UIColor.theme.primary ?? .blue),
                            .animationSpringDamping(1.0)])
        control.cornerRadius = 25
        control.addTarget(self,
                          action: #selector(navigationSegmentedControlValueChanged(_:)),
                          for: .valueChanged)
        
        return control
    }()
    
    private lazy var emptyView: EmptyView = {
        let view = EmptyView()
        view.backgroundColor = .systemBackground
        view.lottieAnimation = Constant.Animation.active
        view.emptyString = viewModel.activeEmptyString
        view.delegate = self
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.showsVerticalScrollIndicator = false
        table.clipsToBounds = true
        table.separatorColor = .clear
        table.backgroundColor = .systemBackground
        return table
    }()
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if FeatureFlags.isLogout {
            setupViewModel()
        }
    }
    
    private func setupUI() {
        setupViews()
        regiterCell()
        receiverNotify()
        setupNavigationBar()
    }

    // MARK: Setup UI
    private func setupViews() {
        view.backgroundColor = UIColor.theme.primary
        view.addSubviews(containerView,
                         containerTableView)
        containerView.addSubview(segmentedControl)
        containerTableView.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupConstaintsView()
        setupRefreshControl()
    }
    
    private func setupConstaintsView() {  
        containerView.backgroundColor = .systemBackground
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                             leading: view.leadingAnchor,
                             trailing: view.trailingAnchor)
        containerView.setHeight(height: 50)
        
        segmentedControl.fillAnchor(containerView)
        
        containerTableView.backgroundColor = .systemBackground
        containerTableView.anchor(top: segmentedControl.bottomAnchor,
                                  bottom: view.bottomAnchor, 
                                  leading: view.leadingAnchor,
                                  trailing: view.trailingAnchor)
        
        tableView.fillAnchor(containerTableView)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Trips"
        navigationController?.navigationBar.barTintColor = .blue
    }
    
    // MARK: Fetch data
    private func setupViewModel() {
        viewModel.updateLoadingStatus = { [weak self] in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.startAnimating()
                    self?.tableView.alpha = 0.0
                    self?.hiddenEmptyView()
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
                UIView.animate(withDuration: 0.1, animations: {
                    self?.showEmptyView()
                })
            }
        }
        
        if segmentIndex == 0 {
            viewModel.requestFetchData(segmented[segmentIndex].segmentTitle)
        } else if segmentIndex == 1 {
            viewModel.requestFetchData(segmented[segmentIndex].segmentTitle)
        } else {
            viewModel.requestFetchData(segmented[segmentIndex].segmentTitle)
        }
    }
    
    private func regiterCell() {
        tableView.register(TrackerBookingTableViewCell.self,
                           forCellReuseIdentifier: TrackerBookingTableViewCell.identifier)
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
        tableView.isHidden = true
        view.addSubview(emptyView)
        emptyView.anchor(top: segmentedControl.bottomAnchor,
                         bottom: view.bottomAnchor, 
                         leading: view.leadingAnchor,
                         trailing: view.trailingAnchor)
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
    
    private func showCancelAlert(with bookingID: String?, status: String) {
        // Create the alert
        let alert = UIAlertController(title: "Hey, Wait!!", message: "Are you sure, you want to cancel booking hotel?", preferredStyle: UIAlertController.Style.alert)
        
        // Add the actions (buttons)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: { _ in
            DispatchQueue.main.async { 
                self.viewModel.updateBooking(bookingID, 
                                             status: self.segmented[2].segmentTitle)
                self.setupViewModel()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension TrackerBookingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.isLoading ? 0 : viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackerBookingTableViewCell.identifier,
                                                       for: indexPath) as? TrackerBookingTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        let booking = viewModel.getCellViewModel(at: indexPath)
        let bookingCell = viewModel.createCellViewModel(booking: booking)
        cell.setupDataTrackerBooking(booking: bookingCell)
        cell.hotelID = booking.hotelID
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let booking = viewModel.getCellViewModel(at: indexPath)
        let vc = TrackerDetailViewController(bookingID: booking.id, 
                                             hotelID: booking.hotelID)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension TrackerBookingViewController: EmptyViewDelgate {
    func emptyViewHandleSignIn() {
        let vc = MainViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

// MARK: - Action handlers & setup segmented
extension TrackerBookingViewController {
    @objc func navigationSegmentedControlValueChanged(_ sender: BetterSegmentedControl) {
        segmentIndex = sender.index
        switch segmented[sender.index] {
        case .active:
            setupCurrentSegmentedControl(with: segmented[sender.index].segmentTitle,
                                         animationName: Constant.Animation.active,
                                         emptyString: viewModel.activeEmptyString)
        case .pass:
            setupCurrentSegmentedControl(with: segmented[sender.index].segmentTitle,
                                         animationName: Constant.Animation.pass,
                                         emptyString: viewModel.passEmptyString)
        case .canceled:
            setupCurrentSegmentedControl(with: segmented[sender.index].segmentTitle,
                                         animationName: Constant.Animation.cancel,
                                         emptyString: viewModel.cancelEmptyString)
        }
    }
    
    private func setupCurrentSegmentedControl(with status: String,
                                              animationName: String, 
                                              emptyString: String) {
        emptyView.lottieAnimation = animationName
        emptyView.emptyString = emptyString
        let currentUserID = AuthManager.shared.getCurrentUserID()
        if !currentUserID.isEmpty {
            viewModel.requestFetchData(status)
        } else {
            tableView.reloadData()
        }
    }
}

extension TrackerBookingViewController: TrackerBookingTableViewCellDelegate {
    func trackerBookingTableViewCellHandleCancelBooking(_ cell: TrackerBookingTableViewCell) {
        let bookingID = cell.bookingID
        let status = cell.bookingStatus
        if status == segmented[0].segmentTitle {
            self.showCancelAlert(with: bookingID, status: status)
        } else {
            let vc = HotelBookingViewController()
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
