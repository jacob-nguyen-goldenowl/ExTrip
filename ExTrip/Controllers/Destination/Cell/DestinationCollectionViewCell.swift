//
//  DestinationCollectionViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 20/12/2022.
//

import UIKit

class DestinationCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "DestinationCollectionViewCell"
    
    private var cellPadding: CGFloat = 10

    lazy var viewModel = WishListViewModel()
    
    var currentUser: String = ""
    var hotelId: String = "" {
        didSet {
            setupFavorite()
        }
    }
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.theme.tertiarySystemFill
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let posterImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    lazy var favouriteButton = ETFavoriteButton()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.theme.black ?? .black
        label.numberOfLines = 2
        label.font = .poppins(style: .bold, size: 13)
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.theme.black ?? .black
        label.font = .poppins(style: .regular)
        return label
    }()
    
    private let ratingView = RattingView(type: .yellow)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
        setupFavorite()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubViews() {
        currentUser = AuthManager.shared.getCurrentUserID()
        contentView.addSubview(containerView)
        containerView.addSubviews(posterImageView,
                                  favouriteButton, 
                                  titleLabel,
                                  priceLabel, 
                                  ratingView)
        setupConstraintSubViews()
    }
    
    private func setupConstraintSubViews() {
        let paddingLike: CGFloat = 15
        let padding: CGFloat = 8
        let paddingTop: CGFloat = 3
        
        containerView.fillAnchor(contentView)
        
        posterImageView.anchor(top: containerView.topAnchor,
                               leading: containerView.leadingAnchor,
                               trailing: containerView.trailingAnchor,
                               paddingTop: padding, 
                               paddingLeading: padding,
                               paddingTrailing: padding)
        posterImageView.setHeight(height: frame.size.width - padding*2)
        
        favouriteButton.anchor(top: containerView.topAnchor, 
                               trailing: containerView.trailingAnchor,
                               paddingTop: paddingLike,
                               paddingTrailing: paddingLike)
        favouriteButton.setHeight(height: 30)
        favouriteButton.setWidth(width: 30)
        
        titleLabel.anchor(top: posterImageView.bottomAnchor,
                          leading: containerView.leadingAnchor, 
                          trailing: containerView.trailingAnchor, 
                          paddingTop: paddingTop,
                          paddingLeading: padding,
                          paddingTrailing: padding)
        titleLabel.setHeight(height: 30)
        
        priceLabel.anchor(top: titleLabel.bottomAnchor,
                          leading: containerView.leadingAnchor, 
                          trailing: containerView.trailingAnchor, 
                          paddingTop: paddingTop,
                          paddingLeading: padding)
        priceLabel.setHeight(height: 15)
        
        ratingView.anchor(top: priceLabel.bottomAnchor,
                          leading: containerView.leadingAnchor,
                          paddingLeading: padding)
        ratingView.setWidth(width: 65)
        ratingView.setHeight(height: 30)        
    }
    
    func setDataForDestination(_ data: HotelModel) {
        posterImageView.loadImage(url: data.thumbnail)
        titleLabel.text = data.name.capitalizeFirstLetter()
        priceLabel.text = "Start From $\(data.price)"
        ratingView.score = "\(data.rating)"
        favouriteButton.isChecked = data.like
    }
    
    func setupFavorite() {
        favouriteButton.currentUser = currentUser
        let wishlist = WishListModel(hotelID: hotelId, userID: currentUser)
        favouriteButton.likedClousure = { [weak self] in
            DispatchQueue.main.async {
                self?.viewModel.addWishtlist(with: wishlist)
            }
        } 
        
        favouriteButton.dislikeClousure = { [weak self] in
            DispatchQueue.main.async {
                self?.viewModel.removeFromWishlist(with: self?.hotelId ?? "")
            }
        }
    }
    
}
