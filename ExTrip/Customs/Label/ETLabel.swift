//
//  ETLabel.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 16/02/2023.
//

import UIKit

enum LabelType {
    case small
    case nomal
    case medium
    case large
}

class ETLabel: UILabel {
    
    // MARK: - Initialization 
    required init(style: LabelType, textAlignment: NSTextAlignment = .center) {  
        super.init(frame: .zero)
        setupLabel(style: style, textAlignment: textAlignment)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabel(style: LabelType, textAlignment: NSTextAlignment) {
        self.numberOfLines = 1
        self.textColor = .black
        self.backgroundColor = .clear
        self.font = .poppins(style: .bold, size: 11)
        switch style {
            case .small: 
                self.textAlignment = textAlignment
            case .nomal: 
                self.textAlignment = textAlignment
                self.font = .poppins(style: .bold, size: 12)
                self.backgroundColor = UIColor.theme.tertiarySystemFill
            case .medium:
                self.textAlignment = textAlignment
                self.textColor = UIColor.theme.lightGreen ?? .green
            case .large:
                self.textAlignment = textAlignment
                self.font = .poppins(style: .bold, size: 15)
        } 
    }
}


