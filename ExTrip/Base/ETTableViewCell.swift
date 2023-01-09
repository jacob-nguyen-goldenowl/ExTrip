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
        label.font = .poppins(style: .light, size: 12)
        return label
    }()
    
    public lazy var starHorizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 3
        stack.distribution = .fillEqually
        return stack
    }()

    public lazy var start1 = setupStartView()
    public lazy var start2 = setupStartView()
    public lazy var start3 = setupStartView()
    public lazy var start4 = setupStartView()
    public lazy var start5 = setupStartView()
    
    private let ratingView = RattingView(type: .yellow)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStartView(_ color: UIColor? = UIColor.theme.yellow) -> UIImageView {
        let imageView = UIImageView()
        let image = UIImage(named: "star")
        imageView.image = image
        imageView.tintColor = color ?? .yellow
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }
    
}
