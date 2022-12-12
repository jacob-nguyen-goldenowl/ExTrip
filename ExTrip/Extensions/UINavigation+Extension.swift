//
//  UINavigation+Extension.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 09/12/2022.
//

import UIKit

extension UINavigationController {
    
    func configBackButton() {
        let backImage = UIImage(named: "back")
        let nav = self.navigationBar
        nav.backIndicatorImage = backImage
        nav.backIndicatorTransitionMaskImage = backImage
        nav.tintColor = .gray
        nav.topItem?.backButtonTitle = ""
        nav.titleTextAttributes = [NSAttributedString.Key.font: UIFont.poppins(style: .bold)]
    }
}
