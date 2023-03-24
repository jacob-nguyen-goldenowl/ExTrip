//
//  HotelViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 03/02/2023.
//

import UIKit

class HotelResultViewController: ETMainViewController {

    private let bookingViewModel = BookingViewModel()
    
    private lazy var emptyView = FilterErrorView()
    
    private var day: Int = 1

    // MARK: - Properties
    private lazy var loadingView: CustomLoadingView = {
        let image: UIImage = UIImage(named: "loading") ?? UIImage()
        return CustomLoadingView(image: image)
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = .clear
        table.separatorStyle = .none
        return table
    }()
    
    // Initialization constructor
    init(data: HotelBookingModel) {
        self.bookingViewModel.hotelBooking = data
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
    
    private func setupNavigationBar() {
        navigationController?.configBackButton()
        
        let booking = bookingViewModel.hotelBooking
        if let date = booking.date as? FastisRange,
           let title = booking.destination,
           let room = booking.room {
            let numberOfGuest = room.numberOfGuest(adults: room.adults,
                                                   children: room.children, 
                                                   infants: room.infants)
        
            let time = date.fromDate.displayDateString + " - " + date.toDate.displayDateString
            let infoBookingRoom = time + " • " + "\(numberOfGuest) Guest"
            navigationItem.titleView = setTitle(title: title, subtitle: infoBookingRoom)
        }
    }
    
    private func fetchDataHotel() {
        bookingViewModel.updateLoadingStatus = { [weak self] in
            DispatchQueue.main.async {
                let isLoading = self?.bookingViewModel.isLoading ?? false
                if isLoading {
                    self?.startLoading()
                    UIView.animate(withDuration: 0.1, animations: {
                        self?.tableView.alpha = 0.0
                        self?.hiddenEmptyView()
                    })
                } else {
                    UIView.animate(withDuration: 0.1, animations: {
                        self?.tableView.alpha = 1.0
                        self?.hiddenEmptyView()
                        self?.stopLoading()
                    })
                }
            }
        }
        
        bookingViewModel.reloadingTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }

        bookingViewModel.showEmptyViewClosure = { [weak self] in 
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.2, animations: {
                    self?.showEmptyView()
                })
            }
        }
        
        let booking = bookingViewModel.hotelBooking
        if let destination = booking.destination?.lowercased(),
           let room = booking.room?.room,
           let date = booking.date as? FastisRange {
            bookingViewModel.dataHotelByCity(city: destination,
                                             numberOfRoom: room, 
                                             time: BookingTime(arrivalDate: date.fromDate,
                                                               departureDate: date.toDate)) 
            
            self.day = numberOf24DaysBetween(date.fromDate, and: date.toDate)
            
        } else {
            stopLoading()
            showEmptyView()
        }
    }
    
    private func regiterCell() {
        tableView.register(HotelResultTableViewCell.self,
                           forCellReuseIdentifier: HotelResultTableViewCell.identifier)
    }
        
    // MARK: - Setup UI
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubviews(emptyView,
                         tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        setupConstaintsView()
    }
    
    private func setupConstaintsView() {  
        emptyView.fillAnchor(view)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         bottom: view.bottomAnchor,
                         leading: view.leadingAnchor,
                         trailing: view.trailingAnchor)
    }
    
    private func receiverNotify() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loginSuccess),
                                               name: NSNotification.Name(UserDefaultKey.loginsuccessNotify),
                                               object: nil)
    }
    
    @objc func loginSuccess() {
        fetchDataHotel()
    }
    
    deinit { 
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(UserDefaultKey.loginsuccessNotify),
                                                  object: nil) 
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
    
    private func showEmptyView() {
        emptyView.isHidden = false
        tableView.isHidden = false
    }
    
    private func hiddenEmptyView() {
        emptyView.isHidden = true
        tableView.isHidden = false
    }
    
    func numberOf24DaysBetween(_ from: Date, and to: Date) -> Int {
        let calendar = Calendar.current
        let numberOfDay = calendar.dateComponents([.day], from: from, to: to)
        return numberOfDay.day! + 1
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension HotelResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookingViewModel.listOfData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HotelResultTableViewCell.identifier, for: indexPath) as? HotelResultTableViewCell else { return UITableViewCell() }
        var hotel = bookingViewModel.getCellViewModel(at: indexPath) 
        cell.day = day
        if wishListViewModel.processComparisonHotelId(hotel.id) {
            hotel.like = true
        } else {
            hotel.like = false
        }
        var room: [RoomModel] = []
        if let rooms = bookingViewModel.rooms {
            room = rooms.filter { $0.hotelID == hotel.id }
        } 
        cell.hotelId = hotel.id
        cell.numberRoomAvailable = room.count
        
        cell.setupDataInfoHotelBooking(hotel: hotel)
        cell.setupDataInfoRoomBooking(room: room.count,
                                      defaultPrice: room.first?.defaultPrice ?? 0.0,
                                      price: room.first?.price ?? 0.0)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hotel = bookingViewModel.getCellViewModel(at: indexPath)
        if let room = bookingViewModel.hotelBooking.room,
           let date = bookingViewModel.hotelBooking.date as? FastisRange {
            let bookingTime = HotelBookingModel(destination: nil,
                                                date: date,
                                                room: room,
                                                day: self.day)
            let vc = DetailViewController(data: hotel,
                                          bookingTime: bookingTime)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
