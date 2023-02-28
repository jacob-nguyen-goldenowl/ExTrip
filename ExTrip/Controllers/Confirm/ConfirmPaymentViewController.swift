//
//  ConfirmPaymentViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 28/02/2023.
//

import UIKit

class ConfirmPaymentViewController: UIViewController {
    
    private var paymentData = [PaymentModel]()
    private var bookingViewModel = BookingViewModel()
    
    private var bookingData: BookingModel?
    private var roomData: RoomModel?
    
    private lazy var loadingView = LottieView()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = .white
        table.isUserInteractionEnabled = false
        return table
    }()
    
    private lazy var usePaymentMethod = ETGradientButton(title: .payNow, style: .mysticBlue)
    
    // Initialization constructor
    init(data: BookingModel?, room: RoomModel?) {
        self.bookingData = data
        self.roomData = room
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.estimatedRowHeight = 300
    }
    
    private func setupBinder() {
        bookingViewModel.bookingStatus.bind { isBooking in
            if isBooking {
                print("success")
                let vc = TabbarViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            } else {
                print("error")
            }
        }
    }

    private func setupUI() {
        setupNavigationBar()
        setupViews()
        regiterCell()
        setupAction()
    }
    
    private func setupNavigationBar() {
        navigationController?.configBackButton()
        title = "CONFIRM PAYMENT"
    }
    
    private func setupStarLoading() {
        view.addSubview(loadingView)
        loadingView.fillAnchor(view)
        loadingView.startAnimating()
    }
    
    // MARK: - Setup UI
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubviews(tableView,
                         usePaymentMethod)
        tableView.delegate = self
        tableView.dataSource = self
        setupConstaintsView()
    }
    
    private func setupConstaintsView() { 
        let padding: CGFloat = 50
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         bottom: view.bottomAnchor,
                         leading: view.leadingAnchor,
                         trailing: view.trailingAnchor)
        
        usePaymentMethod.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                leading: view.leadingAnchor,
                                trailing: view.trailingAnchor, 
                                paddingBottom: padding,
                                paddingLeading: padding, 
                                paddingTrailing: padding)
        usePaymentMethod.setHeight(height: 50)
    }
    
    private func regiterCell() {
        tableView.register(ConfirmHotelTableViewCell.self,
                           forCellReuseIdentifier: ConfirmHotelTableViewCell.identifier)
        tableView.register(ConfirmPriceTableViewCell.self,
                           forCellReuseIdentifier: ConfirmPriceTableViewCell.identifier)
        tableView.register(PaymentTableViewCell.self,
                           forCellReuseIdentifier: PaymentTableViewCell.identifier)
    }

    private func setupAction() {
        usePaymentMethod.addTarget(self, action: #selector(handleUsePaymentAction), for: .touchUpInside)
    }
    
    @objc func handleUsePaymentAction() {
        setupStarLoading()
        bookingViewModel.addBooking(bookingData!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.loadingView.stopAnimating()
            self?.setupBinder()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ConfirmPaymentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let hotelCell = tableView.dequeueReusableCell(withIdentifier: ConfirmHotelTableViewCell.identifier, 
                                                                for: indexPath) as? ConfirmHotelTableViewCell else { return UITableViewCell() }
            if let room = roomData,
               let arrivalDate = bookingData?.arrivalDate.timestampToDate(),
               let departureDate = bookingData?.departureDate.timestampToDate() {
                hotelCell.setDataForBookingHotel(room,
                                                 arrivalDate: arrivalDate, 
                                                 departureDate: departureDate)
            }
            hotelCell.backgroundColor = .tertiarySystemFill
            return hotelCell
        case 1:
            guard let priceCell = tableView.dequeueReusableCell(withIdentifier: ConfirmPriceTableViewCell.identifier, 
                                                                for: indexPath) as? ConfirmPriceTableViewCell else { return UITableViewCell() }
                
                priceCell.setDataForPriceRoom(roomCharge: bookingData?.roomCharge, 
                                              taxes: roomData?.taxes)
            priceCell.backgroundColor = .tertiarySystemFill
            return priceCell
        case 2:
            guard let methodCell = tableView.dequeueReusableCell(withIdentifier: PaymentTableViewCell.identifier, 
                                                                 for: indexPath) as? PaymentTableViewCell else { return UITableViewCell() }
            methodCell.backgroundColor = .tertiarySystemFill
            methodCell.cardTitle = "apple pay"
                methodCell.cardImage = UIImage(named: "applepay")
            methodCell.accessoryType = .disclosureIndicator
            return methodCell  
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return 50
        }
        return UITableView.automaticDimension
    }
}
