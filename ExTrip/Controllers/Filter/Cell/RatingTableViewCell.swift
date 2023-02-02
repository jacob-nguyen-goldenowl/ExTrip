//
//  RatingTableViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 05/01/2023.
//

import UIKit

class RatingTableViewCell: FilterTableViewCell {
    
    static let identifier = "RatingTableViewCell"
    
    let thumbImage = UIImage(named: "thumb")?.resized(to: CGSize(width: 27, height: 27))

    private lazy var slider: ETHeightSlider = {
        let slider = ETHeightSlider()
        slider.minimumValue = 0
        slider.maximumValue = 10
        slider.tintColor = UIColor.theme.primary
        slider.setThumbImage(thumbImage, for: .normal)
        return slider
    }()
    
    var value: Float = 0.0 {
        didSet {
            showValue.text = "\(value) +"
        }
    }
    
    var ratingValue: Float = 0.0 {
        didSet {
            initialValue()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubViews() {
        addSubviews(headerTitle,
                    slider,
                    showValue)
        slider.addTarget(self, action: #selector(handleSliderAction(_:)), for: .valueChanged)
        setupConstraintSubViews()
    }
    
    func initialValue() {
        showValue.text = "\(ratingValue) +"
        slider.setValue(ratingValue, animated: false)
    }
    
    private func setupConstraintSubViews() {
        let padding: CGFloat = 30
        let paddingTop: CGFloat = 8
        headerTitle.anchor(top: topAnchor,
                           leading: leadingAnchor,
                           paddingTop: paddingTop,
                           paddingLeading: padding)
        headerTitle.setHeight(height: 20)
        
        slider.anchor(leading: leadingAnchor,
                      trailing: trailingAnchor,
                      paddingTop: paddingTop,
                      paddingLeading: padding,
                      paddingTrailing: padding)
        slider.center(centerY: centerYAnchor)
        
        showValue.anchor(top: topAnchor,
                         trailing: trailingAnchor,
                         paddingTop: paddingTop,
                         paddingTrailing: padding)
    }
}

extension RatingTableViewCell {
    @objc func handleSliderAction(_ slider: UISlider) {
        let roundValue = round(slider.value * 10) / 10.0
        self.value = roundValue
        currentValue?(Double(roundValue))
    }
}
