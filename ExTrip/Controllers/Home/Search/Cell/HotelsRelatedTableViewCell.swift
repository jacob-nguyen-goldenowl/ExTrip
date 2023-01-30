//
//  TestTableViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 14/01/2023.
//

import UIKit

class HotelsRelatedTableViewCell: UITableViewCell {

    static let identifier = "HotelsRelatedTableViewCell"

    // MARK: - Properties
    private lazy var hotelImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    public lazy var hotelLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .poppins(style: .bold, size: 13)
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
    
    //MARK: - Setup UI
    private func setupSubView() {
        contentView.addSubviews(hotelImageView, 
                                hotelLabel)
        setupConstraintSubView()
    }
    
    private func setupConstraintSubView() {
        let paddingLeft: CGFloat = 20
        let padding: CGFloat = 5
        let imageSize: CGFloat = frame.size.height - 10
        
        hotelImageView.center(centerY: centerYAnchor)
        hotelImageView.anchor(leading: leadingAnchor,
                              paddingLeading: paddingLeft)
        hotelImageView.setWidth(width: imageSize)
        hotelImageView.setHeight(height: imageSize)
        
        hotelLabel.center(centerY: centerYAnchor)
        hotelLabel.anchor(leading: hotelImageView.trailingAnchor,
                          trailing: trailingAnchor,
                          paddingLeading: padding,
                          paddingTrailing: padding)
    }
    
    func setDataOfHotel(text: String, query: String, image: String) {
        hotelLabel.setHighlighted(text.capitalizeFirstLetter(), with: query.capitalizeFirstLetter())
        hotelImageView.loadImage(url: image)
    }

}
