//
//  ConfirmPriceTableViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 28/02/2023.
//

import UIKit

class ConfirmPriceTableViewCell: ETConfirmTableViewCell {
    
    static let identifier = "ConfirmPriceTableViewCell"
    
        // Check In
    private lazy var priceLabel = ETLabel(style: .small, size: 13)
    private lazy var checkInStackView = setupHorizontalStackView(title: "Price", info: priceLabel)
    
        // Check Out
    private lazy var taxesLabel = ETLabel(style: .small, size: 13)
    private lazy var checkOutStackView = setupHorizontalStackView(title: "Service(Taxes & fees):", info: taxesLabel)
    
    private lazy var timeVerticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [checkInStackView, checkOutStackView])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var totalPriceLabel = ETLabel(style: .large, size: 13)
    private lazy var totalPriceStackView = setupHorizontalStackView(title: "Total", info: totalPriceLabel)
    
        // MARK: - INIT
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubViews() {
        addSubviews(timeVerticalStackView,
                    separatorView,
                    totalPriceStackView)
        setupConstraintSubViews()   
    }
    
        // MARK: - Constraints
    private func setupConstraintSubViews() {
        
        timeVerticalStackView.anchor(top: topAnchor,
                                     leading: leadingAnchor,
                                     trailing: trailingAnchor,
                                     paddingTop: padding,
                                     paddingBottom: padding,
                                     paddingLeading: padding,
                                     paddingTrailing: padding)
        timeVerticalStackView.setHeight(height: 70)
        
        separatorView.anchor(top: timeVerticalStackView.bottomAnchor,
                             leading: leadingAnchor,
                             trailing: trailingAnchor,
                             paddingTop: padding, 
                             paddingBottom: padding)
        separatorView.setHeight(height: 1.0)
        separatorView.backgroundColor = .tertiarySystemFill
        
        totalPriceStackView.anchor(top: separatorView.bottomAnchor,
                                   bottom: bottomAnchor,
                                   leading: leadingAnchor,
                                   trailing: trailingAnchor,
                                   paddingTop: padding,
                                   paddingBottom: padding,
                                   paddingLeading: padding,
                                   paddingTrailing: padding)
        
        priceLabel.text = "USD 240.00"
        taxesLabel.text = "USD 80.00"
        totalPriceLabel.text = "USD 320.00"
    }
    
    func setDataForPriceRoom(roomCharge: Double?, taxes: Double?) {
        if let roomCharge = roomCharge, let taxes = taxes {
            priceLabel.text = "$ \(roomCharge.roundDouble())"
            taxesLabel.text = "$ \(taxes.roundDouble())"
            let totalPrice = calculatorTotalPrice(roomCharge: roomCharge, taxes: taxes)
            totalPriceLabel.text = "$ \(totalPrice.roundDouble())"
        } else {
            priceLabel.text = "$ 0.00"
            taxesLabel.text = "$ 0.00"
            totalPriceLabel.text = "$ 0.00"
        }
    }
    
    private func calculatorTotalPrice(roomCharge: Double, taxes: Double) -> Double {
        return roomCharge + taxes
    }
}
