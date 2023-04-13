//
//  SearchDestinationTableViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 03/02/2023.
//

import UIKit

class SearchDestinationTableViewCell: UITableViewCell {

    static let indentifier = "SearchDestinationTableViewCell"

    private let rightImage = UIImage(named: "right")
    private let primaryColor = UIColor.theme.primary ?? .blue
    private let locationImage = UIImage(named: "location")
    
    var titleText: String = "" {
        didSet {
            titleHotelLabel.text = titleText.localizedCapitalized
        }
    }
    
    var addressText: String = "" {
        didSet {
            addressHotelLabel.text = "Address: \(addressText.localizedCapitalized)"
        }
    }
    
    var typeText: String = "" {
        didSet {
            typeHotelLabel.text = typeText.localizedCapitalized
        }
    }
    
    private let boxView = UIView()
    
        // MARK: - Properties
    private lazy var containerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 3
        view.backgroundColor = primaryColor.withAlphaComponent(0.2)
        return view
    }()
    
    private lazy var seachIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.sizeToFit()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleHotelLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(style: .bold, size: 13)
        label.numberOfLines = 2
        label.text = "The Prince Park Tower Tokyo"
        label.textColor = primaryColor
        return label
    }()
    
    private lazy var addressHotelLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(style: .light, size: 11)
        label.numberOfLines = 3
        label.text = "Address: 4-chōme-8-1 Shibakōen, Minato City, Tokyo 105-8563"
        label.textColor = primaryColor
        return label
    }()
    
    private lazy var typeHotelLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(style: .light, size: 11)
        label.numberOfLines = 1
        label.text = "House"
        label.textAlignment = .center
        label.backgroundColor = .secondarySystemFill
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        label.textColor = primaryColor
        return label
    }()
    
        // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupSubView() {
        addSubview(boxView)
        boxView.addSubviews(containerView,
                            titleHotelLabel, 
                            typeHotelLabel, 
                            addressHotelLabel)
        containerView.addSubview(seachIconImageView)
        createIconStep(image: locationImage, color: primaryColor)
        setupConstraintSubView()
    }
    
    private func setupConstraintSubView() {
        let padding: CGFloat = 15
        let paddingIcon: CGFloat = 5
        let paddingBox: CGFloat = 2
        
        let sizeView: CGFloat = 30
        let sizeIcon: CGFloat = 20
        
        boxView.anchor(top: topAnchor,
                       bottom: bottomAnchor,
                       leading: leadingAnchor,
                       trailing: trailingAnchor,
                       paddingTop: paddingBox,
                       paddingBottom: paddingBox,
                       paddingLeading: paddingBox,
                       paddingTrailing: paddingBox)
        
        containerView.anchor(leading: boxView.leadingAnchor, 
                             paddingLeading: padding)
        containerView.center(centerY: boxView.centerYAnchor)
        containerView.setWidth(width: sizeView)
        containerView.setHeight(height: sizeView)
        
        seachIconImageView.anchor(top: containerView.topAnchor, 
                                  bottom: containerView.bottomAnchor,
                                  leading: containerView.leadingAnchor,
                                  trailing: containerView.trailingAnchor,
                                  paddingTop: paddingIcon,
                                  paddingBottom: paddingIcon,
                                  paddingLeading: paddingIcon,
                                  paddingTrailing: paddingIcon)
        
        typeHotelLabel.anchor(trailing: boxView.trailingAnchor,
                              paddingTrailing: padding)
        typeHotelLabel.setHeight(height: sizeIcon)
        typeHotelLabel.setWidth(width: 70)
        typeHotelLabel.center(centerY: boxView.centerYAnchor)
        
        titleHotelLabel.anchor(top: boxView.topAnchor,
                               bottom: addressHotelLabel.topAnchor,
                               leading: containerView.trailingAnchor,
                               trailing: typeHotelLabel.leadingAnchor,
                               paddingLeading: padding,
                               paddingTrailing: padding)
        
        addressHotelLabel.anchor(top: titleHotelLabel.bottomAnchor,
                                 bottom: boxView.bottomAnchor,
                                 leading: containerView.trailingAnchor,
                                 trailing: typeHotelLabel.leadingAnchor,
                                 paddingLeading: padding,
                                 paddingTrailing: padding)

    }
    
    private func createIconStep(image: UIImage?, color: UIColor?) {
        containerView.backgroundColor = color?.withAlphaComponent(0.2)
        let image = image?.withRenderingMode(.alwaysTemplate)
        seachIconImageView.image = image
        seachIconImageView.tintColor = color
    }

}
