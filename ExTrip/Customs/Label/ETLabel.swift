//
//  ETLabel.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 16/02/2023.
//

import UIKit

class ETLabel: UILabel {
    
    // MARK: - Initialization 
    required init(textColor: UIColor = UIColor.theme.black ?? .black,
                  fontStyle: UIFont = .poppins(style: .bold, size: 11),
                  textAlignment: NSTextAlignment = .center,
                  numberOfLines: Int = 1) {  
        super.init(frame: .zero)
        setupLabel(textColor: textColor,
                   fontStyle: fontStyle,
                   textAlignment: textAlignment,
                   numberOfLines: numberOfLines)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabel(textColor: UIColor,
                            fontStyle: UIFont, 
                            textAlignment: NSTextAlignment,
                            numberOfLines: Int) {
        self.textColor = textColor
        self.font = fontStyle
        self.backgroundColor = UIColor.theme.tertiarySystemFill
        self.textAlignment = textAlignment
        self.numberOfLines = numberOfLines
    }
}


