//
//  UILabel+Extension.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 15/01/2023.
//

import UIKit

extension UILabel {
    func setHighlighted(_ text: String, with search: String) {
        let attributedText = NSMutableAttributedString(string: text)
        
        let range = NSString(string: text).range(of: search)
        let highlightColor = traitCollection.userInterfaceStyle == .light ? UIColor.theme.primary : UIColor.systemBlue
        let highlightedAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: highlightColor]
        
        attributedText.addAttributes(highlightedAttributes, range: range) 
        self.attributedText = attributedText
    }
    
    func setStrikeThroughText(_ text: String) {
        let attributeString = NSMutableAttributedString(string: text)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
        self.attributedText = attributeString
    }
}
