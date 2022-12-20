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
    var isSelectedLikeButton: Bool = false
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemBlue
        imageView.clipsToBounds = true
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
        if isSelectedLikeButton {
            let image = UIImage(named: "favorite.fill")
            let tintedImage = image?.withRenderingMode(.alwaysTemplate)
            likeButton.setImage(tintedImage, for: .normal)
            likeButton.tintColor = UIColor.theme.red ?? .red
        } else {
            let image = UIImage(named: "favorite")
            let tintedImage = image?.withRenderingMode(.alwaysTemplate)
            likeButton.setImage(tintedImage, for: .normal)
            likeButton.tintColor = UIColor.theme.white ?? .white
        }
    }
    
    private func setupActionButton() {
        likeButton.addTarget(self, action: #selector(handleLikeButton), for: .touchUpInside)
    }
    
    func getDataItem(_ data: Photo?) {
        posterImageView.image = data?.image ?? UIImage(named: "background")
        titleLabel.text = data?.country ?? "___"
        priceLabel.text = "Start From $0.00"
        ratingView.score = data?.rating ?? "0.0"
    }
}

extension DestinationCollectionViewCell {
    @objc func handleLikeButton() {
        isSelectedLikeButton = !isSelectedLikeButton
        changeColorLikeButton()
    }
}
