//
//  HeaderCollectionViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 10/01/2023.
//

import UIKit

class HeaderCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "HeaderCollectionViewCell"

    var checkIsHiden: Bool = true {
        didSet {
            
        }
    }
    
    private let headerView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemRed
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
        addSubviews(headerView)
        setupConstraintSubView()
    }
    
    private func setupConstraintSubView() {
        headerView.fillAnchor(self)
    }
    
}
