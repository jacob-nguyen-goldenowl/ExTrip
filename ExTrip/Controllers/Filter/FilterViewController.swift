//
//  FilterViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 04/01/2023.
//

import UIKit

enum Filter: Int {
    case price = 0
    case rating = 1
    case hotel = 2
    case sevice = 3
    case type = 4
    case bed = 5
    case payment = 6
    
    var title: String {
        switch self {
            case .price:
                return "Price Range"
            case .rating:
                return "Guest rating"
            case .hotel:
                return "Hotel Class"
            case .sevice:
                return "Service & Facilities"
            case .type: 
                return "Property Type"
            case .bed:
                return "Bed Type"
            case .payment: 
                return "Payment"
        }
    }
    
    static let filtes: [Filter] = [.price, .rating, .hotel, .sevice, .type, .bed, .payment]
}

class FilterViewController: UIViewController {
    
    // MARK: - Properties
    private let filtes = Filter.filtes
    
    private var rangePrice: Price? 
    private var currentRating: Double?
    private var currentStar: Int?
    
    private var positionService: [IndexPath] = []
    private var currentValueService: [String] = []
    private var positionProperty: [IndexPath] = []
    private var currentValueProperty: [String] = []
    private var positionBed: [IndexPath] = []
    private var currentValueBed: [String] = []
    private var positionPayment: [IndexPath] = []
    private var currentValuePayment: [String] = []
    
    private var valueDefault = FilterModel(price: Price(maximun: 1000.0, minimun: 0.0),
                                           star: 0,
                                           service: [],
                                           rating: 0,
                                           positionService: [],
                                           property: [], 
                                           positionProperty: [],
                                           bed: [],
                                           positionBed: [],
                                           payment: [],
                                           positionPayment: [])
    
    private let service = ["Car Parking",
                           "Car Retail", 
                           "Pets Allowed", 
                           "Fitness Center",
                           "Restaurant",
                           "Currency Exchange",
                           "Swimming Pool", 
                           "Airport Pickup service"]
    
    private let property = ["Flat",
                            "Apartment",
                            "Couple Corner",
                            "Villa House",
                            "Hostel"] 
    
    private let bed = ["Single",
                       "Double", 
                       "Triple"] 
    
