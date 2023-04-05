//
//  ConfirmPaymentViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 28/02/2023.
//

import UIKit

class ConfirmPaymentViewController: UIViewController {
    
    private var bookingViewModel = BookingViewModel()

    var alert = UIAlertController()
    
    private lazy var loadingView = LottieView()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.showsVerticalScrollIndicator = false
        table.isUserInteractionEnabled = false
        return table
    }()
    
    private lazy var usePaymentMethod = ETGradientButton(title: .payNow, style: .mysticBlue)
    
    // Initialization constructor
    init(data: HotelBookingModel,
         room: RoomModel?,
         price: Double?, 
         numberOfRoom: Int?) {
        bookingViewModel.hotelBooking = data
        bookingViewModel.room = room
        bookingViewModel.price = price
        bookingViewModel.numberOfRoom = numberOfRoom
        if let price = price,
           let taxes = room?.taxes {
            bookingViewModel.totalTaxes = taxes * Double(bookingViewModel.hotelBooking.day)
            bookingViewModel.totalPrice = price + bookingViewModel.totalPrice
        }
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
                self.showAlertWithoutButton(title: "Successful booking",
                                            style: .alert)
                self.dissmisAlert()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            } else {
                self.showAlertWithoutButton(title: "Error booking",
                                            style: .alert)
                self.dissmisAlert()
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
        let currentUserID = AuthManager.shared.getCurrentUserID()

        if let booking = bookingViewModel.hotelBooking.date as? FastisRange,
           let bookingRoom = bookingViewModel.hotelBooking.room,
           let room = bookingViewModel.room,
           let numberOfRoom = bookingViewModel.numberOfRoom {
            
            let arrivalDate = booking.fromDate.dateToTimestamp()
            let departureDate = booking.toDate.dateToTimestamp()
            
            let bookingData = BookingModel(hotelID: room.hotelID, 
                                           roomID: room.id,
                                           guestID: currentUserID,
                                           bookingDate: arrivalDate,
                                           arrivalDate: arrivalDate,
                                           departureDate: departureDate,
                                           roomNumber: numberOfRoom,
                                           roomCharge: bookingViewModel.totalPrice,
                                           numAdults: bookingRoom.adults,
                                           numChildren: bookingRoom.children,
                                           specialReq: "No",
                                           status: "active")
            bookingViewModel.addBooking(bookingData)
            FeatureFlags.isBooking = true
        } else {
            self.showAlertWithoutButton(title: "Error booking",
                                        style: .alert)
            self.dissmisAlert()
        }
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
            if let room = bookingViewModel.room,
               let booking = bookingViewModel.hotelBooking.date as? FastisRange {                    
                hotelCell.setDataForBookingHotel(room,
                                                 arrivalDate: booking.toDate, 
                                                 departureDate: booking.fromDate)
            }
            hotelCell.backgroundColor = .tertiarySystemFill
            return hotelCell
        case 1:
            guard let priceCell = tableView.dequeueReusableCell(withIdentifier: ConfirmPriceTableViewCell.identifier, 
                                                                for: indexPath) as? ConfirmPriceTableViewCell else { return UITableViewCell() }
            priceCell.setDataForPriceRoom(roomCharge: bookingViewModel.price, 
                                          taxes: bookingViewModel.totalTaxes)
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

extension ConfirmPaymentViewController {
    
    func showAlertWithoutButton(title: String? = nil,
                                message: String? = nil,
                                style: UIAlertController.Style) {
        alert = UIAlertController(title: title,
                                  message: message,
                                  preferredStyle: style)
        present(alert, animated: true)
    }
    
    func dissmisAlert() {
        alert.dismiss(animated: true, completion: nil)
    }

}
