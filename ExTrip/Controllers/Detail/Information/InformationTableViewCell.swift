//
//  InformationTableViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 10/01/2023.
//

import UIKit

struct InformationModel {
    let icon: UIImage?
    let title: String
}

class InformationTableViewCell: DetailTableViewCell {

    static let identifier = "InformationTableViewCell"
    
    private var model: [InformationModel] = []
        
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubView()
        registerCell()
        mockData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubView() {
        addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        setupConstraintSubView()
    }
    
    private func setupConstraintSubView() {
        collectionView.anchor(top: headerTitle.bottomAnchor, 
                              bottom: bottomAnchor,
                              leading: leadingAnchor, 
                              trailing: trailingAnchor, 
                              paddingTop: padding,
                              paddingBottom: padding,
                              paddingLeading: padding,
                              paddingTrailing: padding)
    }
    
    private func registerCell() {
        collectionView.register(InfomationCollectionViewCell.self,
                                forCellWithReuseIdentifier: InfomationCollectionViewCell.identifier)
    }
    
    private func mockData() {
        model = [InformationModel(icon: UIImage(named: "cup"), title: "Breakfast"),
                 InformationModel(icon: UIImage(named: "cup"), title: "Paking"),
                 InformationModel(icon: UIImage(named: "knife"), title: "Dining"),
                 InformationModel(icon: UIImage(named: "wifi"), title: "Free Wifi"),
                 InformationModel(icon: UIImage(named: "pet"), title: "Pets"),
                 InformationModel(icon: UIImage(named: "wifi"), title: "Wifi")]
    }
    
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource
extension InformationTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InfomationCollectionViewCell.identifier,
                                                            for: indexPath) as? InfomationCollectionViewCell else { return InfomationCollectionViewCell() }
        let item = model[indexPath.row]
        cell.setDataForInformation(item)
        return cell 
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true) 
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension InformationTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.size.width - padding
        let itemWidth: CGFloat = width / 3.0
        return CGSize(width: itemWidth, height: itemWidth/2)
    }
    
}
