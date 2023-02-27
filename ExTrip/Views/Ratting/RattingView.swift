//
//  RattingView.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 20/12/2022.
//

import UIKit

enum RatingType {
    case gray
    case yellow
}

class RattingView: UIView {
    
    var score: String? {
        didSet {
            scoreRatingLabel.text = score
        }
    }
    
    var color: UIColor? {
        didSet {
            starRatingImage.tintColor = color
        }
    }
    
    private lazy var scoreRatingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .poppins(style: .regular)
        label.textColor = UIColor.theme.white ?? .white
        return label
    }()
    
    private lazy var starRatingImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "star")
        imageView.contentMode = .scaleAspectFit
        imageView.sizeToFit()
        return imageView
    }()
    
    required init(type: RatingType) {
        super.init(frame: .zero)
        setupRatingView(type)
        setupSubView(type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubView(_ type: RatingType) {
        addSubviews(starRatingImage,
                    scoreRatingLabel)
        
        let padding: CGFloat = 6
        let paddingLeft: CGFloat?
        let paddingRight: CGFloat?
        
        switch type {
        case .gray: 
            paddingLeft = 6
            paddingRight = 6
        case .yellow:
            paddingLeft = 0
            paddingRight = 15
        }
        
        starRatingImage.anchor(top: topAnchor,
                               bottom: bottomAnchor,
                               trailing: trailingAnchor, 
                               paddingTop: padding,
                               paddingBottom: padding,
                               paddingLeading: padding,
                               paddingTrailing: paddingRight ?? 6)
        starRatingImage.setWidth(width: 25)
        
        scoreRatingLabel.anchor(top: topAnchor, 
                                bottom: bottomAnchor,
                                leading: leadingAnchor,
                                trailing: starRatingImage.leadingAnchor,
                                paddingLeading: paddingLeft ?? 6)
    }
    
    private func setupRatingView(_ type: RatingType) {
        switch type {
        case .gray:
            self.layer.masksToBounds = true
            self.layer.cornerRadius = 10
            self.backgroundColor = UIColor.theme.lightGray?.withAlphaComponent(0.7)
            starRatingImage.tintColor = UIColor.theme.white ?? .white
        case .yellow:
            self.backgroundColor = .clear
            scoreRatingLabel.textColor = UIColor.theme.black ?? .black
            starRatingImage.tintColor = UIColor.theme.yellow ?? .yellow
        }
    }
    
}
