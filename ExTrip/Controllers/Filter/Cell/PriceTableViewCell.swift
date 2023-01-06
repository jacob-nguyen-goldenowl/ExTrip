//
//  PriceTableViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 04/01/2023.
//

import UIKit

struct Price {
    var maximun: Float
    var minimun: Float
}

class PriceTableViewCell: FilterTableViewCell {

    static let identifier = "PriceTableViewCell"

    var value: Price = Price(maximun: 1000.0, minimun: 0.0) {
        didSet {
            showValue.text = "US $\(value.minimun) - US $\(value.maximun)"
        }
    }
    
    private lazy var doubledSlider: DoubledSlider = {
        let slider = DoubledSlider()
        slider.minimumValue = 0.0
        slider.maximumValue = 1000.0
        slider.addTarget(self, action: #selector(handleSliderAction(_:)), for: .valueChanged)
        return slider
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupInit()
        initialValue()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialValue() {
        showValue.text = "US $\(value.minimun) - US $\(value.maximun)"
    }

    private func setupInit() {
        addSubviews(doubledSlider, 
                    headerTitle,
                    showValue)
        setupConstraintSubView()
    }
    
    private func setupConstraintSubView() {
        let padding: CGFloat = 30
        let paddingTop: CGFloat = 8
        headerTitle.anchor(top: topAnchor,
                           leading: leadingAnchor,
                           paddingTop: paddingTop,
                           paddingLeading: padding)
        headerTitle.setHeight(height: 20)
        
        doubledSlider.center(centerY: centerYAnchor)
        doubledSlider.anchor(leading: leadingAnchor,
                             trailing: trailingAnchor,
                             paddingLeading: padding,
                             paddingTrailing: padding)
        
        showValue.anchor(top: topAnchor, 
                         trailing: trailingAnchor,
                         paddingTop: paddingTop,
                         paddingTrailing: padding)
    }
}

extension PriceTableViewCell {
    @objc func handleSliderAction(_ slider: DoubledSlider) {
        let priceMinimun = round(slider.values.minimum * 10) / 10.0
        let priceMaximun = round(slider.values.maximum * 10) / 10.0
        value.minimun = priceMinimun
        value.maximun = priceMaximun
    }
}
