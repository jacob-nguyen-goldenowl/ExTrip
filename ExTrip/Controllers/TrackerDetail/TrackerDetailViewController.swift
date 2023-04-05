//
//  TrackerDetailViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 20/03/2023.
//

import UIKit

class TrackerDetailViewController: UIViewController {
    
    private var viewModel = HotelViewModel()
    private lazy var loadingView = LottieView()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.showsVerticalScrollIndicator = false
        table.isUserInteractionEnabled = false
        table.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return table
    }()
        
    // Initialization constructor
    init(bookingID: String?, hotelID: String) {
        viewModel.bookingID = bookingID
        viewModel.hotelID = hotelID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimating()
        tableView.alpha = 0.0
        setupViewModel()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.estimatedRowHeight = 300
    }
    
    private func setupUI() {
        setupNavigationBar()
        setupViews()
        regiterCell()
    }
    
    private func setupNavigationBar() {
        navigationController?.configBackButton()
        title = "Booking Detail"
    }
    
    private func setupStarLoading() {
        view.addSubview(loadingView)
        loadingView.fillAnchor(view)
        loadingView.startAnimating()
    }
    
        // MARK: - Setup UI
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubviews(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        setupConstaintsView()
    }
    
    private func setupConstaintsView() { 
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         bottom: view.bottomAnchor,
                         leading: view.leadingAnchor,
                         trailing: view.trailingAnchor)
    }
    
    private func regiterCell() {
        tableView.register(HotelTrackerDetailTableViewCell.self,
                           forCellReuseIdentifier: HotelTrackerDetailTableViewCell.identifier)
        tableView.register(TrackerDetailTableViewCell.self,
                           forCellReuseIdentifier: TrackerDetailTableViewCell.identifier)
        tableView.register(TrackerQRCodeTableViewCell.self,
                           forCellReuseIdentifier: TrackerQRCodeTableViewCell.identifier)
    }
    
    private func setupViewModel() {
        viewModel.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.stopAnimating()
                UIView.animate(withDuration: 0.2, animations: {
                    self?.tableView.alpha = 1.0
                })
                self?.tableView.reloadData()
            }
        }
    }

    private func startAnimating() {
        view.addSubview(loadingView)
        loadingView.fillAnchor(view)
        loadingView.startAnimating()
    }
    
    private func stopAnimating() {
        loadingView.stopAnimating()
    }
    
    private func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return UIImage(systemName: "xmark.circle")
    }
    
}

    // MARK: - UITableViewDelegate, UITableViewDataSource
extension TrackerDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TrackerDetailTableViewCell
        switch indexPath.row {
        case 0:
            guard let hotelCell = tableView.dequeueReusableCell(withIdentifier: HotelTrackerDetailTableViewCell.identifier, 
                                                                for: indexPath) as? HotelTrackerDetailTableViewCell else { return UITableViewCell() }
            if let hotel = viewModel.hotel {
                hotelCell.setDataForHotelTracker(hotel)
                } else {
                    tableView.reloadData()
                }
            hotelCell.backgroundColor = .tertiarySystemFill
            return hotelCell
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: TrackerDetailTableViewCell.identifier, 
                                                 for: indexPath) as! TrackerDetailTableViewCell 
            cell.textLabel?.text = "Room:"
            if let booking = viewModel.booking {
                cell.title = "\(booking.roomNumber) Room - \(booking.numAdults) Adults - \(booking.numChildren) Children"
            }
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: TrackerDetailTableViewCell.identifier, 
                                                 for: indexPath) as! TrackerDetailTableViewCell 
            cell.textLabel?.text = "Check-in:"
            cell.title = viewModel.booking?.arrivalDate.timestampToDate().displayMonthString
        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: TrackerDetailTableViewCell.identifier, 
                                                 for: indexPath) as! TrackerDetailTableViewCell
            cell.textLabel?.text = "Check-out:"
            cell.title = viewModel.booking?.departureDate.timestampToDate().displayMonthString
        case 4:
            cell = tableView.dequeueReusableCell(withIdentifier: TrackerDetailTableViewCell.identifier, 
                                                 for: indexPath) as! TrackerDetailTableViewCell
            cell.textLabel?.text = "Total:"
            cell.title = viewModel.booking?.roomCharge.toCurrency() ?? "---" 
            cell.isHighLight = true
        case 5:
            guard let qrCodeCell = tableView.dequeueReusableCell(withIdentifier: TrackerQRCodeTableViewCell.identifier, 
                                                                 for: indexPath) as? TrackerQRCodeTableViewCell else { return UITableViewCell() }
            qrCodeCell.image = generateQRCode(from: viewModel.booking?.id ?? "")
            qrCodeCell.backgroundColor = .tertiarySystemFill
            return qrCodeCell
        default:
            return UITableViewCell()
        }
        cell.backgroundColor = .tertiarySystemFill
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = 0.0
        switch indexPath.row {
        case 0, 5:
            height = 120
        default:
            height = 60
        }
        return height
    }
}
