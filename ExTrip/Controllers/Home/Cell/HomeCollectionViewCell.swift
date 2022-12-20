//
//  DestinationCollectionViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 15/12/2022.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "HomeCollectionViewCell"
    
    // MARK: - Properties
    private let containerView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 20
        return view 
    }()
    
    private lazy var imageCategory: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var namecountryLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(style: .bold,size: 17)
        label.textColor = UIColor.theme.white ?? .white
        return label
    }()
    
    private let ratingView = RattingView(type: .gray)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupSubViews() {
        addSubview(containerView)
        containerView.addSubviews(imageCategory,
                                  namecountryLabel,
                                  ratingView)
        setupConstraintSubViews()
    }
    
    private func setupConstraintSubViews() {
        let padding: CGFloat = 15
        
        containerView.fillAnchor(self)
        
        imageCategory.fillAnchor(containerView)
        
        ratingView.anchor(bottom: containerView.bottomAnchor, 
                          leading: containerView.leadingAnchor, 
                          paddingBottom: padding,
                          paddingLeading: padding)
        ratingView.setWidth(width: 65)
        ratingView.setHeight(height: 30)
        
        namecountryLabel.anchor(bottom: ratingView.topAnchor,
                                leading: containerView.leadingAnchor,
                                paddingBottom: 5,
                                paddingLeading: padding)
    }
    
    var photo: Photo? {
        didSet {
            if let photo = photo {
                imageCategory.image = photo.image
                ratingView.score = photo.rating
                namecountryLabel.text = photo.country.uppercased()
            }
        }
    }

}

