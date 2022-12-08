//
//  UIStackView+Extension.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 08/12/2022.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach(addArrangedSubview(_:))
    }
}

