//
//  OverviewTableViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 11/01/2023.
//

import UIKit

class OverviewTableViewCell: DetailTableViewCell {

    static let identifier = "OverviewTableViewCell"
    
    var scoreRatting: String? {
        didSet {
            rattingStarView.score = scoreRatting
        }
    }
    
    var typeHotel: String? {
        didSet {
            typeHotelLabel.text = typeHotel
        }
    }
    
    var addressHotel: String? {
        didSet {
            if let address = addressHotel {
                if address.isEmpty {
                    noReceiveData()
                } else {
                    addressLabel.text = address
                }
            } else {
                noReceiveData()
            }
        }
    }
    
    private lazy var typeHotelLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(style: .light, size: 11)
        label.textColor = UIColor.theme.lightBlue ?? .blue
        label.sizeToFit()
        label.textAlignment = .center
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 2
        label.layer.borderColor = UIColor.theme.lightBlue?.cgColor
        return label
    }()

    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(style: .light, size: 11)
        label.textColor = UIColor.theme.lightGray
        label.sizeToFit()
        return label
    }()
    
    private lazy var iconLocationImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        let locationImage = UIImage(named: "location")
        let tintedImage = locationImage?.withRenderingMode(.alwaysTemplate)
        image.tintColor = .label
        image.image = tintedImage
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var rattingStarView = RattingView(type: .yellow)
                
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubView() {
        addSubviews(typeHotelLabel,
                    rattingStarView,
                    iconLocationImageView, 
                    addressLabel)
        headerTitle.font = .poppins(style: .bold, size: 18)
        setupConstraintSubView()
    }
    
    private func setupConstraintSubView() {
        let iconSize: CGFloat = 17
        typeHotelLabel.anchor(top: headerTitle.bottomAnchor,
                              leading: leadingAnchor, 
                              paddingTop: padding,
                              paddingLeading: padding)
        typeHotelLabel.setHeight(height: 27)
        typeHotelLabel.setWidth(width: 70)
        
        rattingStarView.anchor(top: headerTitle.bottomAnchor,
                               leading: typeHotelLabel.trailingAnchor,
                               paddingTop: padding, 
                               paddingLeading: padding)
        rattingStarView.setHeight(height: 27)
        
        iconLocationImageView.anchor(top: typeHotelLabel.bottomAnchor,
                                     leading: leadingAnchor,
                                     paddingTop: padding,
                                     paddingLeading: padding)
        iconLocationImageView.setHeight(height: iconSize)
        iconLocationImageView.setWidth(width: iconSize)
        
        addressLabel.anchor(top: typeHotelLabel.bottomAnchor,
                            leading: iconLocationImageView.trailingAnchor,
                            trailing: trailingAnchor,
                            paddingTop: padding,
                            paddingLeading: padding,
                            paddingTrailing: padding)
    }
    
    private func noReceiveData() {
        addressLabel.text = "No result"
    }
}
