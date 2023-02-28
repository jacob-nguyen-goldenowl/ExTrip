//
//  PaymentTableViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 28/02/2023.
//

import UIKit

class PaymentTableViewCell: UITableViewCell {

    static let identifier = "PaymentTableViewCell"
    
    private let padding: CGFloat = 15        
    private let sizeView: CGFloat = 30
    private let sizeIcon: CGFloat = 20
    
    private let primaryColor = UIColor.theme.primary ?? .blue
    
    var isCardDefault: Bool = false {
        didSet {
            setupDefaultTitle()
        }
    }
    var cardTitle: String? {
        didSet {
            cardTitleLabel.text = cardTitle?.localizedCapitalized
        }
    }
    
    var cardImage: UIImage? {
        didSet {
            cardImageView.image = cardImage
        }
    }
        
    // MARK: - Properties
    private lazy var containerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 3
        view.backgroundColor = primaryColor.withAlphaComponent(0.2)
        return view
    }()
    
    private lazy var cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.sizeToFit()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var cardTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(style: .medium, size: 13)
        label.textColor = .label
        return label
    }()

    private lazy var typeHotelLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(style: .light, size: 11)
        label.numberOfLines = 1
        label.text = "Default"
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
        addSubviews(containerView,
                    cardTitleLabel)
        containerView.addSubview(cardImageView)
        setupConstraintSubView()
    }
    
    private func setupConstraintSubView() {
        containerView.anchor(leading: leadingAnchor, 
                             paddingLeading: padding)
        containerView.center(centerY: centerYAnchor)
        containerView.setWidth(width: sizeView + sizeView)
        containerView.setHeight(height: sizeView)

        cardImageView.fillAnchor(containerView)
        
        cardTitleLabel.anchor(top: topAnchor,
                              bottom: bottomAnchor,
                              leading: containerView.trailingAnchor,
                              trailing: trailingAnchor,
                              paddingLeading: padding,
                              paddingTrailing: padding)
    }
    
    private func setupDefaultTitle() {
        addSubview(typeHotelLabel)
        typeHotelLabel.anchor(trailing: trailingAnchor,
                              paddingTrailing: padding)
        typeHotelLabel.setHeight(height: sizeIcon)
        typeHotelLabel.setWidth(width: 70)
        typeHotelLabel.center(centerY: centerYAnchor)
    }
    
}
