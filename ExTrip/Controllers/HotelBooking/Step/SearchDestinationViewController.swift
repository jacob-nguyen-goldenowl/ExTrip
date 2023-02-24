//
//  LocationViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 20/12/2022.
//

import UIKit

class SearchDestinationViewController: UIViewController {

    var doneHandler: ((String) -> Void)?
    var hotelInfomation: ((HotelModel?) -> Void)?
    var timer: Timer?
    
    private let searchViewModel = SearchViewModel()
    private var currentText: String = ""
    
    private var hotels: [HotelModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let iconPadding: CGFloat = 15
    private let iconHeight: CGFloat = 20
    
    // MARK: - Properties
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Search Your Destination"
        label.font = .poppins(style: .bold)
        return label
    }()
    
    private lazy var searchTextField: ETSearchBar = {
        let searchBar = ETSearchBar()
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.theme.lightGray?.cgColor
        searchBar.layer.cornerRadius = 10
        searchBar.searchTextField.delegate = self
        return searchBar
    }()
    
    private lazy var doneButton = ETGradientButton(title: .done, style: .mysticBlue)
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        registerCell()
        showSearchLoading(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
    }

    override func updateViewConstraints() {
        self.view.frame.size.height = UIScreen.main.bounds.height - 15
        self.view.frame.origin.y =  15
        self.view.roundCorners(corners: [.topLeft, .topRight], radius: 25.0)
        super.updateViewConstraints()
    }

    private func setupViews() {
        view.backgroundColor = .systemBackground
        self.hideKeyboardWhenTappedAround() 
        view.addSubviews(titleLabel,
                         searchTextField,
                         tableView,
                         doneButton)
        tableView.delegate = self
        tableView.dataSource = self
        setupConstraintViews() 
        doneButton.addTarget(self, action: #selector(handlerdoneAction), for: .touchUpInside)
    }
    
    private func registerCell() {
        tableView.register(SearchDestinationTableViewCell.self,
                           forCellReuseIdentifier: SearchDestinationTableViewCell.indentifier)
    }
    
    private func setupBinder() {
        searchViewModel.hotelsRelatedAddress.bind { [weak self] (hotels) in
            guard let self = self else { return }
            if let hotels = hotels, !hotels.isEmpty {
                self.hotels = hotels
            }
        }
    }

    private func setupConstraintViews() {
        let padding: CGFloat = 15
        titleLabel.anchor(top: view.topAnchor, 
                          leading: view.leadingAnchor, 
                          trailing: view.trailingAnchor,
                          paddingTop: 50,
                          paddingLeading: padding,
                          paddingTrailing: padding)
        titleLabel.setHeight(height: 30)
        
        searchTextField.anchor(top: titleLabel.bottomAnchor,
                               leading: view.leadingAnchor, 
                               trailing: view.trailingAnchor,
                               paddingTop: padding,
                               paddingLeading: padding,
                               paddingTrailing: padding)
        searchTextField.setHeight(height: 50)
    
        doneButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor,
                          paddingBottom: 100,
                          paddingLeading: 30,
                          paddingTrailing: 30)
        doneButton.setHeight(height: 50)
        
        tableView.anchor(top: searchTextField.bottomAnchor,
                         bottom: doneButton.topAnchor,
                         leading: view.leadingAnchor,
                         trailing: view.trailingAnchor,
                         paddingTop: padding,
                         paddingLeading: padding,
                         paddingTrailing: padding)
    }

    func showSearchLoading(_ shouldShow: Bool) {
        searchTextField.setLeftImage(isLoading: shouldShow)
    }

    private func cancel() {
        dismiss(animated: true)
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchDestinationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchDestinationTableViewCell.indentifier, for: indexPath) as? SearchDestinationTableViewCell else { return SearchDestinationTableViewCell() }
        let hotel = hotels[indexPath.item]
        cell.titleText = hotel.name
        cell.addressText = hotel.address
        cell.typeText = hotel.type
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let hotel = hotels[indexPath.item]
        let nameHotel = hotel.name
        self.currentText = nameHotel
        self.doneHandler?(nameHotel)
        self.hotelInfomation?(hotel)
        cancel()
    }
}

// MARK: - UISearchBarDelegate
extension SearchDestinationViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        hotels.removeAll()
        let query = searchText.lowercased()
        let numberOfText = searchText.count
        currentText = query
        
        if searchText.isEmpty {
            currentText = ""
        }
        
        if numberOfText <= 2 {
            showSearchLoading(false)
        } else {
            searchDatabase(with: query)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }

    private func searchDatabase(with query: String) {
        showSearchLoading(true) 
        // Create delay before performing the search
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.searchViewModel.resultHotelRelatedAddress(query)
            self.showSearchLoading(false)
        })
        setupBinder()
    }
}

// MARK: - UITextFieldDelegate
extension SearchDestinationViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        currentText = ""
        hotels.removeAll()
        showSearchLoading(false)
        return true
    }
}

// MARK: - Handle Action
extension SearchDestinationViewController {
    @objc func handlerdoneAction() {
        self.doneHandler?(currentText)
        self.hotelInfomation?(nil)
        cancel()
    }
}
