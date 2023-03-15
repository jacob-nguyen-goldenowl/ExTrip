//
//  TrackerBookingViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 14/03/2023.
//

import UIKit
import BetterSegmentedControl

enum SegmentType {
    case active 
    case pass
    case canceled
    
    var segmentTitle: String {
        switch self {
        case .active:
            return "Active"
        case .pass:
            return "Pass"
        case .canceled:
            return "Canceled"
        }
    }
    
    static let section: [SegmentType] = [.active, .pass, .canceled]
}

class TrackerBookingViewController: UIViewController {
    
    lazy var viewModel: TrackerBookingViewModel = {
        return TrackerBookingViewModel()
    }()
    
    private let section = SegmentType.section
    
    private lazy var titleSegmentedControl = ["Active", "Pass", "Canceled"]
    
    private lazy var containerView = UIView() 
    
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
    
    private lazy var refreshControl = UIRefreshControl()
    
    private lazy var loadingView = LottieView()
    
    private lazy var emptyView: EmptyView = {
        let view = EmptyView()
        view.backgroundColor = .white
        view.lottieAnimation = Constant.Animation.active
        view.delegate = self
        return view
    }()
    
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
        setupNavigationBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if FeatureFlags.isUpdateWishlist {
            setupViewModel()
            FeatureFlags.isUpdateWishlist = false
        }
    }

    // MARK: - Setup UI
    private func setupViews() {
        view.backgroundColor = UIColor.theme.primary
        view.addSubviews(containerView,
                         tableView)
        containerView.addSubview(segmentedControl)
        
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
        
        tableView.anchor(top: segmentedControl.bottomAnchor,
                         bottom: view.bottomAnchor, 
                         leading: view.leadingAnchor,
                         trailing: view.trailingAnchor)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Trips"
        navigationController?.navigationBar.barTintColor = .blue
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
        viewModel.requestFetchData("active")
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
        cell.delegate = self
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
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

extension TrackerBookingViewController: EmptyViewDelgate {
    func emptyViewHandleSignIn() {
        let vc = MainViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

// MARK: - Action handlers
extension TrackerBookingViewController {
    @objc func navigationSegmentedControlValueChanged(_ sender: BetterSegmentedControl) {
        if sender.index == 0 {
            print("Turning lights on.")
            emptyView.lottieAnimation = Constant.Animation.active
            viewModel.requestFetchData("active")
        } else {
            emptyView.lottieAnimation = Constant.Animation.emptyBox
            viewModel.requestFetchData("pass")
        }
    }
}

extension TrackerBookingViewController: TrackerBookingTableViewCellDelegate {
    func trackerBookingTableViewCellHandleCancelBooking(_ cell: TrackerBookingTableViewCell) {
        self.showAlert(title: "Hey, wait!!", message: "Are you sure, you want to cancel this booking your order? If you cancel your trip, you will forfeit the entire amount paid in advance.", style: .alert)
    }
    
}
