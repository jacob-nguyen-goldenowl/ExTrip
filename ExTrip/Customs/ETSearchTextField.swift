//
//  ETSearchTextField.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 21/12/2022.
//

import UIKit

class ETSearchTextField: UITextField {
    
    var minCharactersNumberToStartFiltering: Int = 0
    
    private var searchTextFieldItem: [String] = []

    private let iconPadding: CGFloat = 15
    private let iconHeight: CGFloat = 20

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
        setPlaceholderColor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTextField() {
        layer.cornerRadius = 15
        backgroundColor = .systemGray6
        font = .poppins(style: .light, size: 16)
        tintColor = UIColor.theme.black ?? .black
        placeholder = "Search ..."
        clearButtonMode = .whileEditing
        setSearchIcon(self)
    }
    
    private func setPlaceholderColor() {
        if placeholder == nil {
            placeholder = " "
        }
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.theme.lightGray ?? .lightGray])
    }
    
    private func setSearchIcon(_ textField: UITextField) {
        let outerView = UIView(frame: CGRect(x: iconPadding,
                                             y: 0,
                                             width: iconHeight + (iconPadding * 2),
                                             height: iconHeight))
        
        let iconView = UIImageView(frame: CGRect(x: iconPadding,
                                                 y: 0,
                                                 width: iconHeight, 
                                                 height: iconHeight))
        
        let image = UIImage(named: "search")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        iconView.image = tintedImage
        iconView.tintColor = UIColor.gray
        outerView.addSubview(iconView)
        textField.leftView = outerView
        textField.leftViewMode = .always
    }
}
