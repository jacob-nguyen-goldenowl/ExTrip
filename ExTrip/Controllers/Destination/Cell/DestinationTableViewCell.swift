//
//  DestinationTableViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 20/12/2022.
//

import UIKit

class DestinationTableViewCell: UITableViewCell {
    
    static let identifier = "DestinationTableViewCell"
    
    private var numberOfColumns = 2
    private var cellPadding: CGFloat = 10
    private let dataDestination = Photo.allPhotos()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout )
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(DestinationCollectionViewCell.self, forCellWithReuseIdentifier: DestinationCollectionViewCell.identifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Setup UI
    private func setupSubView() {
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.fillAnchor(self)
    }
    
}

// MARK: -  UICollectionViewDelegate, UICollectionViewDataSource
extension DestinationTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DestinationCollectionViewCell.identifier, for: indexPath) as? DestinationCollectionViewCell else { return UICollectionViewCell()
        }
        // code here ....
        let item = dataDestination[indexPath.item]
        cell.getDataItem(item)
        return cell 
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)        
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DestinationTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columnWidth = (collectionView.frame.size.width / CGFloat(numberOfColumns)) - cellPadding * 1.5
        return CGSize(width: columnWidth, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0,
                            left: cellPadding,
                            bottom: 0,
                            right: cellPadding)
    }
}
