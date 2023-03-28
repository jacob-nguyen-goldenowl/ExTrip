//
//  RoomViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 15/02/2023.
//

import UIKit

class RoomResultViewController: UIViewController {
        
    private let bookingViewModel = BookingViewModel()
    
    private lazy var errorLabel = ETLabel(style: .large, 
                                          textAlignment: .center,
                                          size: 13,
                                          color: .black)

    init(_ rooms: [RoomModel]?, time: HotelBookingModel) {
        self.bookingViewModel.rooms = rooms
        self.bookingViewModel.hotelBooking = time
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        table.allowsSelection = false
        return table
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "hotelBooking")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
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
    }

    private func regiterCell() {
        tableView.register(RoomResultTableViewCell.self,
                           forCellReuseIdentifier: RoomResultTableViewCell.identifier)
    }
        
    // MARK: - Setup UI
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubviews(errorLabel,
                         tableView)
        tableView.delegate = self
        tableView.dataSource = self
        setupConstaintsView()
    }
    
    private func setupConstaintsView() { 
        setupErrorLabel()
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         bottom: view.bottomAnchor,
                         leading: view.leadingAnchor,
                         trailing: view.trailingAnchor)
    }
    
    private func setupErrorLabel() {
        errorLabel.isHidden = true
        errorLabel.text = "No result"
        errorLabel.fillAnchor(view)
        errorLabel.center(centerX: view.centerXAnchor, 
                          centerY: view.centerYAnchor)
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension RoomResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numberOfRoom = bookingViewModel.rooms?.count {
            return numberOfRoom
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RoomResultTableViewCell.identifier, for: indexPath) as? RoomResultTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = .clear
        if let rooms = bookingViewModel.rooms {
            let room = rooms[indexPath.item]
            cell.setDataForRoom(room: room,
                                day: bookingViewModel.hotelBooking.day) 
            errorLabel.isHidden = true
        } else {
            errorLabel.isHidden = false
        }
        
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Room"
    }
    
}

extension RoomResultViewController: RoomResultTableViewCellDelegate {
    func roomSelectTableViewCellhandleBookNavigation(_ data: RoomResultTableViewCell) {
        checkCurrentUser(data.room, time: bookingViewModel.hotelBooking)
    }
    
    func checkCurrentUser(_ roomInfo: RoomModel?, time: HotelBookingModel?) {
        let userId = UserDefaults.standard.string(forKey: UserDefaultKey.userId)
        if userId != nil {
            let vc = ReviewBookViewController(roomInfo, time: bookingViewModel.hotelBooking)
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = MainViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
}