    private let payment = ["Pay at Hotel",
                           "Online Payment", 
                           "Advance Payment"] 
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.bouncesZoom = false
        table.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        table.bounces = false
        return table
    }()
    
    private lazy var filterButton = ETGradientButton(title: .result, style: .mysticBlue)
    
    convenience init(_ initialValue: FilterModel) {
        self.init()
        rangePrice = initialValue.price
        currentRating = initialValue.rating
        currentStar = initialValue.star
        currentValueService = initialValue.service
        positionService = initialValue.positionService
        positionProperty = initialValue.positionProperty
        currentValueProperty = initialValue.property
        positionBed = initialValue.positionBed
        currentValueBed = initialValue.bed
        positionPayment = initialValue.positionPayment
        currentValuePayment = initialValue.payment
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupViews()
        registerCell()
        setupAction()
    }
    
    private func registerCell() {
        tableView.register(PriceTableViewCell.self,
                           forCellReuseIdentifier: PriceTableViewCell.identifier)
        tableView.register(RatingTableViewCell.self,
                           forCellReuseIdentifier: RatingTableViewCell.identifier)
        tableView.register(HotelClassTableViewCell.self,
                           forCellReuseIdentifier: HotelClassTableViewCell.identifier)
        tableView.register(FilterTableViewCell.self,
                           forCellReuseIdentifier: FilterTableViewCell.mainIdentifier)
    }
    
    private func setupNavigation() {
        navigationController?.configBackButton()
        
        let clearButton = UIButton(type: .custom)
        clearButton.setTitle("CLEAR", for: .normal)
        clearButton.setTitleColor(.label, for: .normal)
        clearButton.titleLabel?.font = .poppins(style: .bold, size: 16)
        clearButton.addTarget(self, action: #selector(handleClearAction), for: .touchUpInside)
        let item = UIBarButtonItem(customView: clearButton)
        
        self.navigationItem.setRightBarButton(item, animated: true)
    }
    
    @objc func handleClearAction() {
        rangePrice = valueDefault.price
        currentRating = valueDefault.rating
        currentStar = valueDefault.star
        currentValueService = valueDefault.service
        positionService = valueDefault.positionService
        positionProperty = valueDefault.positionProperty
        currentValueProperty = valueDefault.property
        positionBed = valueDefault.positionBed
        currentValueBed = valueDefault.bed
        positionPayment = valueDefault.positionPayment
        currentValuePayment = valueDefault.payment
        tableView.reloadData()
    }
    
    
    // MARK: - Setup views
    private func setupViews() {
        title = "filters".uppercased()
        view.backgroundColor = .systemBackground
        view.addSubviews(tableView,
                         filterButton)
        tableView.delegate = self
        tableView.dataSource = self
        
        setupConstraintView()
    }
    
    private func setupConstraintView() {
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         leading: view.leadingAnchor, 
                         trailing: view.trailingAnchor)
        
        filterButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            leading: view.leadingAnchor, 
                            trailing: view.trailingAnchor,
                            paddingBottom: 50,
                            paddingLeading: 30, 
                            paddingTrailing: 30)
        filterButton.setHeight(height: 50)
    }
    
    private func setupAction() {
        filterButton.addTarget(self, action: #selector(handleFilterAction), for: .touchUpInside)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(UserDefaultKey.loadingNotify), object: nil)
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
            case Filter.price.rawValue,
                 Filter.rating.rawValue,
                 Filter.hotel.rawValue:
                return 100
            default:
                return 60
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        switch row {
            case Filter.price.rawValue:
                guard let  cell = tableView.dequeueReusableCell(withIdentifier: PriceTableViewCell.identifier, for: indexPath) as? PriceTableViewCell else { return PriceTableViewCell() }
                cell.priceValue = { value in
                    self.rangePrice = value
                }
                cell.rangePrice = rangePrice
                cell.title = "Price Range"
                return cell
                
            case Filter.rating.rawValue:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: RatingTableViewCell.identifier, for: indexPath) as? RatingTableViewCell else { return RatingTableViewCell() }
                cell.currentValue = { value in
                    self.currentRating = value
                }
                cell.ratingValue = Float(currentRating ?? 0.0)
                cell.title = "Guest Rating"
                return cell
                
            case Filter.hotel.rawValue:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: HotelClassTableViewCell.identifier, for: indexPath) as? HotelClassTableViewCell else { return HotelClassTableViewCell() }
                cell.currentStar = { star in
                    self.currentStar = star
                }
                cell.starIndex = currentStar
                cell.title = "Hotel Class"
                return cell
                	
            case Filter.sevice.rawValue,
                 Filter.type.rawValue,
                 Filter.bed.rawValue,
                 Filter.payment.rawValue:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterTableViewCell.mainIdentifier, for: indexPath) as? FilterTableViewCell else { return FilterTableViewCell() }
                cell.accessoryType  = .disclosureIndicator
                cell.selectionStyle = .default
                cell.textLabel?.text = filtes[row].title
                return cell
                
            default:  
                return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        let vc = TypeViewController()
        vc.text = filtes[row].title
        switch row {
            case Filter.sevice.rawValue:
                vc.valueAllTypes = service
                vc.saveCheckBoxPosition = { [weak self] position in
                    self?.positionService = position
                }
                vc.selectedRows = positionService
                
                vc.doneHandler = { [weak self] value in 
                    self?.currentValueService = value
                }
                vc.currentValue = currentValueService
                
                present(vc, animated: true)
            case Filter.type.rawValue:
                vc.valueAllTypes = property
                vc.saveCheckBoxPosition = { [weak self] position in
                    self?.positionProperty = position
                }
                vc.selectedRows = positionProperty
                
                vc.doneHandler = { [weak self] value in 
                    self?.currentValueProperty = value
                }
                vc.currentValue = currentValueProperty
                
                present(vc, animated: true)
            case Filter.bed.rawValue:
                vc.valueAllTypes = bed
                vc.saveCheckBoxPosition = { [weak self] position in
                    self?.positionBed = position
                }
                vc.selectedRows = positionBed
                
                vc.doneHandler = { [weak self] value in 
                    self?.currentValueBed = value
                }
                vc.currentValue = currentValueBed
                present(vc, animated: true)
            case Filter.payment.rawValue:
                vc.valueAllTypes = payment
                vc.saveCheckBoxPosition = { [weak self] position in
                    self?.positionPayment = position
                }
                vc.selectedRows = positionPayment
                
                vc.doneHandler = { [weak self] value in 
                    self?.currentValuePayment = value
                }
                vc.currentValue = currentValuePayment
                present(vc, animated: true)
            default:
                print("nil")
        }
    }
}

extension FilterViewController {
    @objc func handleFilterAction() {
        sentNotificationCenter()
        navigationController?.popViewController(animated: false)
    }
}


// MARK: - Setup notification
extension FilterViewController {
    private func sentNotificationCenter() {
        let dataNeedFilter = FilterModel(price: rangePrice ?? Price(maximun: 1000.0, minimun: 0.0),
                                         star: currentStar ?? 5, 
                                         service: currentValueService,
                                         rating: currentRating ?? 0.0,
                                         positionService: positionService,
                                         property: currentValueProperty,
                                         positionProperty: positionProperty,
                                         bed: currentValueBed,
                                         positionBed: positionBed,
                                         payment: currentValuePayment,
                                         positionPayment: positionPayment)
        
        NotificationCenter.default.post(name: NSNotification.Name(UserDefaultKey.loadingNotify), object: dataNeedFilter)
    }
}

