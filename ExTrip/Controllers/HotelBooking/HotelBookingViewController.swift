//
//  HotelBookingViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 20/12/2022.
//

import UIKit

class HotelBookingViewController: UIViewController {
    
    private let dataOfStep: [StepBookingModel] = [
        StepBookingModel(title: "Destination",
                         icon: UIImage(named: "location"),
                         color: UIColor.theme.lightBlue ?? .blue), 
        StepBookingModel(title: "Date",
                         icon: UIImage(named: "event"),
                         color: UIColor.theme.lightBlue ?? .blue),
        StepBookingModel(title: "Rooms and guests",
                         icon: UIImage(named: "user"),
                         color: UIColor.theme.lightBlue ?? .blue)
    ]
    
    var day: Int = 1
    
    var hotel: HotelModel?
        
    var destinationValue: String {
        didSet {
            tableView.reloadData()
        }
    }
    
    var timeValue: FastisValue? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var roomValue: RoomBookingModel {
        didSet {
            tableView.reloadData()
        }
    }
    
    // Initialization
    init(destinationValue: String = "Tokyo",
         timeValue: FastisValue = FastisRange(from: Date.today, to: Date.tomorrow),
         roomValue: RoomBookingModel = RoomBookingModel(room: 1, adults: 2, children: 0, infants: 0)) {
        self.destinationValue = destinationValue
        self.timeValue = timeValue
        self.roomValue = roomValue
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties 
    private let containerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "hotelBooking")
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Hotel Booking"
        label.font = .poppins(style: .bold, size: 30)
        label.numberOfLines = 1
        label.textColor = UIColor.theme.white ?? .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "1,355 World Class For You and Your Family"
        label.font = .poppins(style: .regular)
        label.textAlignment = .center
        label.textColor = UIColor.theme.white ?? .white
        label.numberOfLines = 2
        return label
    }()
    
    private let stepBookingView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 35
        view.clipsToBounds = true
        view.backgroundColor = .systemBackground
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    private let searchHotelButton = ETGradientButton(title: .searchHotel, style: .mysticBlue)
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        table.isScrollEnabled = false
        table.register(HotelBookingTableViewCell.self, 
                       forCellReuseIdentifier: HotelBookingTableViewCell.identifier)
        return table
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationController?.configBackButton()
    }
    
    // MARK: - Setup UI
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(containerView)
        containerView.addSubviews(backgroundImageView,
                                  stepBookingView,
                                  titleLabel,
                                  subTitleLabel)
        
        stepBookingView.addSubviews(tableView, 
                                    searchHotelButton)
        
        tableView.delegate = self
        tableView.dataSource = self
        setupConstraintViews()
        searchHotelButton.addTarget(self, action: #selector(handleSearchHotelAction), for: .touchUpInside)
    }
    
    private func setupConstraintViews() {
        let padding: CGFloat = 10
        containerView.fillAnchor(view)
        
        backgroundImageView.fillAnchor(containerView)
        
        stepBookingView.anchor(bottom: containerView.bottomAnchor,
                               leading: containerView.leadingAnchor,
                               trailing: containerView.trailingAnchor)
        stepBookingView.setHeight(height: view.frame.size.height / 1.5)
        
        subTitleLabel.anchor(bottom: stepBookingView.topAnchor,
                             leading: view.leadingAnchor, 
                             trailing: view.trailingAnchor,
                             paddingBottom: 50,
                             paddingLeading: padding,
                             paddingTrailing: padding)
        subTitleLabel.setHeight(height: 20)
        
        titleLabel.anchor(bottom: subTitleLabel.topAnchor, 
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor, 
                          paddingBottom: padding,
                          paddingLeading: padding,
                          paddingTrailing: padding)
        titleLabel.setHeight(height: 40)
        
        tableView.anchor(top: stepBookingView.topAnchor,
                         bottom: stepBookingView.bottomAnchor,
                         leading: stepBookingView.leadingAnchor, 
                         trailing: stepBookingView.trailingAnchor,
                         paddingTop: 40)
        
        searchHotelButton.anchor(bottom: stepBookingView.bottomAnchor,
                                 leading: stepBookingView.leadingAnchor,
                                 trailing: stepBookingView.trailingAnchor,
                                 paddingBottom: 60, 
                                 paddingLeading: 30,
                                 paddingTrailing: 30)
        searchHotelButton.setHeight(height: 60)
    }
    
    // MARK: - Config controller
    private func configChooseTime() {
        let fastisController = FastisController(mode: .range)
        fastisController.minimumDate = Date()
        fastisController.maximumDate = Calendar.current.date(byAdding: .month, value: 6, to: Date())
        fastisController.allowToChooseNilDate = true
        fastisController.doneHandler = { newValue in
            self.timeValue = newValue
            let time = newValue!
            self.day = self.numberOf24DaysBetween(time.fromDate, and: time.toDate)
        }
        fastisController.initialValue = timeValue as? FastisRange 
        present(fastisController, animated: true)
    }
    
    private func configChooseDestination() {
        let vc = SearchDestinationViewController()
        vc.doneHandler = { [weak self] newValue in
            self?.destinationValue = newValue.localizedCapitalized
        }
        vc.hotelInfomation = { [weak self] hotel in 
            self?.hotel = hotel
        }
        present(vc, animated: true)
    }
    
    private func configChooseRoom() {
        let vc = RoomViewController()
        vc.doneHandler = { newValue in
            self.roomValue = newValue
        }
        vc.initialValue = roomValue
        present(vc, animated: true)
    }

    func numberOf24DaysBetween(_ from: Date, and to: Date) -> Int {
        let calendar = Calendar.current
        let numberOfDay = calendar.dateComponents([.day], from: from, to: to)
        return numberOfDay.day! + 1
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension HotelBookingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HotelBookingTableViewCell.identifier, for: indexPath) as? HotelBookingTableViewCell else { return UITableViewCell() }
        let step = dataOfStep[indexPath.row]
        let row = indexPath.row
        
        if row == 0 {
            cell.destinationValue = destinationValue
        } else if row == 1 {
            cell.timeValue = timeValue
        } else {
            cell.roomValue = roomValue
        }
        cell.getDataStep(step)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        if row == 0 {
            configChooseDestination()
        } else if row == 1 {
            configChooseTime()
        } else {
            configChooseRoom()
        }
    }
    
}

// MARK: - Handle action
extension HotelBookingViewController {
    @objc func handleSearchHotelAction() {
        let data = HotelBookingModel(destination: destinationValue,
                                     date: timeValue, 
                                     room: roomValue, 
                                     day: day)
        if let hotel = hotel {
            let vc = DetailViewController(data: hotel, bookingTime: data)
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = HotelResultViewController(data: data)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
