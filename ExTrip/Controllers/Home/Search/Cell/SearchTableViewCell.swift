//
//  SearchTableViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 13/01/2023.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    static let identifier = "SearchTableViewCell"
    
    private let rightImage = UIImage(named: "right")
    private let primaryColor = UIColor.theme.primary ?? .blue
    
    var resultText: String = "" {
        didSet {
            textSearchLabel.text = "Search places for \"\(resultText)\""
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
    
    private lazy var seachIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.sizeToFit()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var textSearchLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(style: .bold, size: 13)
        label.numberOfLines = 2
        label.textColor = primaryColor
        return label
    }()
    
    private lazy var rightIconButton: UIButton = {
        let button = UIButton()
        let tintedImage = rightImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = primaryColor
        button.backgroundColor = .clear
        return button
    }()
        
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup UI
    private func setupSubView() {
        contentView.addSubviews(containerView,
                                textSearchLabel, 
                                rightIconButton)
        containerView.addSubview(seachIconImageView)
        createIconStep(image: UIImage(named: "search"), color: primaryColor)
        setupConstraintSubView()
    }
    
    private func setupConstraintSubView() {
        let padding: CGFloat = 20
        let paddingIcon: CGFloat = 5
        
        let sizeView: CGFloat = 30
        let sizeIcon: CGFloat = 20
        
        containerView.anchor(leading: leadingAnchor, 
                             paddingLeading: padding)
        containerView.center(centerY: centerYAnchor)
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
        
        rightIconButton.anchor(trailing: trailingAnchor,
                               paddingTrailing: padding)
        rightIconButton.setWidth(width: sizeIcon)
        rightIconButton.setHeight(height: sizeIcon)
        rightIconButton.center(centerY: centerYAnchor)
        
        textSearchLabel.anchor(leading: containerView.trailingAnchor,
                               trailing: rightIconButton.leadingAnchor,
                               paddingLeading: padding,
                               paddingTrailing: padding)
        textSearchLabel.center(centerY: centerYAnchor)
    }
    
    private func createIconStep(image: UIImage?, color: UIColor?) {
        containerView.backgroundColor = color?.withAlphaComponent(0.2)
        let image = image?.withRenderingMode(.alwaysTemplate)
        seachIconImageView.image = image
        seachIconImageView.tintColor = color
    }
    
}


