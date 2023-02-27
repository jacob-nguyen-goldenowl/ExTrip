//
//  HotelTableViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 04/01/2023.
//

import UIKit
import Cosmos

class HotelTableViewCell: ETTableViewCell {
    
    static let identifier = "HotelTableViewCell"
    
    private lazy var starView: CosmosView = {
        let view = CosmosView()
        view.sizeToFit()
        view.settings.updateOnTouch = false
        view.settings.starSize = 16
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func setupSubView() {
        addSubviews(posterImageView,
                    titleLabel,
                    priceLabel, 
                    addressLabel,
                    roomInfoLabel, 
                    starView,
                    reviewLabel)
        setupConstraintSubView()
    }
    
    private func setupConstraintSubView() {
        let padding: CGFloat = 20
        let paddingLeft: CGFloat = 10
        posterImageView.anchor(top: topAnchor,
                               bottom: bottomAnchor,
                               leading: leadingAnchor,
                               paddingTop: padding,
                               paddingBottom: padding, 
                               paddingLeading: 20)
        posterImageView.setWidth(width: 130)

        titleLabel.anchor(top: posterImageView.topAnchor,
                          leading: posterImageView.trailingAnchor,
                          trailing: trailingAnchor,
                          paddingTop: 5,
                          paddingLeading: paddingLeft,
                          paddingTrailing: 5)
        titleLabel.setHeight(height: 25)
        
        addressLabel.anchor(top: titleLabel.bottomAnchor, 
                            leading: posterImageView.trailingAnchor, 
                            trailing: trailingAnchor,
                            paddingTop: 5,
                            paddingLeading: paddingLeft, 
                            paddingTrailing: padding)
        addressLabel.setHeight(height: 20)
        
        starView.anchor(top: addressLabel.bottomAnchor,
                        leading: posterImageView.trailingAnchor,
                        paddingTop: 5, 
                        paddingLeading: paddingLeft)
        starView.setHeight(height: 15)
        
        reviewLabel.anchor(top: addressLabel.bottomAnchor,
                           leading: starView.trailingAnchor,
                           trailing: trailingAnchor,
                           paddingTop: 6,
                           paddingLeading: paddingLeft,
                           paddingTrailing: padding)
        reviewLabel.setHeight(height: 15)
        reviewLabel.setWidth(width: 120)
        
        priceLabel.anchor(top: starView.bottomAnchor,
                          leading: posterImageView.trailingAnchor,
                          trailing: trailingAnchor,
                          paddingTop: 5,
                          paddingLeading: 10,
                          paddingTrailing: padding)
        priceLabel.setHeight(height: 23)
        
        roomInfoLabel.anchor(top: priceLabel.bottomAnchor, 
                             leading: posterImageView.trailingAnchor,
                             trailing: trailingAnchor, 
                             paddingTop: 5,
                             paddingLeading: 10,
                             paddingTrailing: padding)
        roomInfoLabel.setHeight(height: 18)
    }

    public func cofigureHotel(_ data: HotelModel) {
        posterImageView.loadImage(url: data.thumbnail)
        titleLabel.text = data.name.capitalizeFirstLetter()
        priceLabel.text = "US $\(data.price)"
        reviewLabel.text = "(\(data.review) Reviews)"
        addressLabel.text = "\(data.road.capitalizeFirstLetter()) Road | \(data.kmFromCenter) from center"
        roomInfoLabel.text = "\(data.numberOfRoom) room - 1 night (incl.taxes)"
        starView.rating = data.star
    }
}
