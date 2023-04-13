//
//  HomeViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 12/12/2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var numberOfColumns = 2
    private var cellPadding: CGFloat = 10
    
    private let homeViewModel = HomeViewModel()
    
    var destinations: [DestinationModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private lazy var searchBar: ETSearchBar = {
        let searchBar = ETSearchBar()
        searchBar.delegate = self 
        searchBar.setLeftImage(isLoading: false)
        return searchBar
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        return collection
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        homeViewModel.fetchData()
        setupDataBinder()
        setupViews()
        registerCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar(UIColor.theme.primary)

    }
    
    // MARK: - Register cell
    private func registerCell() {
        collectionView.register(HomeCollectionViewCell.self,
                                forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        collectionView.register(CategoryCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CategoryCollectionReusableView.identifier)
    }

    private func setupDataBinder() {
        homeViewModel.destination.bind { [weak self] data in
            if let data = data {
                self?.destinations = data
            } else {
                print("error when get data")
            }
        }
    }
    
    // MARK: - Setup navigation bar
    private func setupNavigationBar(_ color: UIColor?) {
        guard let navigationBar = navigationController?.navigationBar else { return }
        let notification = UIBarButtonItem(image: UIImage(systemName: "bell"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(handleSearchAction))
        notification.tintColor = .white
        self.navigationItem.rightBarButtonItem  = notification
        navigationItem.titleView = searchBar
        navigationBar.barTintColor = color
    }
    
    // MARK: - Setup UI
    private func setupViews() {
        view.backgroundColor = UIColor.theme.primary
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              bottom: view.bottomAnchor,
                              leading: view.leadingAnchor, 
                              trailing: view.trailingAnchor)
    }
    
}
// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return destinations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { 
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
        let item = destinations[indexPath.item]
        cell.setDataOfHome(item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columnWidth = (collectionView.frame.size.width / CGFloat(numberOfColumns)) - cellPadding * 1.5
        return CGSize(width: columnWidth, height: 270)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = destinations[indexPath.row]
        let vc = DestinationViewController(destinationID: item.id,
                                           scoreDestination: item.rating,
                                           titleDestination: item.country,
                                           imageDestination: item.image)
        vc.hotelViewModel.titleHeader = item.country
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: cellPadding,
                            left: cellPadding,
                            bottom: cellPadding,
                            right: cellPadding)
    }
    
    // MARK: - Setup header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let category = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CategoryCollectionReusableView.identifier,
            for: indexPath) as? CategoryCollectionReusableView else {
            return UICollectionReusableView()
        }
        category.delegate  = self
        return category
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width, height: 230)
    }
}

// MARK: - Action button
extension HomeViewController {
    @objc func handleSearchAction() {
        self.showPopUpAlert()
    }
}

// MARK: - CategoryCollectionReusableViewDelegate
extension HomeViewController: CategoryCollectionReusableViewDelegate {
    func categoryCollectionReusableViewhandleHotelBooking() {
        let vc  = HotelBookingViewController()
        navigationAction(vc)
    }
    
    func categoryCollectionReusableViewhandleFilghtBooking() {
        self.showPopUpAlert()
    }
    
    func categoryCollectionReusableViewhandleEvent() {
        self.showPopUpAlert()
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let vc = SearchViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: false)
        return false
    }
}
