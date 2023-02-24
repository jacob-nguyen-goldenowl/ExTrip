//
//  ETRoomButton.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 16/02/2023.
//

import UIKit

class ETRoomButton: UIButton {
    
    var numberOfRoom: Int = 1 {
        didSet {
            roomLabel.text = "\(numberOfRoom)"
        }
    }

    // MARK: - Properties    
    private lazy var nameButtonLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blue
        label.font = .poppins(style: .bold, size: 14)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var roomLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blue
        label.font = .poppins(style: .bold, size: 14)
        label.textAlignment = .center
        return label
    }()
        
    private lazy var expandArrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.sizeToFit()
        imageView.changeColorImage(image: UIImage(named: "expand"), color: .blue)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Initialization 
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubviews(nameButtonLabel,
                    roomLabel,
                    expandArrowImageView)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        roomLabel.anchor(top: topAnchor,
                         bottom: bottomAnchor,
                         leading: leadingAnchor,
                         trailing: nameButtonLabel.leadingAnchor)
        nameButtonLabel.text = "Room"
        nameButtonLabel.anchor(top: topAnchor,
                               bottom: bottomAnchor,
                               leading: roomLabel.trailingAnchor,
                               trailing: expandArrowImageView.leadingAnchor)
        expandArrowImageView.anchor(trailing: trailingAnchor)
        expandArrowImageView.center(centerY: nameButtonLabel.centerYAnchor)
    }
    
}
