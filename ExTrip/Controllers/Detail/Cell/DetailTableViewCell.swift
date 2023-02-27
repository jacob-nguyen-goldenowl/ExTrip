//
//  DetailTableViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 09/01/2023.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    public let padding: CGFloat = 8
    
    var title: String? {
        didSet {
            headerTitle.text = title?.capitalizeFirstLetter()
        }
    }
    
    var numberOfReview: String? {
        didSet {
            setupReviewLabel()
        }
    }
    
    public lazy var headerTitle: UILabel = {
        let label = UILabel()
        label.font = .poppins(style: .bold, size: 15)
        return label
    }()
    
    private lazy var reviewButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .poppins(style: .medium, size: 13)
        button.setTitleColor(UIColor.theme.lightBlue ?? .blue, for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        textLabel?.font = .poppins(style: .light, size: 14)
        setupSubView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubView() {
        backgroundColor = .clear
        addSubview(headerTitle)
        setupConstraintSubView()
    }
    
    private func setupConstraintSubView() {
        headerTitle.anchor(top: topAnchor,
                           leading: leadingAnchor,
                           paddingTop: padding,
                           paddingLeading: padding)
        headerTitle.setHeight(height: 30)
    }
    
    private func setupReviewLabel() {
        reviewButton.setTitle("\(numberOfReview ?? "0") Reviews", for: .normal)
        addSubview(reviewButton)
        reviewButton.anchor(top: topAnchor, 
                            bottom: bottomAnchor,
                            trailing: trailingAnchor,
                            paddingTop: padding,
                            paddingBottom: padding, 
                            paddingTrailing: 40)
    }
}
