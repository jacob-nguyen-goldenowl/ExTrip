//
//  ReviewBookViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 17/02/2023.
//

import UIKit

enum BookType: Int {
    case time = 0
    case room = 1
    case info = 2
}

class ReviewBookViewController: UIViewController {
    
    var room: RoomModel? 
    var bookingTime: HotelBookingModel?
    var fullName: String?
    var phoneNumber: String?
    var email: String?
    
    private var positionRoom: IndexPath = IndexPath(item: 0, section: 0)
    private var numberOfRoom: Int = 1 {
        didSet {
            tableView.reloadData()
            displayTotalPrice()
        }
    }

    private lazy var paymentButton = ETGradientButton(title: .payment, 
                                                      style: .mysticBlue,
                                                      titleColor: .white)
    
    private lazy var containerPriceView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor.theme.tertiarySystemFill ?? UIColor.tertiarySystemFill
        return view
    }()

    private lazy var titlePriceHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(style: .bold, size: 12)
        label.textColor = UIColor.theme.black ?? .black
        label.sizeToFit()
        label.text = "Prepay Online"
        return label
    }()
    
    private lazy var priceRoomLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(style: .bold, size: 20)
        label.textColor = .blue
        label.sizeToFit()
        return label
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        table.allowsSelection = false
        return table
    }()
    
    init(_ data: RoomModel?, time: HotelBookingModel?) {
        room = data
        if let room = time?.room?.room {
            numberOfRoom = room
            positionRoom = IndexPath(item: room - 1, section: 0)
        } else {
            numberOfRoom = 1
        }
        bookingTime = time
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
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setupUI() {
        setupNavigationBar()
        setupViews()
        regiterCell()
        setupAction()
        setupPriceOfRoom()
    }

    private func setupNavigationBar() {
        title = "Review and Book"
        navigationController?.configBackButton()
    }
    
    private func regiterCell() {
        tableView.register(ReviewBookTableViewCell.self,
                           forCellReuseIdentifier: ReviewBookTableViewCell.identifier)
        tableView.register(BookingTimeTableViewCell.self,
                           forCellReuseIdentifier: BookingTimeTableViewCell.identifier)
        tableView.register(InfoUserTableViewCell.self,
                           forCellReuseIdentifier: InfoUserTableViewCell.identifier)
    }
        
    // MARK: - Setup UI
    private func setupViews() {
        self.hideKeyboardWhenTappedAround() 
        view.addSubviews(tableView,
                         containerPriceView)
        containerPriceView.addSubviews(titlePriceHeaderLabel,
                                       priceRoomLabel,
                                       paymentButton)
        tableView.delegate = self
        tableView.dataSource = self
        setupConstaintsView()
    }
    
    private func setupConstaintsView() {  
        let padding: CGFloat = 20
        tableView.anchor(top: view.topAnchor, 
                         bottom: containerPriceView.topAnchor, 
                         leading: view.leadingAnchor,
                         trailing: view.trailingAnchor)
        
        containerPriceView.anchor(bottom: view.bottomAnchor,
                                  leading: view.leadingAnchor,
                                  trailing: view.trailingAnchor)
        containerPriceView.setHeight(height: view.frame.size.height / 9.0)
        
        paymentButton.anchor(top: containerPriceView.topAnchor, 
                                bottom: containerPriceView.bottomAnchor, 
                                trailing: containerPriceView.trailingAnchor,
                                paddingTop: padding,
                                paddingBottom: padding,
                                paddingTrailing: padding)
        paymentButton.setWidth(width: 140)
        
        titlePriceHeaderLabel.anchor(top: containerPriceView.topAnchor,
                                     leading: containerPriceView.leadingAnchor,
                                     trailing: paymentButton.leadingAnchor, 
                                     paddingTop: 5,
                                     paddingLeading: padding,
                                     paddingTrailing: padding)
        titlePriceHeaderLabel.setHeight(height: 20)
        
        priceRoomLabel.anchor(top: titlePriceHeaderLabel.topAnchor,
                              bottom: containerPriceView.bottomAnchor,
                              leading: containerPriceView.leadingAnchor,
                              trailing: paymentButton.leadingAnchor,
                              paddingTop: padding, 
                              paddingBottom: padding,
                              paddingLeading: padding,
                              paddingTrailing: padding)
    }
    
    private func presentBottomSheet() {
        let vc = ChooseRoomViewController()
        setupChooseRoomViewController(with: vc)
        vc.saveCheckBoxPosition = { [weak self] position in
            self?.positionRoom = position
        }
        vc.selectedRows = positionRoom
        
        vc.doneHandler = { [weak self] value in 
            self?.numberOfRoom = value
        }
        vc.currentValue = numberOfRoom
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        present(nav, animated: true)
    }
    
    private func setupChooseRoomViewController(with viewController: ChooseRoomViewController) {
        if let numberOfRoomSameType = room?.numOfRoomSameType {
            var numberOfRoom = [String]()
            for i in 1 ... numberOfRoomSameType {
                numberOfRoom.append("\(i) room")
                viewController.valueAllTypes = numberOfRoom
            }
        }
    }
    
    private func setupPriceOfRoom() {
        priceRoomLabel.text = "$\(room?.price ?? 0.0)"
    }
    
    private func displayTotalPrice() {
        var totalPrice: Double = 0.0
        if let price = room?.price {
            totalPrice = price * Double(numberOfRoom)
        }
        priceRoomLabel.text = "$\(totalPrice)"
    }
    
    private func setupAction() {
        paymentButton.addTarget(self, action: #selector(handlePaymentAction), for: .touchUpInside)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(UserDefaultKey.checkEmptyNotify), object: nil)
    }
}

    // MARK: - UITableViewDelegate, UITableViewDataSource
extension ReviewBookViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.item {
            case BookType.time.rawValue:
                guard let timeCell = tableView.dequeueReusableCell(withIdentifier: BookingTimeTableViewCell.identifier, 
                                                                   for: indexPath) as? BookingTimeTableViewCell else { return UITableViewCell() }
                timeCell.infoBooking = bookingTime
                timeCell.numberOfRoom = numberOfRoom
                return timeCell
            case BookType.room.rawValue:
                guard let roomCell = tableView.dequeueReusableCell(withIdentifier: ReviewBookTableViewCell.identifier, 
                                                               for: indexPath) as? ReviewBookTableViewCell else { return UITableViewCell() }
                roomCell.room = room
                return roomCell
            case BookType.info.rawValue:
                guard let infoCell = tableView.dequeueReusableCell(withIdentifier: InfoUserTableViewCell.identifier, 
                                                               for: indexPath) as? InfoUserTableViewCell else { return UITableViewCell() }
                infoCell.indexPath = indexPath
                infoCell.numberOfRoom = numberOfRoom
                
                infoCell.fullNameCallBack = {[weak self] fullName in
                    self?.fullName = fullName
                }
                infoCell.emailCallBack = {[weak self] email in
                    self?.email = email
                }
                infoCell.phoneCallBack = {[weak self] phone in
                    self?.phoneNumber = phone
                }
                infoCell.delegate = self
                return infoCell
            default:
                return UITableViewCell()
        }
    }
}

