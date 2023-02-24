//
//  HotelViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 03/02/2023.
//

import UIKit


class HotelResultViewController: UIViewController {

    private let bookingViewModel = BookingViewModel()
    
    var hotelDataBooking: HotelBookingModel?
    
    private var rooms: [RoomModel]?
        
    private var hotels: [HotelModel]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Properties
    private lazy var loadingView : CustomLoadingView = {
        let image : UIImage = UIImage(named: "loading") ?? UIImage()
        return CustomLoadingView(image: image)
    }()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = .clear
        table.separatorStyle = .none
        return table
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "hotelBooking")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    // Initialization constructor
    init(data: HotelBookingModel?) {
        self.hotelDataBooking = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLoading()
        setupNavigationBar()
        fetchDataHotel()
        setupViews()
        regiterCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.estimatedRowHeight = 350
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupBinder()
    }
    
    private func startLoading() {
        view.addSubview(loadingView)
        loadingView.center = view.center
        loadingView.startAnimating()
    }
    
    private func stopLoading() {
        loadingView.stopAnimating()
        loadingView.removeFromSuperview()
    }
    
    private func setupNavigationBar() {
        navigationController?.configBackButton()
        
        if let date = hotelDataBooking?.date as? FastisRange,
           let title = hotelDataBooking?.destination,
           let room = hotelDataBooking?.room {
            let numberOfGuest = room.numberOfGuest(adults: room.adults,
                                                   children: room.children, 
                                                   infants: room.infants)
            
            let time = date.fromDate.displayDateString + " - " + date.toDate.displayDateString
            let infoBookingRoom = time + " • " + "\(numberOfGuest) Guest"
            navigationItem.titleView = setTitle(title: title, subtitle: infoBookingRoom)
        }
    }
    
    private func fetchDataHotel() {
        if let destination = hotelDataBooking?.destination?.lowercased(),
           let room = hotelDataBooking?.room?.room,
           let date = hotelDataBooking?.date as? FastisRange {
            bookingViewModel.dataHotelByCity(city: destination,
                                             numberOfRoom: room, 
                                             time: BookingTime(arrivalDate: date.fromDate,
                                                               departureDate: date.toDate)) 
        }
        else {
            stopLoading()
            // Show something ...
            print("error when fetching")
        }
    }
    
    private func regiterCell() {
        tableView.register(HotelResultTableViewCell.self,
                           forCellReuseIdentifier: HotelResultTableViewCell.identifier)
    }
    
    private func setupBinder() {
        bookingViewModel.hotelsRelatedCity.bind { [weak self] hotels in
            if let hotels = hotels, !hotels.isEmpty {
                self?.hotels = hotels
            } else {
                self?.stopLoading() 
            }
        }
        
        bookingViewModel.roomAvailible.bind { [weak self] rooms in
            self?.rooms = rooms
        }
    }
    
    // MARK: - Setup UI
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubviews(tableView)
        view.insertSubview(backgroundImageView, at: 0)
        tableView.delegate = self
        tableView.dataSource = self
        
        setupConstaintsView()
    }
    
    private func setupConstaintsView() {  
        backgroundImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                   bottom: view.bottomAnchor,
                                   leading: view.leadingAnchor,
                                   trailing: view.trailingAnchor)
        
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         bottom: view.bottomAnchor,
                         leading: view.leadingAnchor,
                         trailing: view.trailingAnchor)

    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension HotelResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotels?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HotelResultTableViewCell.identifier, for: indexPath) as? HotelResultTableViewCell else { return UITableViewCell() }
        if let hotel = hotels?[indexPath.item] {
            
            var room: [RoomModel] = []
            if let rooms = rooms {
                room = rooms.filter { $0.hotelID == hotel.id }
            } 
            
            cell.numberRoomAvailable = room.count
            
            cell.setupDataInfoHotelBooking(hotel: hotel)
            
            cell.setupDataInfoRoomBooking(room: room.count,
                                          defaultPrice: room.first?.defaultPrice ?? 0.0,
                                          price: room.first?.price ?? 0.0)
            stopLoading()
        }
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let hotel = hotels?[indexPath.item] {
            if let room = hotelDataBooking?.room,
               let date = hotelDataBooking?.date as? FastisRange {
                let bookingTime = HotelBookingModel(destination: nil,
                                                    date: date,
                                                    room: room)
                let vc = DetailViewController(data: hotel,
                                              bookingTime: bookingTime)
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}
