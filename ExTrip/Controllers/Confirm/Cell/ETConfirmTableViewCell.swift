//
//  ETConfirmTableViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 28/02/2023.
//

import UIKit

class ETConfirmTableViewCell: UITableViewCell {
    
    let padding: CGFloat = 10
    let paddingTop: CGFloat = 5
    let paddingSize: CGFloat = 10
    
    lazy var posterImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    lazy var titleLabel = ETLabel(style: .large, textAlignment: .left)
    lazy var descriptionLabel = ETLabel(style: .medium, textAlignment: .left)
    lazy var refuldLabel = ETLabel(style: .medium, textAlignment: .left)
    lazy var dataLabel = ETLabel(style: .small, size: 13)
    
    lazy var separatorView = UIView()
    
        // MARK: - INIT
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupHorizontalStackView(title: String, info: UILabel) -> UIStackView {
        lazy var titleLabel = ETLabel(style: .small, size: 13)
        titleLabel.text = title
        let stackView = UIStackView(arrangedSubviews: [titleLabel, info])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        return stackView
    }
    
}
