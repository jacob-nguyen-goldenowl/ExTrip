//
//  RoomTableViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 15/02/2023.
//

import UIKit

class RoomTableViewCell: UITableViewCell {
    
    static let identifier = "RoomTableViewCell"
    
    var indexPath: IndexPath?
    
    var quantityGuests: Int = 0 {
        didSet {
            quantityLabel.text = "\(quantityGuests)"
        }
    }
    
    public var getValue: ((Int?) -> Void)?
    
    var title: String? {
        didSet {
            if let text = title, !text.isEmpty {
                titleLabel.text = text
            } else {
                titleLabel.text = nil
            }
        }
    }
    var subTitle: String? {
        didSet {
            if let text = subTitle, !text.isEmpty {
                subtitleLabel.text = text
            } else {
                subtitleLabel.text = nil
            }
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(style: .medium, size: 15)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(style: .light, size: 13)
        return label
    }()
    
    private lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "0"
        label.font = .poppins(style: .medium)
        return label
    }()
    
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var decrementButton = configureButton("minus", color: UIColor.theme.lightBlue)
    private lazy var incrementButton = configureButton("plus", color: UIColor.theme.lightBlue)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubViews()
        setupActionButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubViews() {
        addSubviews(titleLabel,
                    subtitleLabel)
        contentView.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubviews(decrementButton,
                                                quantityLabel,
                                                incrementButton)
        
        setupConstraintSubViews()
    }
    
    private func setupConstraintSubViews() {
        let padding: CGFloat = 10
        
        titleLabel.center(centerY: centerYAnchor,
                          paddingY: -padding)
        
        subtitleLabel.anchor(top: titleLabel.bottomAnchor,
                             leading: leadingAnchor)
        
        horizontalStackView.center(centerY: contentView.centerYAnchor)
        horizontalStackView.anchor(trailing: contentView.trailingAnchor,
                                   paddingTrailing: 10)
        horizontalStackView.setHeight(height: frame.size.height)
        horizontalStackView.setWidth(width: frame.size.width / 2.5)
    }
    
    private func configureButton(_ nameImage: String, color: UIColor?) -> UIButton {
        let button = UIButton()
        let minusImage = UIImage(named: nameImage)
        let tintedImage = minusImage?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = color ?? .blue
        return button
    }
    
    private func setupActionButton() {
        decrementButton.addTarget(self, action: #selector(handleDecrementAction), for: .touchUpInside)
        incrementButton.addTarget(self, action: #selector(handleIncrementAction), for: .touchUpInside)
    }
    
    private func setupDecrementQuantity() {
        guard let row = indexPath?.row else { return }
        if row == 0 || row == 1 {
            checkQuantity(1)
        } else {
            checkQuantity(0)
        }
    }
    
    private func checkQuantity(_ number: Int) {
        if quantityGuests <= number {
            quantityGuests = number
        } else {
            quantityGuests = quantityGuests - 1
        }
    }
}

extension RoomTableViewCell {
    @objc func handleDecrementAction() {
        setupDecrementQuantity()
        getValue?(quantityGuests)
    }   
    
    @objc func handleIncrementAction() {
        quantityGuests = quantityGuests + 1
        getValue?(quantityGuests)
    }
}
