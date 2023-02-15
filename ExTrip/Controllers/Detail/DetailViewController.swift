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
}

class DetailViewController: UIViewController {
        
    var checkIsLike: Bool = false {
        didSet {
            setupNavigation()
        }
    }
    private var data: HotelModel
    
    // MARK: - Properties
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
        button.backgroundColor = UIColor.theme.lightBlue
        button.setTitle("Select a Room", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = .poppins(style: .medium, size: 13)
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
            
    init(data: HotelModel) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigation()
        setPriceForContainerView()
    }

    private func setupNavigation() {
        navigationController?.configBackButton()
    
        let filterButton = UIButton(type: .custom)
        let image = checkIsLike ? UIImage(named: "favorite.fill") : UIImage(named: "favorite")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        filterButton.setImage(tintedImage, for: .normal)
        filterButton.tintColor = checkIsLike ? UIColor.theme.red ?? .red : UIColor.theme.white ?? .white
        filterButton.addTarget(self, action: #selector(handleLikeAction), for: .touchUpInside)
        let item = UIBarButtonItem(customView: filterButton)
        
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
        setupContainerPriceView()
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
    }
    
    private func setPriceForContainerView() {
        priceRoomLabel.text = ("$\(data.price)")
        
    }
    
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        switch row {
            case DetailType.header.rawValue:
                guard let headerCell = tableView.dequeueReusableCell(withIdentifier: HeaderCollectionTableViewCell.identifier, for: indexPath) as? HeaderCollectionTableViewCell else { return HeaderCollectionTableViewCell() }
                headerCell.listImage = data.image
                headerCell.delegate = self
                return headerCell   
            case DetailType.overview.rawValue:
                guard let overviewCell = tableView.dequeueReusableCell(withIdentifier: OverviewTableViewCell.identifier,
                                                                    for: indexPath) as? OverviewTableViewCell else { return OverviewTableViewCell() }
                overviewCell.scoreRatting = "\(data.rating)"
                overviewCell.title = data.name
                overviewCell.typeHotel = data.type
                overviewCell.addressHotel = data.address
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
                locationCell.descriptionLocation = data.location.description
                locationCell.location = data.location
                locationCell.delegate = self
                return locationCell 
            case DetailType.description.rawValue:
                guard let descriptionCell = tableView.dequeueReusableCell(withIdentifier: DescriptionTableViewCell.identifier,
                                                                   for: indexPath) as? DescriptionTableViewCell else { return DescriptionTableViewCell() }
                descriptionCell.title = "Description"
                descriptionCell.descriptionHotel = data.description
                descriptionCell.delegate = self
                return descriptionCell 
            default:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as? DetailTableViewCell else { return DetailTableViewCell() }
                cell.textLabel?.text = "\(data.rating)/5 - Good"
                cell.accessoryType = .disclosureIndicator
                cell.numberOfReview = "\(data.review)"
                return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected...")
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
            default:
                return 60   
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

extension DetailViewController {
    @objc func handleLikeAction() {
        
    }
}

extension DetailViewController: LocationTableViewCellDelegate {
    func locationTableViewCellHandleSeeMap() {
        let vc = MapViewController(locationHotel: data.location)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension DetailViewController: DescriptionTableViewCellDelegate {
    func descriptionTableViewCellHandleSeeDetails() {
        let vc = ViewDetailsViewController(description: data.description, title: data.name)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension DetailViewController: HeaderCollectionTableViewCellDelegate {
    func headerCollectionTableViewCellHandleViewAllImage(_ allImage: [String]) {
        let vc = ViewAllViewController(allImage: allImage)
        navigationController?.pushViewController(vc, animated: true)
    }
}
