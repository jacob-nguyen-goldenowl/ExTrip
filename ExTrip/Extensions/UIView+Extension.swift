//
//  UIView+Extension.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 08/12/2022.
//

import UIKit

extension UIView {
    
    // MARK: - Constraint anchor 
    func anchor (top: NSLayoutYAxisAnchor? = nil,
                 bottom: NSLayoutYAxisAnchor? = nil,
                 leading: NSLayoutXAxisAnchor? = nil,
                 trailing: NSLayoutXAxisAnchor? = nil,
                 paddingTop: CGFloat = 0.0,
                 paddingBottom: CGFloat = 0.0,
                 paddingLeading: CGFloat = 0.0,
                 paddingTrailing: CGFloat = 0.0 
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: paddingLeading).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -paddingTrailing).isActive = true
        }
    }
    
    // MARK: - Setup fill constraints
    func fillAnchor(_ view: UIView, padding: CGFloat = 0.0) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor, constant: padding).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
    }
    
    // MARK: - Setup width + height
    func setWidth(width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func setHeight(height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    // MARK: - Setup center X & Y
    func center(centerX: NSLayoutXAxisAnchor? = nil,
                centerY: NSLayoutYAxisAnchor? = nil,
                paddingX: CGFloat = 0.0,
                paddingY: CGFloat = 0.0
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        if let centerX = centerX {
            centerXAnchor.constraint(equalTo: centerX, constant: paddingX).isActive = true
        }
        if let centerY = centerY {
            centerYAnchor.constraint(equalTo: centerY, constant: paddingY).isActive = true
        }
    }
    
    func addSubviews(_ views: UIView...) {
        views.forEach(addSubview(_:))
    }
    
    // MARK: - Corner radius
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func removeAllFromSubView(_ view: [UIView]) {
        view.forEach { $0.removeFromSuperview() }
    }
    
}
