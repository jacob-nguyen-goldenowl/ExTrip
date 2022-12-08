//
//  UIFont+Extension.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 08/12/2022.
//

import UIKit

extension UIFont {
    
    enum FontStyle {
        case light
        case medium
        case regular 
        case thin
        case bold
        case extra
        
        func getFontName() -> String {
            switch self {
                case .light:
                    return "Poppins-Light"
                case .medium:
                    return "Poppins-Medium"
                case .regular:
                    return "Poppins-Regular"
                case .thin:
                    return "Poppins-Thin"
                case .bold:
                    return "Poppins-Bold"
                case .extra:
                    return "Poppins-ExtraBoldItalic"
            }
        }
        
        func getFontSize() -> CGFloat {
            switch self {
                case .light, .regular: 
                    return 13
                case .medium: 
                    return 16.0
                case .thin:
                    return 13.0
                case .bold:
                    return 22.0
                case .extra:
                    return 45
            }
        }
    }
    
    static func poppins(style: FontStyle, size: CGFloat? = nil)  -> UIFont {
        return UIFont(name: style.getFontName(), size: size ?? style.getFontSize()) ?? UIFont.boldSystemFont(ofSize: 18)
    }
    
}
