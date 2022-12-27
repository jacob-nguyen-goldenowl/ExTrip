//
//  HomeViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 12/12/2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    var photos = Photo.allPhotos()

    private var numberOfColumns = 2
    private var cellPadding: CGFloat = 10
    
    private let homeViewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeViewModel.welcomTitle()
        setupTitleBinder()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupNavigationBar()
    }
    
    private func setupTitleBinder() {
        homeViewModel.welcomeMessage.bind {[weak self] message in
            if let message = message {
                self?.setupLeftAlignTitleView(text: message)
            }
        }
    }
    
    private func setupLeftAlignTitleView(text: String) {
        guard let frame = navigationController?.navigationBar.frame else{
            return
        }
        
        let parentView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: frame.width*3,
                                              height: frame.height))
        self.navigationItem.titleView = parentView
        
        let label = UILabel(frame: .init(x: parentView.frame.minX,
                                         y: parentView.frame.minY,
                                         width: parentView.frame.width,
                                         height: parentView.frame.height))
        label.backgroundColor = .clear
        label.numberOfLines = 2
        label.font = .poppins(style: .bold, size: 30)
        label.textAlignment = .left
        label.textColor = .black
        label.text = text
        
        parentView.addSubview(label)
    }
    
    private func setupNavigationBar() {
        let search = UIBarButtonItem(image: UIImage(named: "search"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(handleSearchAction))
        search.tintColor = .black
        self.navigationItem.rightBarButtonItem  = search
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        collection.register(HomeCollectionViewCell.self,
                            forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        collection.register(CategoryCollectionReusableView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: CategoryCollectionReusableView.identifier)
        return collection
    }()
    
    // MARK: - Setup UI
    private func setupViews() {
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
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { 
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
            cell.photo = photos[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columnWidth = (collectionView.frame.size.width / CGFloat(numberOfColumns)) - cellPadding * 1.5
        return CGSize(width: columnWidth, height: 270)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = photos[indexPath.row]
        let vc = DestinationViewController(data: photos,
                                           scoreDestination: item.rating,
                                           titleDestination: item.country,
                                           imageDestination: item.image)
        vc.titleHeader = item.country
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
        guard let category = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,withReuseIdentifier: CategoryCollectionReusableView.identifier, for: indexPath) as? CategoryCollectionReusableView else { return UICollectionReusableView() }
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
    }
}

// MARK: - CategoryCollectionReusableViewDelegate
extension HomeViewController: CategoryCollectionReusableViewDelegate {
    func categoryCollectionReusableViewhandleHotelBooking() {
        let vc  = HotelBookingViewController()
        navigationAction(vc)
    }
    
    func categoryCollectionReusableViewhandleFilghtBooking() {
        // Code here ...
    }
    
    func categoryCollectionReusableViewhandleEvent() {
        // Core here ...
    }
    
    private func navigationAction(_ viewController: UIViewController) {
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}
