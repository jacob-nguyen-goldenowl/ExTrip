//
//  HotelClassTableViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 05/01/2023.
//

import UIKit

class HotelClassTableViewCell: FilterTableViewCell {

    static let identifier = "HotelClassTableViewCell"
    
    var currentStar: ((Int) -> Void)?
        
    private lazy var horizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.spacing = 10
        return stack
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubViews()
        addViewsToStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubViews() {
        addSubviews(headerTitle, 
                    horizontalStackView)
        setupConstraintSubViews()
    }
    
    private func setupConstraintSubViews() {
        let padding: CGFloat = 30
        let paddingTop: CGFloat = 8
        headerTitle.anchor(top: topAnchor,
                           leading: leadingAnchor,
                           paddingTop: paddingTop,
                           paddingLeading: padding)
        headerTitle.setHeight(height: 20)

        horizontalStackView.anchor(leading: leadingAnchor,
                                   trailing: trailingAnchor,
                                   paddingLeading: padding,
                                   paddingTrailing: padding)
        horizontalStackView.center(centerY: centerYAnchor)
        horizontalStackView.setHeight(height: 30)
    }
    
    private func addViewsToStackView() {
        let numberOfViews = 5
        for i in 1...numberOfViews {
            let button = CheckBox()
            button.currentStar = { star in
                self.currentStar?(star)
            }
            button.numberOfStar = i
            horizontalStackView.addArrangedSubview(button)
        }
    }
    
}
