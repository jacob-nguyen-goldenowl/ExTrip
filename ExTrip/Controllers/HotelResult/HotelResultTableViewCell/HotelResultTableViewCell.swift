//
//  HotelResultTableViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 03/02/2023.
//

import UIKit
import Cosmos

class HotelResultTableViewCell: ETTableViewCell {
    
    static let identifier = "HotelResultTableViewCell"
    
    lazy var viewModel = WishListViewModel()
    
    var currentUser: String = ""
    var hotelId: String = "" {
        didSet {
            setupFavorite()
        }
    }
    
    var day: Int = 1
     
    private let padding: CGFloat = 10
    private let paddingSize: CGFloat = 5
    private let buttonSize: CGFloat = 25
    private let commonSize: CGFloat = 15
    
    private let locationImage = UIImage(named: "clock")

    var numberRoomAvailable: Int = 0 {
        didSet {
            setupNeedsUpdateConstraint()
        }
    }
        
    private let boxView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        view.backgroundColor = UIColor.theme.tertiarySystemFill
        view.layer.shadowRadius = 5
        return view
    }()
    
    private lazy var starView: CosmosView = {
        let view = CosmosView()
        view.sizeToFit()
        view.settings.updateOnTouch = false
        view.settings.starSize = 16
        return view
    }()
    
    private lazy var locationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.sizeToFit()
        imageView.contentMode = .scaleAspectFit
        imageView.changeColorImage(image: locationImage, color: primaryColor)
        return imageView
    }()

    lazy var favouriteButton = ETFavoriteButton()
    
    // MARK: - Room info properties
    private lazy var separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.theme.lightGray
        return view
    }()
    
    private lazy var numberRoomLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.theme.white
        label.backgroundColor = UIColor.theme.lightRed
        label.clipsToBounds = true
        label.layer.cornerRadius = 5
        label.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        label.textAlignment = .center
        label.font = .poppins(style: .bold, size: 12)
        return label
    }()

    private lazy var roomInfoView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return view
    }()
    
    private lazy var soldOutImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = locationImage
        imageView.changeColorImage(image: locationImage, color: lightGrayColor)
        return imageView
    }()
    
    public lazy var soldOutLabel: UILabel = {
        let label = UILabel()
        label.textColor = lightGrayColor
        label.font = .poppins(style: .medium, size: 12)
        label.text = "We're sold out!"
        return label
    }()
    
    private lazy var soldOutTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = lightGrayColor
        label.font = .poppins(style: .medium, size: 11)
        label.text = "Sold out at"
        return label
    }()
        
    // MARK: - INIT
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubViews()
        setupFavorite()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubViews() {
        currentUser = AuthManager.shared.getCurrentUserID()
        contentView.addSubview(boxView)
        boxView.addSubviews(posterImageView,
                            titleLabel,
                            locationImageView,
                            addressLabel,
                            roomInfoLabel,
                            starView,
                            reviewLabel,
                            ratingLabel,
                            favouriteButton, 
                            roomInfoView)
        
        priceLabel.textColor = .red
        setupConstraintSubViews()
    }
    
    // MARK: - Constraints
    private func setupConstraintSubViews() {
        boxView.fillAnchor(contentView, padding: padding) 
        
        posterImageView.anchor(top: boxView.topAnchor,
                               leading: boxView.leadingAnchor,
                               trailing: boxView.trailingAnchor)
        posterImageView.layer.cornerRadius = 5
        posterImageView.setHeight(height: 150)
        
        favouriteButton.anchor(top: posterImageView.bottomAnchor,
                               trailing: boxView.trailingAnchor,
                               paddingTop: paddingSize, 
                               paddingTrailing: paddingSize)
        favouriteButton.setWidth(width: buttonSize)
        favouriteButton.setHeight(height: buttonSize)
        
        titleLabel.anchor(top: posterImageView.bottomAnchor,
                          leading: boxView.leadingAnchor,
                          trailing: favouriteButton.leadingAnchor,
                          paddingTop: paddingSize,
                          paddingLeading: paddingSize,
                          paddingTrailing: paddingSize)
        
        starView.anchor(top: titleLabel.bottomAnchor,
                        leading: boxView.leadingAnchor, 
                        paddingTop: paddingSize,
                        paddingLeading: paddingSize)
        starView.setHeight(height: commonSize)
        starView.setWidth(width: 100)
        
        ratingLabel.anchor(top: titleLabel.bottomAnchor,
                           leading: starView.trailingAnchor,
                           paddingTop: paddingSize,
                           paddingLeading: paddingSize)
        ratingLabel.setHeight(height: commonSize)

        reviewLabel.anchor(top: titleLabel.bottomAnchor,
                           leading: ratingLabel.trailingAnchor, 
                           paddingTop: paddingSize, 
                           paddingLeading: paddingSize)
        reviewLabel.setHeight(height: commonSize)
        
        locationImageView.anchor(leading: boxView.leadingAnchor,
                                 paddingLeading: paddingSize)
        locationImageView.center(centerY: addressLabel.centerYAnchor)
        locationImageView.setWidth(width: commonSize)
        locationImageView.setHeight(height: commonSize)
        
        addressLabel.anchor(top: starView.bottomAnchor, 
                            leading: locationImageView.trailingAnchor,
                            trailing: boxView.trailingAnchor,
                            paddingTop: paddingSize,
                            paddingLeading: paddingSize,
                            paddingTrailing: paddingSize)
        
        roomInfoView.anchor(top: addressLabel.bottomAnchor,
                            bottom: boxView.bottomAnchor,
                            leading: boxView.leadingAnchor,
                            trailing: boxView.trailingAnchor,
                            paddingTop: paddingSize)
    }
    
    private func setupNeedsUpdateConstraint() {
        if numberRoomAvailable != 0 {
            roomInfoView.backgroundColor = .clear
            roomInfoView.addSubviews(priceLabel,
                                     numberRoomLabel,
                                     separatorLine,
                                     defaultPriceLabel)
            
            removeAllFromSubView([soldOutLabel,
                                  soldOutImageView, 
                                  soldOutTitleLabel, 
                                  soldOutPriceLabel])

            numberRoomLabel.anchor(top: roomInfoView.topAnchor,
                                   trailing: roomInfoView.trailingAnchor)
            numberRoomLabel.setHeight(height: 20)
            numberRoomLabel.setWidth(width: 100)
            
            separatorLine.anchor(leading: roomInfoView.leadingAnchor,
                                 trailing: numberRoomLabel.leadingAnchor)
            separatorLine.setHeight(height: 0.5)
            separatorLine.center(centerY: numberRoomLabel.centerYAnchor)
            
            priceLabel.anchor(top: numberRoomLabel.bottomAnchor,
                              bottom: roomInfoView.bottomAnchor,
                              trailing: roomInfoView.trailingAnchor,
                              paddingTop: paddingSize,
                              paddingBottom: paddingSize,
                              paddingTrailing: padding)
            
            defaultPriceLabel.anchor(top: priceLabel.topAnchor,
                                     bottom: priceLabel.bottomAnchor, 
                                     trailing: priceLabel.leadingAnchor,
                                     paddingTrailing: padding) 
        } else {
            roomInfoView.addSubviews(soldOutImageView, 
                                     soldOutLabel,
                                     soldOutPriceLabel,
                                     soldOutTitleLabel)
            
            removeAllFromSubView([priceLabel,
                                  numberRoomLabel,
                                  separatorLine,
                                  defaultPriceLabel])
            
            roomInfoView.backgroundColor = UIColor.theme.lightGray?.withAlphaComponent(0.2)
            
            soldOutImageView.anchor(top: roomInfoView.topAnchor,
                                    bottom: roomInfoView.bottomAnchor, 
                                    leading: roomInfoView.leadingAnchor,
                                    paddingTop: paddingSize,
                                    paddingBottom: paddingSize,
                                    paddingLeading: paddingSize)
            soldOutImageView.setHeight(height: 30)
            soldOutImageView.setWidth(width: 30)
            
            soldOutLabel.anchor(leading: soldOutImageView.trailingAnchor,
                                paddingLeading: paddingSize)
            soldOutLabel.center(centerY: soldOutImageView.centerYAnchor)
            
            soldOutTitleLabel.anchor(top: roomInfoView.topAnchor,
                                     leading: soldOutLabel.trailingAnchor,
                                     trailing: roomInfoView.trailingAnchor,
                                     paddingTop: paddingSize,
                                     paddingLeading: paddingSize,
                                     paddingTrailing: padding)
            
            soldOutPriceLabel.anchor(top: soldOutTitleLabel.bottomAnchor,
                                     trailing: roomInfoView.trailingAnchor, 
                                     paddingTrailing: paddingSize)
            soldOutPriceLabel.center(centerX: soldOutTitleLabel.centerXAnchor)
        }
    }
    
    // MARK: - Get data
    func setupDataInfoHotelBooking(hotel: HotelModel) {
        posterImageView.loadImage(url: hotel.thumbnail)
        titleLabel.text = hotel.name.capitalizeFirstLetter()
        starView.rating = hotel.star
        ratingLabel.text = calculatorScoreService(hotel.rating)
        reviewLabel.text = calculatorReview(hotel.review)
        addressLabel.text = hotel.address.capitalizeFirstLetter()
        soldOutPriceLabel.text = "$ \(hotel.price)"
        favouriteButton.isChecked = hotel.like
    }
    
    func setupFavorite() {
        let wishlist = WishListModel(hotelID: hotelId, userID: currentUser)
        favouriteButton.likedClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.viewModel.addWishtlist(with: wishlist)
            }
        } 
        
        favouriteButton.dislikeClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.viewModel.removeFromWishlist(with: self?.hotelId ?? "")
            }
        }
    }
    
    func setupDataInfoRoomBooking(room roomLeft: Int,
                                  defaultPrice: Double,
                                  price currentPrice: Double) {
        numberRoomLabel.text = "only \(roomLeft) left".uppercased()
        let price = currentPrice * Double(day)
        let roundedPrice = String(format: "%.2f", price)
        let oldPrice = defaultPrice * Double(day)
        let roundedOldPrice = String(format: "%.2f", oldPrice)
        priceLabel.text = "$ \(roundedPrice)"
        defaultPriceLabel.setStrikeThroughText("$ \(roundedOldPrice)")
    }
    
    private func calculatorScoreService(_ score: Double) -> String {
        if score >= 4.5 {
            return "\(score) Exceptional"
        } else if score >= 4.0 && score <= 4.4 {
            return "\(score) Excellent"
        } else if score >= 3.0 && score <= 3.9 {
            return "\(score) Very good"
        } else if score >= 2.5 && score <= 2.9 {
            return "\(score) Good"
        } else {
            return "\(score) Bad"
        }
    }
    
    private func calculatorReview(_ review: Int) -> String {
        if review <= 1 {
            return "\(review) review"
        } else {
            return "\(review) verified reviews"
        }
    }
    
}
