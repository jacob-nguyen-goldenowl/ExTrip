//
//  PriceTableViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 04/01/2023.
//

import UIKit
import AORangeSlider

struct Price {
    var maximun: Double
    var minimun: Double
}

class PriceTableViewCell: FilterTableViewCell {

    static let identifier = "PriceTableViewCell"

    var value: Price = Price(maximun: 1000.0, minimun: 0.0) {
        didSet {
            showValue.text = "US $\(value.minimun) - US $\(value.maximun)"
        }
    }
    
    var priceValue: ((Price) -> Void)?
    
    var rangePrice: Price? {
        didSet {
            initialValue()
        }
    }
    
    let thumbImage = UIImage(named: "thumb")?.resized(to: CGSize(width: 27, height: 27))

    private lazy var rangeSlider: AORangeSlider = {
        let slider = AORangeSlider()
        slider.minimumValue = 0
        slider.maximumValue = 1000
        slider.trackColor = UIColor.theme.primary
        slider.highHandleImageNormal = thumbImage
        slider.lowHandleImageNormal = thumbImage
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
        rangeSlider.setValue(low: rangePrice?.minimun ?? 0.0,
                             high: rangePrice?.maximun ?? 1000.0,
                             animated: false)
        showValue.text = "US $\(value.minimun) - US $\(value.maximun)"
    }

    private func setupInit() {
        contentView.addSubview(rangeSlider)
        addSubviews(headerTitle,
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
        
        rangeSlider.center(centerY: contentView.centerYAnchor)
        rangeSlider.anchor(leading: contentView.leadingAnchor,
                           trailing: contentView.trailingAnchor,
                           paddingLeading: padding,
                           paddingTrailing: padding)
        rangeSlider.setHeight(height: 30)
        
        showValue.anchor(top: topAnchor, 
                         trailing: trailingAnchor,
                         paddingTop: paddingTop,
                         paddingTrailing: padding)
    }
}

extension PriceTableViewCell {
    @objc func handleSliderAction(_ slider: AORangeSlider) {
        let priceMinimun = round(slider.lowValue * 10) / 10.0
        let priceMaximun = round(slider.highValue * 10) / 10.0
        value.minimun = priceMinimun
        value.maximun = priceMaximun
        priceValue?(Price(maximun: priceMaximun,
                          minimun: priceMinimun))
    }
}
