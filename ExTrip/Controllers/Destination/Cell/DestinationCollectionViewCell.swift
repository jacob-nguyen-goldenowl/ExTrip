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
    var isSelectedLikeButton: Bool = false {
        didSet {
            changeColorLikeButton()
        }
    }
    
    private let posterImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 0.7
        imageView.layer.borderColor = UIColor.theme.lightGray?.cgColor ?? UIColor.lightGray.cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Chillax Heritage"
        label.textColor = UIColor.theme.black ?? .black
        label.font = .poppins(style: .medium)
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
        setupActionButton()
        changeColorLikeButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubViews() {
        contentView.addSubviews(posterImageView,
                                likeButton, 
                                titleLabel,
                                priceLabel, 
                                ratingView)
        setupConstraintSubViews()
    }
    
    private func setupConstraintSubViews() {
        let paddingLike: CGFloat = 15
        let padding: CGFloat = 5
        posterImageView.anchor(top: topAnchor,
                               leading: leadingAnchor,
                               trailing: trailingAnchor)
        posterImageView.setHeight(height: frame.size.width)
        
        likeButton.anchor(top: topAnchor, 
                          trailing: trailingAnchor,
                          paddingTop: paddingLike,
                          paddingTrailing: paddingLike)
        likeButton.setHeight(height: 30)
        likeButton.setWidth(width: 30)
        
        titleLabel.anchor(top: posterImageView.bottomAnchor,
                          leading: leadingAnchor, 
                          trailing: trailingAnchor, 
                          paddingTop: padding,
                          paddingLeading: padding)
        titleLabel.setHeight(height: 20)
        
        priceLabel.anchor(top: titleLabel.bottomAnchor,
                          leading: leadingAnchor, 
                          trailing: trailingAnchor, 
                          paddingTop: padding,
                          paddingLeading: padding)
        priceLabel.setHeight(height: 20)
        
        ratingView.anchor(top: priceLabel.bottomAnchor,
                          leading: leadingAnchor,
                          paddingLeading: padding)
        ratingView.setWidth(width: 65)
        ratingView.setHeight(height: 30)        
    }
    
    private func changeColorLikeButton() {
        let image = UIImage(named: isSelectedLikeButton ? "favorite.fill" : "favorite")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        likeButton.setImage(tintedImage, for: .normal)
        likeButton.tintColor = isSelectedLikeButton ? UIColor.theme.red ?? .red : UIColor.theme.white ?? .white
    }
    
    private func setupActionButton() {
        likeButton.addTarget(self, action: #selector(handleLikeAction), for: .touchUpInside)
    }
    
    func setDataForDestination(_ data: HotelModel) {
        posterImageView.loadImage(url: data.image[0])
        titleLabel.text = data.name
        priceLabel.text = "Start From $\(data.price)"
        ratingView.score = data.rating
    }
}

extension DestinationCollectionViewCell {
    @objc func handleLikeAction() {
        isSelectedLikeButton = !isSelectedLikeButton
        changeColorLikeButton()
    }
}
