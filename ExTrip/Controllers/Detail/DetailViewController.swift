//
//  DetailViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 09/01/2023.
//

import UIKit

enum DetailType: Int {
    case header = 0 
    case overview = 1
    case review = 2
    case information = 3
    case location = 4
    case description = 5
    case time = 6
}

class DetailViewController: ETMainViewController {
        
    private let bookingViewModel = BookingViewModel()
    
    // MARK: - Properties
    private lazy var spinner = UIActivityIndicatorView(style: .medium)
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.bouncesZoom = false
        table.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        table.allowsSelection = false
        table.bounces = false
        return table
    }()
    
    private lazy var containerPriceView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.theme.tertiarySystemFill ?? UIColor.tertiarySystemFill
        return view
    }()
    
    private lazy var selectRoomButton: UIButton = {
        let button = UIButton()
        button.setTitle("Select a Room", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = .poppins(style: .medium, size: 13)
        button.addTarget(self, action: #selector(handleSelectRoomAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var titlePriceHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(style: .medium, size: 11)
        label.textColor = UIColor.theme.lightGray
        label.sizeToFit()
        label.text = "Price/room/night from"
        return label
    }()
    
    private lazy var priceRoomLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(style: .bold, size: 20)
        label.textColor = UIColor.theme.lightBlue
        label.sizeToFit()
        return label
    }()
            
    init(data: HotelModel, bookingTime: HotelBookingModel = HotelBookingModel(destination: nil, 
                                                                              date: FastisRange(from: Date.today, to: Date.tomorrow),
                                                                              room: RoomBookingModel(room: 1, adults: 2, children: 0, infants: 0),
                                                                              day: 1)) {
        self.bookingViewModel.hotel = data
        self.bookingViewModel.hotelBooking = bookingTime
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        navigationController?.configBackButton()
        setupViewModel()
    }    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupNavigation()
    }   
    
    private func setupViewModel() {
        bookingViewModel.updateLoadingStatus = { [weak self] in
            DispatchQueue.main.async {
                let isLoading = self?.bookingViewModel.isLoading ?? false
                if isLoading {
                    self?.startAnimating()
                } else {
                    self?.stopAnimating()
                }
            }
        }
        
        bookingViewModel.reloadingTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                if let rooms = self?.bookingViewModel.rooms, !rooms.isEmpty {
                    self?.checkRoomAvailable(true)
                } else {
                    self?.checkRoomAvailable(false)
                }
            }
        }
        
        if let date = bookingViewModel.hotelBooking.date as? FastisRange,
           let hotel = bookingViewModel.hotel {
            bookingViewModel.fetchRoomByOneHotel(hotel.id,
                                                 time: BookingTime(arrivalDate: date.fromDate,
                                                                   departureDate: date.toDate))
        }
    }
    
    private func startAnimating() {
        containerPriceView.addSubview(spinner)
        spinner.center(centerX: containerPriceView.centerXAnchor, 
                       centerY: containerPriceView.centerYAnchor)
        spinner.startAnimating()
    }
    
    private func stopAnimating() {
        spinner.removeFromSuperview()
        spinner.stopAnimating()
        spinner.hidesWhenStopped = true
    }
    
    // MARK: Setup navigation bar
    private func setupNavigation() {
        let favouriteButton = ETFavoriteButton()
        guard let id = bookingViewModel.hotel?.id else { return }
        if wishListViewModel.processComparisonHotelId(id) {
            favouriteButton.isChecked = true
        } else {
            favouriteButton.isChecked = false
        }
        setupFavorite(favouriteButton)
        let item = UIBarButtonItem(customView: favouriteButton)
        
        if let date = bookingViewModel.hotelBooking.date as? FastisRange,
           let name = bookingViewModel.hotel?.name,
           let room = bookingViewModel.hotelBooking.room {
            let numberOfGuest = room.numberOfGuest(adults: room.adults,
                                                   children: room.children, 
                                                   infants: room.infants)
            let time = date.fromDate.displayDateString + " - " + date.toDate.displayDateString
            let infoBookingRoom = time + " • " + "\(numberOfGuest) Guest"
            navigationItem.titleView = setTitle(title: name.capitalizeFirstLetter(), subtitle: infoBookingRoom)
            navigationItem.titleView?.isHidden = true
        }
        
        self.navigationItem.setRightBarButton(item, animated: true)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubviews(tableView,
                         containerPriceView)
        registerCell()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.insetsContentViewsToSafeArea = false
        tableView.contentInsetAdjustmentBehavior = .never
        setupConstraintUI()
    }
    
    private func setupConstraintUI() {
        containerPriceView.anchor(bottom: view.bottomAnchor,
                                  leading: view.leadingAnchor,
                                  trailing: view.trailingAnchor)
        containerPriceView.setHeight(height: view.frame.size.height / 10.0)
        
        tableView.anchor(top: view.topAnchor,
                         bottom: containerPriceView.topAnchor, 
                         leading: view.leadingAnchor,
                         trailing: view.trailingAnchor)
    }
    
    private func registerCell() {
        tableView.register(HeaderCollectionTableViewCell.self, 
                           forCellReuseIdentifier: HeaderCollectionTableViewCell.identifier)
        tableView.register(DetailTableViewCell.self,
                           forCellReuseIdentifier: "DetailTableViewCell")
        tableView.register(InformationTableViewCell.self,
                           forCellReuseIdentifier: InformationTableViewCell.identifier)
        tableView.register(LocationTableViewCell.self, 
                           forCellReuseIdentifier: LocationTableViewCell.identifier)
        tableView.register(OverviewTableViewCell.self,
                           forCellReuseIdentifier: OverviewTableViewCell.identifier)
        tableView.register(DescriptionTableViewCell.self,
                           forCellReuseIdentifier: DescriptionTableViewCell.identifier)
        tableView.register(TimeTableViewCell.self,
                           forCellReuseIdentifier: TimeTableViewCell.identifier)
    }
    
    private func setPriceForContainerView() {
        let price = bookingViewModel.hotel?.price ?? 0.0
        let totalPrice = price * Double(bookingViewModel.hotelBooking.day)
        priceRoomLabel.text = totalPrice.convertDoubleToCurrency()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 { 
            navigationItem.titleView?.isHidden = false
        } else {   
            navigationItem.titleView?.isHidden = true
        }   
    }
    
    @objc func handleSelectRoomAction() {
        let vc = RoomResultViewController(bookingViewModel.rooms, time: bookingViewModel.hotelBooking)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupFavorite(_ favouriteButton: ETFavoriteButton) {
        guard let hotelID = bookingViewModel.hotel?.id else { return }
        favouriteButton.currentUser = currentUser
        let wishlist = WishListModel(hotelID: hotelID, userID: currentUser)
        favouriteButton.likedClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.wishListViewModel.addWishtlist(with: wishlist)
            }
        } 
        
        favouriteButton.dislikeClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.wishListViewModel.removeFromWishlist(with: hotelID)
            }
        }
    }
    
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let hotel = bookingViewModel.hotel
        switch row {
        case DetailType.header.rawValue:
            guard let headerCell = tableView.dequeueReusableCell(withIdentifier: HeaderCollectionTableViewCell.identifier,
                                                                 for: indexPath) as? HeaderCollectionTableViewCell else { return HeaderCollectionTableViewCell() }
            headerCell.listImage = hotel?.image ?? []
            headerCell.delegate = self
            return headerCell   
        case DetailType.overview.rawValue:
            guard let overviewCell = tableView.dequeueReusableCell(withIdentifier: OverviewTableViewCell.identifier,
                                                                   for: indexPath) as? OverviewTableViewCell else { return OverviewTableViewCell() }
            overviewCell.scoreRatting = "\(hotel?.rating ?? 1)"
            overviewCell.title = hotel?.name
            overviewCell.typeHotel = hotel?.type
            overviewCell.addressHotel = hotel?.address
            return overviewCell
        case DetailType.information.rawValue:
            guard let infoCell = tableView.dequeueReusableCell(withIdentifier: InformationTableViewCell.identifier,
                                                               for: indexPath) as? InformationTableViewCell else { return InformationTableViewCell() }
            infoCell.title = "Hotel Information"
            return infoCell  
        case DetailType.location.rawValue:
                guard let locationCell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.identifier,
                                                                       for: indexPath) as? LocationTableViewCell else { return LocationTableViewCell() }
            locationCell.title = "Location"
            locationCell.descriptionLocation = hotel?.location.description
            locationCell.location = hotel?.location
            locationCell.delegate = self
            return locationCell 
        case DetailType.description.rawValue:
            guard let descriptionCell = tableView.dequeueReusableCell(withIdentifier: DescriptionTableViewCell.identifier,
                                                                      for: indexPath) as? DescriptionTableViewCell else { return DescriptionTableViewCell() }
            descriptionCell.title = "Description"
            descriptionCell.descriptionHotel = hotel?.description
            descriptionCell.delegate = self
            return descriptionCell 
        case DetailType.time.rawValue:
            guard let timeCell = tableView.dequeueReusableCell(withIdentifier: TimeTableViewCell.identifier,
                                                               for: indexPath) as? TimeTableViewCell else { return TimeTableViewCell() }
                timeCell.infoBooking = bookingViewModel.hotelBooking
            return timeCell 
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell",
                                                           for: indexPath) as? DetailTableViewCell else { return DetailTableViewCell() }
                cell.textLabel?.text = "\(hotel?.rating ?? 5)/5 - Good"
            cell.accessoryType = .disclosureIndicator
            cell.numberOfReview = "\(hotel?.review ?? 0)"
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row 
        let padding: CGFloat = 4
        switch row {
        case DetailType.header.rawValue:
            return (view.frame.size.width / 1.5) + padding
        case DetailType.overview.rawValue:
            return 110
        case DetailType.information.rawValue:
            return 200
        case DetailType.location.rawValue:
            return 300
        case DetailType.description.rawValue:
            return 300
        case DetailType.time.rawValue:
            return 80
        default:
            return 60   
        }
    }
    
    private func checkRoomAvailable(_ isAvailable: Bool) {
        if isAvailable {
            selectRoomButton.isUserInteractionEnabled = true
            selectRoomButton.backgroundColor = UIColor.theme.lightBlue
            setPriceForContainerView()
            setupContainerPriceView()
        } else {
            setupContainerPriceView()
            selectRoomButton.isUserInteractionEnabled = false
            selectRoomButton.backgroundColor = UIColor.theme.lightGray
            priceRoomLabel.text = ("We're sold out!")
            priceRoomLabel.font = .poppins(style: .medium, size: 15)
            priceRoomLabel.textColor = UIColor.theme.lightGray
        }
    }
    
    private func setupContainerPriceView() {
        let padding: CGFloat = 17
        containerPriceView.addSubviews(titlePriceHeaderLabel,
                                       priceRoomLabel,
                                       selectRoomButton)
        
        selectRoomButton.anchor(top: containerPriceView.topAnchor, 
                                bottom: containerPriceView.bottomAnchor, 
                                trailing: containerPriceView.trailingAnchor,
                                paddingTop: padding,
                                paddingBottom: padding,
                                paddingTrailing: padding)
        selectRoomButton.setWidth(width: 120)
        
        titlePriceHeaderLabel.anchor(top: containerPriceView.topAnchor,
                                     leading: containerPriceView.leadingAnchor,
                                     trailing: selectRoomButton.leadingAnchor, 
                                     paddingTop: 5,
                                     paddingLeading: padding,
                                     paddingTrailing: padding)
        titlePriceHeaderLabel.setHeight(height: 20)
        
        priceRoomLabel.anchor(top: titlePriceHeaderLabel.topAnchor,
                              bottom: containerPriceView.bottomAnchor,
                              leading: containerPriceView.leadingAnchor,
                              trailing: selectRoomButton.leadingAnchor,
                              paddingTop: padding, 
                              paddingBottom: padding,
                              paddingLeading: padding,
                              paddingTrailing: padding)
    }
}

extension DetailViewController: LocationTableViewCellDelegate {
    func locationTableViewCellHandleSeeMap() {
        guard let location = bookingViewModel.hotel?.location else { return }
        let vc = MapViewController(locationHotel: location)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension DetailViewController: DescriptionTableViewCellDelegate {
    func descriptionTableViewCellHandleSeeDetails() {
        if let hotel = bookingViewModel.hotel {
            let vc = ViewDetailsViewController(description: hotel.description,
                                               title: hotel.name)
            navigationController?.pushViewController(vc, animated: true)
        } else {
            self.showAlert(title: "Alert", message: "Something error when fetch data", style: .alert)
        }
    }
}

extension DetailViewController: HeaderCollectionTableViewCellDelegate {
    func headerCollectionTableViewCellHandleViewAllImage(_ allImage: [String]) {
        let vc = ViewAllViewController(allImage: allImage)
        navigationController?.pushViewController(vc, animated: true)
    }
}
