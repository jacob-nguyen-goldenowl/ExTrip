//
//  TrackerQRCodeTableViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 21/03/2023.
//

import UIKit

class TrackerQRCodeTableViewCell: UITableViewCell {
    
    static let identifier = "TrackerQRCodeTableViewCell"
    
    var image: UIImage? {
        didSet {
            qrCodeImageView.image = image
        }
    }
    
    private lazy var qrCodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()   
    
    // MARK: - INIT
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let imageSize: CGFloat = 100
        addSubview(qrCodeImageView)
        qrCodeImageView.backgroundColor = UIColor.theme.tertiarySystemFill

        qrCodeImageView.center(centerX: centerXAnchor,
                               centerY: centerYAnchor)
        qrCodeImageView.setHeight(height: imageSize)
        qrCodeImageView.setWidth(width: imageSize)
    }
}
