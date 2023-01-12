//
//  ViewAllCollectionViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 12/01/2023.
//

import UIKit

class ViewAllCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ViewAllCollectionViewCell"
    
    var image: String? {
        didSet {
            if let image = image {
                if image.isEmpty {
                    noReceiveData()
                } else {
                    hotelImageView.loadImage(url: image)
                }
            } else {
                noReceiveData()
            }
        }
    }
    
    private let hotelImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubView() {
        addSubviews(hotelImageView)
        setupConstraintSubView()
    }
    
    private func setupConstraintSubView() {
        hotelImageView.anchor(top: topAnchor,
                              bottom: bottomAnchor,
                              leading: leadingAnchor, 
                              trailing: trailingAnchor)
    }
    
    private func noReceiveData() {
    }
    
}
