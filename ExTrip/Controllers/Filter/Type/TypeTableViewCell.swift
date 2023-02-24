//
//  TypeTableViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 05/01/2023.
//

import UIKit

class TypeTableViewCell: UITableViewCell {
    
    static let identifier = "TypeTableViewCell"
    
    var checkBox: UIImage? {
        didSet {
            checkBoxButton.setImage(checkBox, for: .normal)
        }
    }
    
    public lazy var checkBoxButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFit
        button.backgroundColor = .clear
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        textLabel?.font = .poppins(style: .medium)
        setupSubView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubView() {
        contentView.addSubview(checkBoxButton)
        
        checkBoxButton.center(centerY: centerYAnchor)
        checkBoxButton.anchor(trailing: contentView.trailingAnchor,
                              paddingTrailing: 10)
        checkBoxButton.setWidth(width: 35)
        checkBoxButton.setHeight(height: 35)
    }

}
