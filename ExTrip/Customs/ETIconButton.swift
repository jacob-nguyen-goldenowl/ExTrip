//
//  ETIconButton.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 09/12/2022.
//

import UIKit

enum ETIconStyle {
    case facebook
    case google
}

class ETIconButton: UIButton {
    
    // MARK: - Properties
    var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.clipsToBounds = true
        }
    }
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Login with google"
        label.sizeToFit() 
        return label
    }()
    
    // MARK: - Initialization
    required init(style: ETIconStyle) {
        super.init(frame: .zero)
        setupSubViews()
        setupStyleButton(style: style)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Draw
    override func draw(_ rect: CGRect) {
        let iconSize: CGFloat = 22
        let iconX: CGFloat = (frame.size.width - textLabel.frame.size.width - iconSize - 10) / 2
        let iconY: CGFloat = (frame.size.height - iconSize) / 2
    
        iconImageView.frame = CGRect(x: iconX,
                                     y: iconY,
                                     width: iconSize,
                                     height: iconSize)
        
        textLabel.frame = CGRect(x: iconX + iconSize + 10, 
                                 y: 0,
                                 width: textLabel.frame.size.width,
                                 height: frame.size.height)
    }
    
    // MARK: - Setup UI
    private func setupSubViews() {
        addSubviews(iconImageView, 
                    textLabel)
    }
    
    private func setupStyleButton(style: ETIconStyle) {
        textLabel.font = .poppins(style: .regular)
        cornerRadius = 10
        switch style {
        case .facebook:
            textLabel.text = "Login with Facebook"
            iconImageView.image = UIImage(named: "facebook")
            textLabel.textColor = UIColor.theme.black ?? .black
            backgroundColor = UIColor.theme.lightBlue
        case .google:
            textLabel.text = "Login with Google"
            iconImageView.image = UIImage(named: "google")
            textLabel.textColor = UIColor.theme.black
            backgroundColor = UIColor.theme.white ?? .white
        }
    }
}
