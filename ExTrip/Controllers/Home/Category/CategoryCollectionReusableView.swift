//
//  CagegoryCollectionReusableView.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 14/12/2022.
//

import UIKit

class CategoryCollectionReusableView: UICollectionReusableView {
        
    static let identifier = "CategoryCollectionReusableView"
    
    private let categoryStackView = UIStackView()
    private let titleStackView = UIStackView()
    
    private lazy var hotelButton = createCategory(image: UIImage(named: "bedroom"), color: UIColor.theme.lightBlue)
    private lazy var flightButton = createCategory(image: UIImage(named: "airport"), color: UIColor.theme.lightRed)
    private lazy var eventButton = createCategory(image: UIImage(named: "event"), color: UIColor.theme.lightGreen)
    
    private lazy var hotelLabel = createLabel(title: "Hotels")
    private lazy var flightLabel = createLabel(title: "Flights")
    private lazy var eventLabel = createLabel(title: "Events")

    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.theme.lightGray
        return view
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Best Destination"
        label.font = .poppins(style: .bold)
        return label
    }()
    
    private lazy var seeAllButton: UIButton = {
        let button = UIButton()
        button.setTitle("see all".uppercased(), for: .normal)
        button.titleLabel?.font = .poppins(style: .medium, size: 13)
        button.setTitleColor(UIColor.theme.lightGray, for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubViews() {
        addSubviews(categoryStackView, 
                    titleStackView,
                    separatorView,
                    categoryLabel, 
                    seeAllButton)
        
        setupStackView(stackView: categoryStackView, views: [hotelButton, flightButton, eventButton])
        setupStackView(stackView: titleStackView, views: [hotelLabel, flightLabel, eventLabel])
        
        let padding: CGFloat = 20
        let paddingStack: CGFloat = 40
        categoryStackView.anchor(top: topAnchor,
                                 leading: leadingAnchor,
                                 trailing: trailingAnchor, 
                                 paddingTop: paddingStack,
                                 paddingLeading: paddingStack,
                                 paddingTrailing: paddingStack)
        categoryStackView.setHeight(height: 60)
        
        titleStackView.anchor(top: categoryStackView.bottomAnchor,
                              leading: leadingAnchor,
                              trailing: trailingAnchor, 
                              paddingTop: 7,
                              paddingLeading: paddingStack,
                              paddingTrailing: paddingStack)
        titleStackView.setHeight(height: 10)
        
        separatorView.anchor(top: titleStackView.bottomAnchor,
                             leading: leadingAnchor,
                             trailing: trailingAnchor,
                             paddingTop: 50,
                             paddingLeading: padding,
                             paddingTrailing: padding)
        separatorView.setHeight(height: 0.5)
        
        categoryLabel.anchor(top: separatorView.bottomAnchor,
                             leading: leadingAnchor,
                             paddingTop: padding,
                             paddingLeading: padding)
        categoryLabel.setHeight(height: 30)
        
        seeAllButton.anchor(top: separatorView.bottomAnchor,
                            trailing: trailingAnchor,
                            paddingTop: padding, 
                            paddingTrailing: padding)
        seeAllButton.setHeight(height: 30)
    }
    
    private func createCategory(image: UIImage?, color: UIColor?) -> UIButton {
        let button = UIButton()
        button.backgroundColor = color?.withAlphaComponent(0.2)
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = color
        button.clipsToBounds = true
        button.layer.cornerRadius = 15
        button.tintColor = color
        return button
    }
    
    private func createLabel(title: String) -> UILabel {
        let label = UILabel()
        label.text = title.uppercased()
        label.font = .poppins(style: .medium, size: 13)
        label.textAlignment = .center
        label.textColor = UIColor.theme.lightGray
        return label
    }
    
    private func setupStackView(stackView: UIStackView, views: [UIView]) {
        for i in views {
            stackView.addArrangedSubview(i)
        }
        stackView.axis = .horizontal
        stackView.spacing = 60
        stackView.distribution = .fillEqually
    }
}


