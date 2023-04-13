//
//  FilterErrorView.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 01/02/2023.
//

import UIKit

class FilterErrorView: UIView {
    
    private let imageView: UIImageView = {
        let errorImage = UIImage(systemName: "ladybug")
        let imageView = UIImageView(image: errorImage)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Not found"
        label.font = .poppins(style: .bold, size: 15)
        label.textAlignment = .center
        return label
    }()
    
    private let errorSubLabel: UILabel = {
        let label = UILabel()
        label.text = "There are no results on the hotels you searched. Please change your hotels or search for a different location."
        label.font = .poppins(style: .light, size: 13)
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()

    private lazy var errorStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [UIView(),
                                                       imageView, 
                                                       errorLabel, 
                                                       errorSubLabel])
        stackView.spacing = 12
        stackView.axis = .vertical
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(errorStackView)
        let padding: CGFloat = 25
        errorStackView.anchor(leading: leadingAnchor,
                              trailing: trailingAnchor,
                              paddingLeading: padding,
                              paddingTrailing: padding)
        errorStackView.center(centerY: centerYAnchor)
        
        imageView.setHeight(height: 50)
    }

}
