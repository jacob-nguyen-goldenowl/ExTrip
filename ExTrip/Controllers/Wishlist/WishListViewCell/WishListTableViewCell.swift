//
//  WishListTableViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 03/03/2023.
//

import UIKit
import Cosmos

class WishListTableViewCell: UITableViewCell {

    static let identifier = "WishListTableViewCell"
    
    let padding: CGFloat = 10
    
    private lazy var hotelImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.sizeToFit()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
        
    private lazy var hotelTitleLabel = ETLabel(style: .large, textAlignment: .left, numberOfLines: 2)
    
    private lazy var starView: CosmosView = {
        let view = CosmosView()
        view.sizeToFit()
        view.settings.updateOnTouch = false
        view.settings.starSize = 12
        return view
    }()
    
    private lazy var scoreRatingLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 5
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner]
        label.backgroundColor = .blue
        label.textColor = .white
        return label
    }()
    
    private lazy var reviewLabel = ETLabel(style: .small, textAlignment: .left)

    // MARK: - INIT
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubViews() {
        addSubviews(hotelImageView,
                    hotelTitleLabel,
                    starView,
                    scoreRatingLabel, 
                    reviewLabel)
        setupConstraintSubViews()
    }
    
    // MARK: - Constraints
    private func setupConstraintSubViews() {
        hotelImageView.anchor(top: topAnchor,
                              bottom: bottomAnchor,
                              leading: leadingAnchor, 
                              paddingTop: padding,
                              paddingBottom: padding,
                              paddingLeading: padding)
        hotelImageView.setWidth(width: 100)
        
        hotelTitleLabel.anchor(top: hotelImageView.topAnchor,
                               leading: hotelImageView.trailingAnchor,
                               trailing: trailingAnchor, 
                               paddingTop: padding,
                               paddingLeading: padding,
                               paddingTrailing: padding)
        
        starView.anchor(top: hotelTitleLabel.bottomAnchor,
                        leading: hotelImageView.trailingAnchor,
                        trailing: trailingAnchor, 
                        paddingTop: 5,
                        paddingLeading: padding,
                        paddingTrailing: padding)
        
        scoreRatingLabel.anchor(top: starView.bottomAnchor, 
                                leading: hotelImageView.trailingAnchor,
                                paddingTop: 5,
                                paddingLeading: padding)
        scoreRatingLabel.setWidth(width: 40)
        
        reviewLabel.anchor(top: scoreRatingLabel.topAnchor,
                           bottom: scoreRatingLabel.bottomAnchor,
                           leading: scoreRatingLabel.trailingAnchor,
                           trailing: trailingAnchor, 
                           paddingLeading: padding,
                           paddingTrailing: padding)
    }
    
    func setupDataWishList(hotel: HotelModel) {
        hotelTitleLabel.text = hotel.name.capitalizeFirstLetter()
        scoreRatingLabel.setSuperScripts(bigText: "\(hotel.star)", smallText: "/5")
        let showReview = stringNumberOfReview(hotel.review)
        reviewLabel.text = "\(hotel.review) \(showReview)"
        hotelImageView.loadImage(url: hotel.thumbnail)
    }

    private func stringNumberOfReview(_ number: Int) -> String {
        if number <= 1 {
            return "review"
        } else {
            return "reviews"
        }
    }

}
