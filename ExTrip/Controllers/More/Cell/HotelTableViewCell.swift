//
//  HotelTableViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 04/01/2023.
//

import UIKit

class HotelTableViewCell: ETTableViewCell {
    
    static let identifier = "HotelTableViewCell"
    
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
                    starHorizontalStack,
                    reviewLabel)
        
        starHorizontalStack.addArrangedSubviews(start1,
                                                start2,
                                                start3,
                                                start4,
                                                start5)
        setupConstraintSubView()
    }
    
    private func setupConstraintSubView() {
        let padding: CGFloat = 30
        let paddingLeft: CGFloat = 5
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
                          paddingLeading: 10,
                          paddingTrailing: paddingLeft)
        titleLabel.setHeight(height: 25)
        
        addressLabel.anchor(top: titleLabel.bottomAnchor, 
                            leading: posterImageView.trailingAnchor, 
                            trailing: trailingAnchor,
                            paddingTop: 5,
                            paddingLeading: 10, 
                            paddingTrailing: padding)
        addressLabel.setHeight(height: 20)
        
        starHorizontalStack.anchor(top: addressLabel.bottomAnchor,
                                   leading: posterImageView.trailingAnchor,
                                   paddingTop: 5, 
                                   paddingLeading: 10)
        starHorizontalStack.setHeight(height: 15)
        
        reviewLabel.anchor(top: addressLabel.bottomAnchor,
                           leading: starHorizontalStack.trailingAnchor,
                           trailing: trailingAnchor,
                           paddingTop: 5,
                           paddingLeading: 5,
                           paddingTrailing: padding)
        reviewLabel.setHeight(height: 15)
        reviewLabel.setWidth(width: 100)
        
        priceLabel.anchor(top: starHorizontalStack.bottomAnchor,
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

    private func setupStartView(_ color: UIColor? = UIColor.theme.yellow) -> UIImageView {
        let imageView = UIImageView()
        let image = UIImage(named: "star")
        imageView.image = image
        imageView.tintColor = color ?? .yellow
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }  
    
    public func cofigureHotel(_ data: HotelModel) {
        posterImageView.loadImage(url: data.image[0])
        titleLabel.text = data.name
        priceLabel.text = "US $\(data.price)"
        reviewLabel.text = "(\(data.review) Reviews)"
        roomInfoLabel.text = "\(data.numberOfRoom) room - 1 night (incl.taxes)"
    }
}


