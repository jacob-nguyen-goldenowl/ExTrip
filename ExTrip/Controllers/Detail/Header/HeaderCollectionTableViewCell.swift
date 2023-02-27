//
//  HeaderCollectionTableViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 10/01/2023.
//

import UIKit

protocol HeaderCollectionTableViewCellDelegate: AnyObject {
    func headerCollectionTableViewCellHandleViewAllImage(_ allImage: [String])
}

class HeaderCollectionTableViewCell: UITableViewCell {
    
    static let identifier = "HeaderCollectionTableViewCell"
    
    weak var delegate: HeaderCollectionTableViewCellDelegate?
    
    var listImage: [String] = []

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 3
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubView() {
        backgroundColor = .clear
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HeaderCollectionViewCell.self,
                                forCellWithReuseIdentifier: HeaderCollectionViewCell.identifier)
        setupConstraintSubView()
    }
    
    private func setupConstraintSubView() {
        collectionView.fillAnchor(contentView)
    }
    
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension HeaderCollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderCollectionViewCell.identifier, 
                                                            for: indexPath) as? HeaderCollectionViewCell else { return HeaderCollectionViewCell() }
        let index = indexPath.item
        let item = listImage[index]
        cell.setImageForHeader(item)
        return cell 
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true) 
        delegate?.headerCollectionTableViewCellHandleViewAllImage(listImage)
    }
}

    // MARK: - UICollectionViewDelegateFlowLayout
extension HeaderCollectionTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = indexPath.item
        let width = collectionView.bounds.size.width
        let padding: CGFloat = 3
        if item < 2 {
            let itemWidth: CGFloat = (width - padding) / 2.0
            return CGSize(width: itemWidth, height: itemWidth)
        } else {
            let itemWidth: CGFloat = (width - 2 * padding) / 3.0
            return CGSize(width: itemWidth, height: itemWidth / 2.0)
        }
    }
    
}
