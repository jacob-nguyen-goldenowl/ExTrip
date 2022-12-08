//
//  ETGradientButton.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 08/12/2022.
//

import UIKit

final class ETGradientButton: UIButton {
        
    // MARK: - Properties
    let gradientLayer = CAGradientLayer()

    var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.clipsToBounds = true
        }
    }
    
    var topColor: UIColor? {
        didSet {
            setGradient(topColor: topColor, bottomColor: bottomColor)
        }
    }
    
    var bottomColor: UIColor? {
        didSet {
            setGradient(topColor: topColor, bottomColor: bottomColor)
        }
    }
    
    var titleColor: UIColor? {
        didSet {
            self.setTitleColor(titleColor, for: .normal)
        }
    }

    // MARK: - Initialization 
    required init(title: ETButtonTitle,
                  style: ETButtonType,
                  backgroundColor: UIColor? = nil,
                  titleColor: UIColor? = nil
    ) {   
        super.init(frame: .zero)
        setupStyleButton(title: title,
                         style: style,
                         backgroundColor: backgroundColor,
                         titleColor: titleColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set gradient for button
    private func setGradient(topColor: UIColor?, bottomColor: UIColor?) {
        if let topColor = topColor,
           let bottomColor = bottomColor {
            gradientLayer.frame = bounds
            gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
            gradientLayer.borderColor = layer.borderColor
            gradientLayer.borderWidth = layer.borderWidth
            gradientLayer.cornerRadius = layer.cornerRadius
            layer.insertSublayer(gradientLayer, at: 0)
        } else {
            gradientLayer.removeFromSuperlayer()
        }
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        gradientLayer.frame = bounds
    }
    
    // MARK: - Setup style for button 
    private func setupStyleButton(title: ETButtonTitle,
                                  style: ETButtonType,
                                  backgroundColor: UIColor?,
                                  titleColor: UIColor?
    ) {
        let titleUpcase = title.rawValue.uppercased()
        setTitle(titleUpcase, for: .normal)
        titleLabel?.font = UIFont.poppins(style: .regular)
        cornerRadius = 20
        self.titleColor = UIColor.theme.white ?? .white
        switch style {
            case .small: 
                setTitle(title.rawValue, for: .normal)
                titleLabel?.font = UIFont.poppins(style: .regular)
            case .nomal:
                setTitle(title.rawValue, for: .normal)
                self.backgroundColor = backgroundColor ?? .white
                self.titleColor = titleColor ?? .black
            case .mysticBlue:
                topColor = UIColor.theme.lightBlue
                bottomColor = UIColor.theme.lightGreen
            case .dreamyPurple:
                topColor = UIColor.theme.serenade
                bottomColor = UIColor.theme.violet
        }
    }
    
}
