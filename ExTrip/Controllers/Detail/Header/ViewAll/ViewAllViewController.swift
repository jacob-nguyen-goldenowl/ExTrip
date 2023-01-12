//
//  ViewAllViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 12/01/2023.
//

import UIKit

class ViewAllViewController: UIViewController {
    
    private var linkURLAllImage: [String] = []
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.isPagingEnabled = true
        collection.showsHorizontalScrollIndicator = false
        collection.bounces = false
        collection.backgroundColor = UIColor.theme.serenade
        return collection
    }()
    
    init(allImage: [String]) {
        self.linkURLAllImage = allImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigation()
    }
    
    private func setupNavigation() {
        navigationController?.configBackButton()
        title = "All Images"
    }
    
    private func setupViews() {
        view.insertSubview(collectionView, at: 0)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ViewAllCollectionViewCell.self, 
                                forCellWithReuseIdentifier: ViewAllCollectionViewCell.identifier)
        
        setupConstraintViews()
    }
    
    private func setupConstraintViews() {
        collectionView.fillAnchor(view)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ViewAllViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return linkURLAllImage.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewAllCollectionViewCell.identifier, for: indexPath) as? ViewAllCollectionViewCell else { return ViewAllCollectionViewCell() }
        cell.image = linkURLAllImage[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.size.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}