extension ReviewBookViewController: InfoUserTableViewCellDelegate {
    func infoUserTableViewCellHandleChooseRoomNavigation(_ data: InfoUserTableViewCell) {
        presentBottomSheet()
    }
}

extension ReviewBookViewController {
    @objc func handlePaymentAction() {
        NotificationCenter.default.post(name: NSNotification.Name(UserDefaultKey.checkEmptyNotify), object: nil)
        
        let currentUserID = UserDefaults.standard.string(forKey: UserDefaultKey.userId)
        guard let booking = bookingTime?.date as? FastisRange else { return }
        guard let bookingRoom = bookingTime?.room else { return }
        guard let room = room else { return }
        
        if let name = fullName,
           let email = email,
           let phone = phoneNumber,
           !name.isEmpty,
           !email.isEmpty,
           !phone.isEmpty {
            
            let arrivalDate = booking.fromDate.dateToTimestamp()
            let departureDate = booking.toDate.dateToTimestamp()
            
            let dataBooking = BookingModel(hotelID: room.hotelID, 
                                           roomID: room.id,
                                           guestID: currentUserID ?? "",
                                           bookingDate: arrivalDate,
                                           arrivalDate: arrivalDate,
                                           departureDate: departureDate,
                                           numAdults: bookingRoom.adults,
                                           numChildren: bookingRoom.children,
                                           specialReq: "No")
            
            let vc = PaymentViewController(booking: dataBooking)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
