//
//  File.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 06/01/2023.
//

import UIKit

class CheckBox: UIButton {
    
    // Images
    let checkedImage = UIImage(named: "star")! as UIImage
    
    var numberOfStar: String? {
        didSet {
            numberOfStarLabel.text = numberOfStar
        }
    }
    
    private lazy var numberOfStarLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .poppins(style: .regular)
        label.textColor = UIColor.theme.white ?? .white
        return label
    }()
    
    private lazy var starImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = checkedImage
        imageView.contentMode = .scaleAspectFit
        imageView.sizeToFit()
        return imageView
    }()
    
    // Bool property
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                backgroundColor = UIColor.theme.yellow
                starImage.tintColor = UIColor.theme.white
                
            } else {
                backgroundColor = UIColor.theme.lightGray?.withAlphaComponent(0.6)
                starImage.tintColor = UIColor.theme.yellow
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubviews(numberOfStarLabel,
                    starImage)
        addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        isChecked = false
        backgroundColor = UIColor.theme.lightGray?.withAlphaComponent(0.6)
        layer.cornerRadius = 5
        setupConstraints()
        
    }
    
    private func setupConstraints() {
        let padding: CGFloat = 6
        starImage.anchor(top: topAnchor,
                               bottom: bottomAnchor,
                               trailing: trailingAnchor, 
                               paddingTop: padding,
                               paddingBottom: padding,
                               paddingLeading: padding,
                               paddingTrailing: padding)
        starImage.setWidth(width: 25)
        
        numberOfStarLabel.anchor(top: topAnchor, 
                                bottom: bottomAnchor,
                                leading: leadingAnchor,
                                paddingLeading: padding)
        numberOfStarLabel.setWidth(width: 25)
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
