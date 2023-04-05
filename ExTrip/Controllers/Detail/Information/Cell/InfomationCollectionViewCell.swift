//
//  InfomationCollectionViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 10/01/2023.
//

import UIKit

class InfomationCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "InfomationCollectionViewCell"
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var informationLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(style: .light, size: 13)
        label.sizeToFit()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubView() {
        backgroundColor = .clear
        addSubviews(iconImageView,
                    informationLabel)
        setupConstraintSubView()
    }
    
    private func setupConstraintSubView() {
        let iconSize: CGFloat = 25
        iconImageView.center(centerY: centerYAnchor)
        iconImageView.anchor(leading: leadingAnchor,
                             paddingLeading: 20)
        iconImageView.setHeight(height: iconSize)
        iconImageView.setWidth(width: iconSize)
        
        informationLabel.center(centerY: centerYAnchor)
        informationLabel.anchor(top: topAnchor,
                                bottom: bottomAnchor,
                                leading: iconImageView.trailingAnchor,
                                trailing: trailingAnchor,
                                paddingLeading: 5)
    }
    
    func setDataForInformation(_ data: InformationModel) {
        let tintedImage = data.icon?.withRenderingMode(.alwaysTemplate)
        iconImageView.image = tintedImage
        iconImageView.tintColor = .label
        informationLabel.text = data.title
    }
}
