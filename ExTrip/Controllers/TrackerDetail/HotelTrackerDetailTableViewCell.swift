//
//  HotelTrackerDetailTableViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 21/03/2023.
//

import UIKit
import Cosmos

class HotelTrackerDetailTableViewCell: UITableViewCell {

    static let identifier = "HotelTrackerDetailTableViewCell"
    
    let padding: CGFloat = 10
    let paddingTop: CGFloat = 5
    let paddingSize: CGFloat = 10
    
    lazy var posterImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var titleLabel = ETLabel(style: .large, textAlignment: .left)
    lazy var cityLabel = ETLabel(style: .medium, textAlignment: .left, size: 13)
    lazy var refuldLabel = ETLabel(style: .medium, textAlignment: .left)
    
    private lazy var starView: CosmosView = {
        let view = CosmosView()
        view.sizeToFit()
        view.settings.updateOnTouch = false
        view.settings.starSize = 15
        return view
    }()
        
    // MARK: - INIT
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubViews() {
        addSubviews(posterImageView,
                    titleLabel, 
                    cityLabel, 
                    starView,
                    refuldLabel)
        setupConstraintSubViews()   
    }
    
        // MARK: - Constraints
    private func setupConstraintSubViews() {
        let imageSize: CGSize = CGSize(width: 100, height: 120)
        posterImageView.anchor(top: topAnchor, 
                               bottom: bottomAnchor,
                               leading: leadingAnchor)
        posterImageView.setWidth(width: imageSize.width)
        posterImageView.setHeight(height: imageSize.height)
        
        titleLabel.anchor(top: topAnchor, 
                          leading: posterImageView.trailingAnchor, 
                          trailing: trailingAnchor,
                          paddingTop: padding,
                          paddingLeading: padding,
                          paddingTrailing: paddingSize)
    
        cityLabel.anchor(top: titleLabel.bottomAnchor,
                         leading: posterImageView.trailingAnchor, 
                         trailing: trailingAnchor,
                         paddingTop: paddingTop,
                         paddingLeading: padding,
                         paddingTrailing: paddingSize)
        
        starView.anchor(top: cityLabel.bottomAnchor, 
                        leading: posterImageView.trailingAnchor, 
                        trailing: trailingAnchor,
                        paddingTop: paddingTop,
                        paddingLeading: padding,
                        paddingTrailing: paddingSize)   
        
        refuldLabel.anchor(top: starView.bottomAnchor,
                           leading: posterImageView.trailingAnchor, 
                           trailing: trailingAnchor,
                           paddingTop: paddingTop,
                           paddingLeading: padding, 
                           paddingTrailing: paddingSize)
    }
    
    func setDataForHotelTracker(_ hotel: HotelModel) {
        posterImageView.loadImage(url: hotel.thumbnail)
        titleLabel.text = hotel.name.capitalizeFirstLetter()
        cityLabel.text = "\(hotel.road.capitalizingFirstLetter()) Road|\(hotel.kmFromCenter)km from center" 
        starView.rating = hotel.star
        refuldLabel.text = "Non-refulable"
    }
    
}
