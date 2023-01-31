//
//  SearchViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 12/01/2023.
//

import UIKit

enum SearchType: Int {
    case recent = 0
    case suggest = 1
    
    var titleHeader: String {
        switch self {
            case .recent:
                return "your current searches"
            case .suggest:
                return "suggestion for you"
        }
    }
}

class SearchViewController: UIViewController {
    
    // ViewModel
    private let searchViewModel = SearchViewModel()
    private let hotelViewModel = HotelViewModel()
    
    private var currentResultText: String = ""  {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var data: [HotelModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private lazy var searchBar: ETSearchBar = {
        let searchBar = ETSearchBar()
        searchBar.delegate = self
        searchBar.allowShowCancel = true
        searchBar.searchTextField.delegate = self
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = .systemBackground
        table.separatorStyle = .none
        return table
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
        registerCell()
        showSearchBarLoading(false)
    }

    private func setupViews() {
        view.backgroundColor = UIColor.theme.primary
        
        view.addSubviews(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.becomeFirstResponder()
        hideKeyboardWhenTappedAround()
        
        setupConstraintViews() 
    }
    
    private func setupBinder() {
        searchViewModel.hotelsRelated.bind { [weak self] result in
            guard let self = self else { return }
            if let data = result {
                self.data = data
            }
        }
    }

    private func setupConstraintViews() {
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, 
                               bottom: view.bottomAnchor,
                               leading: view.leadingAnchor,
                               trailing: view.trailingAnchor)
    }
    
    private func registerCell() {
        tableView.register(SearchTableViewCell.self,
                           forCellReuseIdentifier: SearchTableViewCell.identifier)
        tableView.register(HotelsRelatedTableViewCell.self,
                           forCellReuseIdentifier: HotelsRelatedTableViewCell.identifier)
    }
    
    private func setupNavigationBar() {
        navigationController?.configBackButton()
        navigationItem.titleView = searchBar
        
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.barTintColor = UIColor.theme.primary
    }

    @objc override func dismissKeyboard() {
        searchBar.endEditing(true)
    }
    
    func showSearchBarLoading(_ shouldShow: Bool) {
        searchBar.setLeftImage(isLoading: shouldShow)
    }
    
    func dismissViewControler() {
        dismiss(animated: false)
    }
    
    private func searchQueryDatabase() {
        DatabaseRequest.shared.searchByDestination(query: currentResultText) { destination in
            if let item = destination.first {
                let vc = DestinationViewController(destinationID: item.id,
                                                   scoreDestination: item.rating,
                                                   titleDestination: item.country,
                                                   imageDestination: item.image)
                self.navigationController?.pushViewController(vc, animated: true) 
            } else {
                let vc = ErrorSearchViewController()
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }
    
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        showSearchBarLoading(false)
        dismissViewControler()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchText.lowercased()
        let numberOfText = searchText.count
        if numberOfText == 0 {
            showSearchBarLoading(false)
        }
        if numberOfText < 2 {
            print("Text must large than two")
        } else {
            let query = text
            searchDatabase(with: query)
        }
        self.currentResultText = text
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchQueryDatabase()
        searchBar.endEditing(true)
    }
    
    private func searchDatabase(with query: String) {
        showSearchBarLoading(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.searchViewModel.resultHotelByRelatedKeyWord(query)
            self.showSearchBarLoading(false)
            self.setupBinder()
        }
    }
    
}

// MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        showSearchBarLoading(false)
        data.removeAll()
        return true
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if currentResultText.isEmpty {
            return 0
        }
        return data.count > 0 ? 2 : 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tableSection = SearchType(rawValue: section) {
            switch tableSection {
                case .recent:
                    return 1
                case .suggest: 
                    return data.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let tableSection = SearchType(rawValue: indexPath.section) {
            switch tableSection {
                case .recent:
                    guard let searchCell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else { return SearchTableViewCell() }
                    searchCell.resultText = currentResultText
                    return searchCell
                case .suggest:
                    guard let hotelsCell = tableView.dequeueReusableCell(withIdentifier: HotelsRelatedTableViewCell.identifier, for: indexPath) as? HotelsRelatedTableViewCell else { return HotelsRelatedTableViewCell() }
                    let hotelData = data[indexPath.item]
                    let image = hotelData.thumbnail
                    let name = hotelData.name
                    hotelsCell.setDataOfHotel(text: name,
                                              query: currentResultText,
                                              image: image)     
                    return hotelsCell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0.0
        if let tableSection = SearchType(rawValue: indexPath.section) {
            switch tableSection {
                case .recent:
                    height = 50.0
                case .suggest: 
                    if data.count > 0 {
                        height = 55.0
                    } else {
                        height = 0.0
                    }
            }
        }
        return height
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = indexPath.item
        if let tableSection = SearchType(rawValue: indexPath.section) {
            switch tableSection {
                case .recent:
                    searchQueryDatabase()
                case .suggest:
                    let hotelData = data[item]
                    let vc = DetailViewController(data: hotelData)
                    navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 25, 
                                          y: 0,
                                          width: tableView.frame.width,
                                          height: 25))
        label.font = .poppins(style: .bold, size: 11)
        label.textColor = UIColor.theme.lightGray ?? .lightGray
        if let tableSection = SearchType(rawValue: section) {
            label.text = tableSection.titleHeader.uppercased()
        }
        
        let headerView = UIView()
        headerView.addSubview(label)
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
}
