//
//  ReviewBookTableViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 17/02/2023.
//

import UIKit

class ReviewBookTableViewCell: ETTableViewCell {

    static let identifier = "ReviewBookTableViewCell"

    private let padding: CGFloat = 10
    private let paddingTop: CGFloat = 5
    private let paddingSize: CGFloat = 10
    private let buttonSize: CGFloat = 25
    
    private let locationImage = UIImage(named: "clock")

    private lazy var boxView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 0.8
        view.layer.borderColor = UIColor.theme.tertiarySystemFill?.cgColor
        return view
    }()
    
    private lazy var paymentMethodLabel = ETLabel(style: .medium, textAlignment: .left)
    private lazy var refuldLabel = ETLabel(style: .medium, textAlignment: .left)

    // MARK: - INIT
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubViews() {
        contentView.addSubview(boxView)
        boxView.addSubviews(posterImageView,
                            titleLabel, 
                            paymentMethodLabel, 
                            refuldLabel)
        setupConstraintSubViews()   
    }
    
    // MARK: - Constraints
    private func setupConstraintSubViews() {
        boxView.fillAnchor(contentView, padding: padding) 
        
        posterImageView.anchor(top: boxView.topAnchor,
                               bottom: boxView.bottomAnchor,
                               trailing: boxView.trailingAnchor,
                               paddingTop: paddingSize,
                               paddingBottom: paddingSize,
                               paddingTrailing: paddingSize)
        posterImageView.layer.cornerRadius = 5
        posterImageView.setHeight(height: 70)
        posterImageView.setWidth(width: 70)
        
        titleLabel.anchor(top: boxView.topAnchor, 
                          leading: boxView.leadingAnchor, 
                          trailing: posterImageView.leadingAnchor,
                          paddingTop: padding,
                          paddingLeading: padding,
                          paddingTrailing: paddingSize)
        
        refuldLabel.anchor(top: titleLabel.bottomAnchor, 
                           leading: boxView.leadingAnchor, 
                           trailing: posterImageView.leadingAnchor,
                           paddingTop: paddingTop,
                           paddingLeading: padding,
                           paddingTrailing: paddingSize)   

        paymentMethodLabel.anchor(top: refuldLabel.bottomAnchor,
                                  leading: boxView.leadingAnchor, 
                                  trailing: posterImageView.leadingAnchor,
                                  paddingTop: paddingTop,
                                  paddingBottom: paddingSize,
                                  paddingLeading: padding,
                                  paddingTrailing: paddingSize)
    }
    
    var room: RoomModel? {
        didSet {
            if let room = room {
                posterImageView.loadImage(url: room.image.first ?? "")
                titleLabel.text = room.type.capitalizeFirstLetter()
                refuldLabel.text = "Non-refulable"
                paymentMethodLabel.text = "Booking without credit card"
            } else {
                boxView.removeFromSuperview()
                removeAllFromSubView([posterImageView,
                                      titleLabel, 
                                      paymentMethodLabel, 
                                      refuldLabel])
            }
        }
    }
    
}
