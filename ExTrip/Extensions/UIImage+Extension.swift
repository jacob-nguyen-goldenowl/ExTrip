//
//  UIImage+Extension.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 02/02/2023.
//

import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

extension UIImageView {
    func changeColorImage(image: UIImage?, color: UIColor) {
        let image = image?.withRenderingMode(.alwaysTemplate)
        self.image = image
        self.tintColor = color
    }
}

