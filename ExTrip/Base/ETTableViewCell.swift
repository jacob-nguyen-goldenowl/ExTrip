//
//  ETTableViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 04/01/2023.
//

import UIKit

class ETTableViewCell: UITableViewCell {
    
    public var isSelectedLikeButton: Bool = false
    
    public let posterImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        return imageView
    }()

    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.theme.black ?? .black
        label.font = .poppins(style: .medium)
        label.numberOfLines = 2
        return label
    }()
    
    public lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.theme.black ?? .black
        label.font = .poppins(style: .bold, size: 16)
        return label
    }()
    
    public lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.theme.black ?? .black
        label.numberOfLines = 2
        label.font = .poppins(style: .light, size: 11)
        return label
    }()
    
    public lazy var roomInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.theme.black ?? .black
        label.font = .poppins(style: .light, size: 12)
        return label
    }()
    
    public lazy var reviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.theme.lightGray
        label.font = .poppins(style: .light, size: 11)
        return label
    }()
    
    public lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.theme.lightGreen
        label.font = .poppins(style: .medium, size: 12)
        return label
    }()
    
    public lazy var defaultPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.theme.lightGray ?? .gray
        label.font = .poppins(style: .medium, size: 13)
        return label
    }()
    
    public lazy var soldOutPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.theme.lightGray ?? .gray
        label.font = .poppins(style: .bold, size: 13)
        label.textAlignment = .center
        return label
    }()

        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
