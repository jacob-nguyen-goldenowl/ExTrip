//
//  DestinationViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 20/12/2022.
//

import UIKit

fileprivate enum Section: Int {
    case hotel = 0
    case flight = 1
    case event = 2 
    
    var headerTitle: String {
        switch self {
            case .hotel: 
                return "Best Hotels"
            case .event:
                return "Best Events"
            case .flight: 
                return "Best Flights"
        }
    }
    
    static let sections: [Section] = [.hotel, .flight, .event]
}

class DestinationViewController: UIViewController {
    
    private let hotelViewModel = HotelViewModel()
    
    private let sections = Section.sections
    private var allHotels: [HotelModel] = []
    private var countryID: String?
    
    var isSeletedLike: Bool = false
    var titleHeader: String = ""
    var scoreDestination: String?
    var titleDestination: String?
    var imageDestination: String?
    
    // MARK: - Properties
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        table.backgroundColor = .systemBackground
        if #available(iOS 15.0, *) {
            table.sectionHeaderTopPadding = 0
        }
        table.register(DestinationTableViewCell.self,
                       forCellReuseIdentifier: DestinationTableViewCell.identifier)
        return table
    }()
    
    private lazy var cornerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = .systemBackground
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    // MARK: - Initialization
    init(destinationID: String?,
         scoreDestination: String?,
         titleDestination: String?, 
         imageDestination: String?) {
        self.countryID = destinationID
        self.scoreDestination = scoreDestination
        self.titleDestination = titleDestination
        self.imageDestination = imageDestination
        super.init(nibName: nil, bundle: nil)
    }

    // MARK: -Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBinder()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationController?.configBackButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup binder
    private func setupBinder() {
        hotelViewModel.fetchLimitData(destinationID: countryID)
        hotelViewModel.fetchAllData(destinationID: countryID)
        
        hotelViewModel.hotels.bind { [weak self] value in 
            guard let self = self else { return }
            if let value = value {
                self.allHotels = value
            }
        }
    }
    
    // MARK: - Setup UI
    private func setupViews() {
        view.addSubviews(tableView)
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        let header = StretchyTableHeaderView(frame: CGRect(x: 0,
                                                           y: 0,
                                                           width: view.frame.size.width,
                                                           height: 250))
        tableView.tableHeaderView = header
        setupConstaintsView()
    }
    private func setupConstaintsView() {        
        tableView.fillAnchor(view)
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension DestinationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DestinationTableViewCell.identifier, for: indexPath) as? DestinationTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        switch indexPath.section {
            case Section.hotel.rawValue: 
                cell.sectionOfCell  = indexPath.section
                hotelViewModel.limitHotels.bind { value in
                    if let value = value {
                        cell.model = value
                    }
                }
            case Section.flight.rawValue:
                // Just test data
                print("none")
            case Section.event.rawValue:
                // Just test data
                print("none")
            default:
                return DestinationTableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 265
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = setupHeaderView(section)
        return headerView
    }
    
    // MARK: - Setup header view
    private func setupHeaderView(_ section: Int) -> UIView {
        let padding: CGFloat = 15
        let headerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: tableView.frame.size.width, 
                                              height: 75))
        headerView.backgroundColor = .systemBackground
        
        // create label
        let label = UILabel()
        label.text = sections[section].headerTitle
        label.font = .poppins(style: .bold, size: 25) 
        headerView.addSubview(label)
        
        label.anchor(top: headerView.topAnchor,
                     bottom: headerView.bottomAnchor,
                     leading: headerView.leadingAnchor, 
                     paddingLeading: padding)
        label.setWidth(width: tableView.frame.size.width / 2)
        
        // create button
        let button = UIButton()
        let title = ETButtonTitle.viewAll.rawValue
        button.setTitle(title, for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = .poppins(style: .medium, size: 12)
        headerView.addSubview(button)
        
        button.anchor(top: headerView.topAnchor,
                      bottom: headerView.bottomAnchor,
                      trailing: headerView.trailingAnchor, 
                      paddingTrailing: padding)
        
        if section == Section.hotel.rawValue {
            headerView.addSubview(cornerView)
            cornerView.anchor(bottom: headerView.topAnchor,
                              leading: headerView.leadingAnchor,
                              trailing: headerView.trailingAnchor,
                              paddingBottom: -5)
            cornerView.setHeight(height: 40)
        }
        
        switch section {
            case Section.hotel.rawValue:
                button.addTarget(self, action: #selector(handleSeeAllHotelAction), for: .touchUpInside)
            case Section.flight.rawValue: 
                button.addTarget(self, action: #selector(handleSeeAllFlightAction), for: .touchUpInside)
            case Section.event.rawValue: 
                button.addTarget(self, action: #selector(handleSeeAllEventAction), for: .touchUpInside)  
            default:
                fatalError("error clicked button")
        }
        return headerView
    }
    
}

// MARK: - UIScrollViewDelegate
extension DestinationViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let header = tableView.tableHeaderView as? StretchyTableHeaderView else { return }
        header.scrollViewDidScroll(tableView)
        if let image = imageDestination,
           let score = scoreDestination,
           let title = titleDestination {
            header.setDataForHeader(image: image,
                                    score: score,
                                    title: title)
        }
        scrollActionBar(scrollView)
    }
    
    // Show or hiden title bar when scrolling
    private func scrollActionBar(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -20 {
            navigationItem.title = nil
        } else {
            navigationItem.title = titleHeader
        }
    }
    
}

// MARK: - Handle action button
extension DestinationViewController {
    @objc func handleSeeAllHotelAction() {
        let vc = HotelViewController(allHotels)
        vc.title = "Hotels".uppercased()
        navigationAction(vc)
    }
    
    @objc func handleSeeAllFlightAction() {
        print("click see all flights")
    }
    
    @objc func handleSeeAllEventAction() {
        print("click see all event")
    }
}

extension DestinationViewController: DestinationTableViewCellDelegate {
    func destinationTableViewCellhandleHotelNavigation(_ data: HotelModel, row: Int) {
        let vc = DetailViewController(data: data)
        navigationAction(vc)
    }
}
