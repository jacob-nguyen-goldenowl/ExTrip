//
//  PaymentTableViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 23/02/2023.
//

import UIKit

class PaymentTableViewCell: UITableViewCell {
    
    static let identifier = "PaymentTableViewCell"
    let padding: CGFloat = 10
    var rightTitle: String? {
        didSet {
            paymentDefaultLabel.text = rightTitle
            setupDefaulLabel()
        }
    }
    
    var paymentTitle: String? {
        didSet {
            paymentNameLabel.text = paymentTitle?.capitalizeFirstLetter()
        }
    }
    
    lazy var paymentNameLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(style: .bold, size: 14)
        label.numberOfLines = 0
        label.textColor = .label
        return label
    }()
    
    lazy var paymentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "background")
        return imageView
    }()
    
    lazy var paymentDefaultLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(style: .bold, size: 11)
        label.textColor = UIColor.theme.primary
        label.textAlignment = .right
        return label
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 5
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        setupViews()
        setupLayouts()
    }
    
    func setupViews() {
        addSubviews(containerView,
                    paymentNameLabel)
        containerView.addSubview(paymentImageView)
    }
    
    func setupLayouts() {
        containerView.anchor(top: topAnchor,
                                bottom: bottomAnchor,
                                leading: leadingAnchor,
                                paddingTop: padding,
                                paddingBottom: padding,
                                paddingLeading: padding)
        containerView.setWidth(width: 50)
        
        paymentImageView.fillAnchor(containerView)

        paymentNameLabel.text = "Paypal"
        paymentNameLabel.anchor(top: topAnchor, 
                                bottom: bottomAnchor, 
                                leading: paymentImageView.trailingAnchor, 
                                trailing: trailingAnchor,
                                paddingTop: padding, 
                                paddingBottom: padding,
                                paddingLeading: padding,
                                paddingTrailing: padding)
    }
    
    private func setupDefaulLabel() {
        addSubview(paymentDefaultLabel)
        paymentDefaultLabel.anchor(top: topAnchor,
                                   bottom: bottomAnchor,
                                   trailing: trailingAnchor, 
                                   paddingTop: padding,
                                   paddingBottom: padding,
                                   paddingTrailing: padding)
    }

}
