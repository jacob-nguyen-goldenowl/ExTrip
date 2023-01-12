//
//  DescriptionTableViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 11/01/2023.
//

import UIKit

protocol DescriptionTableViewCellDelegate {
    func descriptionTableViewCellHandleSeeDetails() 
}

class DescriptionTableViewCell: DetailTableViewCell {
    
    static let identifier = "DescriptionTableViewCell"
    
    var delegate: DescriptionTableViewCellDelegate?
    
    var descriptionHotel: String? {
        didSet {
            if let description = descriptionHotel {
                if description.isEmpty {
                    noReceiveData()
                } else {
                    descriptionTextField.text = description.newLineString()
                }
            } else {
                noReceiveData()
            }
        }
    }
    
    private lazy var seeDetailButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .poppins(style: .medium, size: 14)
        button.setTitleColor(UIColor.theme.lightBlue ?? .blue, for: .normal)
        button.setTitle("See Details", for: .normal)
        button.backgroundColor = .clear
        return button
    }()
        
    private lazy var descriptionTextField: UITextView = {
        let text = UITextView()
        text.font = .poppins(style: .light, size: 13)
        text.sizeToFit()
        text.isEditable = false
        text.isSelectable = false
        text.isScrollEnabled = false
        return text
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubView() {
        addSubviews(seeDetailButton,
                    descriptionTextField)
        seeDetailButton.addTarget(self, action: #selector(handleSeeDetailsAction), for: .touchUpInside)
        setupConstraintSubView()
    }
    
    private func setupConstraintSubView() {
        
        seeDetailButton.anchor(bottom: bottomAnchor, 
                               paddingBottom: padding)
        seeDetailButton.center(centerX: centerXAnchor)
        seeDetailButton.setHeight(height: 30)
        seeDetailButton.setWidth(width: 100)
        
        descriptionTextField.anchor(top: headerTitle.bottomAnchor,
                                bottom: seeDetailButton.topAnchor,
                                leading: leadingAnchor, 
                                trailing: trailingAnchor,
                                paddingTop: padding,
                                paddingLeading: padding,
                                paddingTrailing: padding)
    }
    
    private func noReceiveData() {
        descriptionTextField.text = "No result"
        descriptionTextField.textAlignment = .center
    }
}

extension DescriptionTableViewCell {
    @objc func handleSeeDetailsAction() {
        delegate?.descriptionTableViewCellHandleSeeDetails()
    }
}
