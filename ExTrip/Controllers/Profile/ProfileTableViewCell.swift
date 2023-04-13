//
//  ProfileTableViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 03/03/2023.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    static let identifier = "ProfileTableViewCell"
    
    private let blackColor = UIColor.theme.black ?? .black
    
        // MARK: - Properties
    private lazy var containerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 3
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var profileIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.sizeToFit()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var profileTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(style: .medium, size: 15)
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
                    profileTitleLabel)
        containerView.addSubview(profileIcon)
        setupConstraintSubView()
    }
    
    private func setupConstraintSubView() {
        let padding: CGFloat = 15
        let paddingIcon: CGFloat = 5        
        let sizeView: CGFloat = 30
        
        containerView.anchor(leading: leadingAnchor, 
                             paddingLeading: padding)
        containerView.center(centerY: centerYAnchor)
        containerView.setWidth(width: sizeView)
        containerView.setHeight(height: sizeView)
        
        profileIcon.fillAnchor(containerView, padding: paddingIcon)
        
        profileTitleLabel.anchor(top: topAnchor,
                                 bottom: bottomAnchor,
                                 leading: containerView.trailingAnchor,
                                 trailing: trailingAnchor,
                                 paddingLeading: paddingIcon,
                                 paddingTrailing: padding)
    }
    
    private func changeColorIcon(image: UIImage?, color: UIColor?) {
        let image = image?.withRenderingMode(.alwaysTemplate)
        profileIcon.image = image
        profileIcon.tintColor = color
    }
    
    func setupProfile(icon: UIImage?,
                      title: String?,
                      color: UIColor? = UIColor.theme.black) {
        changeColorIcon(image: icon, color: color)
        profileTitleLabel.text = title
        profileTitleLabel.textColor = color
    }
    
}
