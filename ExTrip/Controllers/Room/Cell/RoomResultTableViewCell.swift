//
//  RoomTableViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 15/02/2023.
//

import UIKit

protocol RoomResultTableViewCellDelegate: AnyObject {
    func roomSelectTableViewCellhandleBookNavigation(_ data: RoomResultTableViewCell) 
}

class RoomResultTableViewCell: ETTableViewCell {

    static let identifier = "RoomTableViewCell"
    
    weak var delegate: RoomResultTableViewCellDelegate?
    
    var room: RoomModel?
    
    private let padding: CGFloat = 15
    private let paddingTop: CGFloat = 5
    private let paddingSize: CGFloat = 10
    private let buttonSize: CGFloat = 25
    
    private let locationImage = UIImage(named: "clock")

    private lazy var boxView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.theme.tertiarySystemFill
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.layer.borderWidth = 0.8
        view.layer.borderColor = primaryColor.cgColor
        return view
    }()
    
    private lazy var paymentMethodLabel = ETLabel(style: .medium, textAlignment: .left)
    private lazy var refuldLabel = ETLabel(style: .small, textAlignment: .left)
    private lazy var roomSizeLabel = ETLabel(style: .nomal)
    private lazy var occupancyLabel  = ETLabel(style: .nomal)
    private lazy var numberOfBedLabel  = ETLabel(style: .nomal)
    private lazy var afftercashbackLabel  = ETLabel(style: .small)
    
    private lazy var roomDetailHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = primaryColor.cgColor
        stackView.distribution = .fillEqually
        stackView.backgroundColor = primaryColor
        stackView.spacing = 0.5
        return stackView
    }()
                                                        
    private lazy var roomPriceVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // MARK: BUTTON    
    private lazy var bookButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.theme.white, for: .normal)
        button.titleLabel?.font = .poppins(style: .bold, size: 12)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        button.setTitle("Book", for: .normal)
        return button
    }()
    
    // MARK: - INIT
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubViews()
        setupAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubViews() {
        contentView.addSubview(boxView)
        boxView.addSubviews(posterImageView,
                            titleLabel, 
                            paymentMethodLabel, 
                            refuldLabel,
                            roomDetailHorizontalStackView,
                            roomPriceVerticalStackView,
                            bookButton)
        setupHorizontalStackView()
        setupVeticalStackView()
        setupConstraintSubViews()   
    }
    
    // MARK: - Constraints
    private func setupConstraintSubViews() {
        boxView.fillAnchor(contentView, padding: padding) 
        
        posterImageView.anchor(top: boxView.topAnchor,
                               trailing: boxView.trailingAnchor,
                               paddingTop: paddingSize,
                               paddingBottom: paddingSize,
                               paddingTrailing: paddingSize)
        posterImageView.layer.cornerRadius = 5
        posterImageView.setHeight(height: 70)
        posterImageView.setWidth(width: 70)
        
        titleLabel.anchor(top: boxView.topAnchor, 
                          leading: boxView.leadingAnchor, 
                          trailing: posterImageView.leadingAnchor,
                          paddingTop: padding,
                          paddingLeading: padding,
                          paddingTrailing: paddingSize)
        
        refuldLabel.anchor(top: titleLabel.bottomAnchor, 
                           leading: boxView.leadingAnchor, 
                           trailing: posterImageView.leadingAnchor,
                           paddingTop: paddingTop,
                           paddingLeading: padding,
                           paddingTrailing: paddingSize)  
        
        paymentMethodLabel.anchor(top: refuldLabel.bottomAnchor, 
                                  leading: boxView.leadingAnchor, 
                                  trailing: posterImageView.leadingAnchor,
                                  paddingTop: paddingTop,
                                  paddingBottom: paddingSize,
                                  paddingLeading: padding,
                                  paddingTrailing: paddingSize)
        
        roomDetailHorizontalStackView.anchor(top: posterImageView.bottomAnchor,
                                   leading: boxView.leadingAnchor, 
                                   trailing: boxView.trailingAnchor,
                                   paddingTop: paddingSize,
                                   paddingBottom: paddingSize) 
        roomDetailHorizontalStackView.setHeight(height: 30)
        
        roomPriceVerticalStackView.anchor(top: roomDetailHorizontalStackView.bottomAnchor,
                                 trailing: boxView.trailingAnchor,
                                 paddingTop: paddingTop,
                                 paddingTrailing: padding)
        
        bookButton.anchor(top: roomPriceVerticalStackView.bottomAnchor,
                          bottom: boxView.bottomAnchor,
                          leading: boxView.leadingAnchor,
                          trailing: boxView.trailingAnchor,
                          paddingTop: paddingTop,
                          paddingBottom: paddingSize, 
                          paddingLeading: buttonSize,
                          paddingTrailing: buttonSize)  
    }
    
    private func setupHorizontalStackView() {
        roomDetailHorizontalStackView.removeAllArrangedSubviews()
        roomDetailHorizontalStackView.addArrangedSubviews(roomSizeLabel,
                                                occupancyLabel,
                                                numberOfBedLabel)
    }
    
    private func setupVeticalStackView() {
        roomPriceVerticalStackView.removeAllArrangedSubviews()
        roomPriceVerticalStackView.addArrangedSubviews(defaultPriceLabel,
                                              afftercashbackLabel,
                                              priceLabel)
        defaultPriceLabel.textColor = .red
        defaultPriceLabel.textAlignment = .right
        priceLabel.textAlignment = .right
    }

    private func setupAction() {
        bookButton.addTarget(self, action: #selector(handleBookButton), for: .touchUpInside)
    }
    
    func getDataForRoom(room: RoomModel) {
        self.room = room
        posterImageView.loadImage(url: room.image.first ?? "")
        titleLabel.text = room.type.capitalizeFirstLetter()
        refuldLabel.text = "Non-refulable"
        paymentMethodLabel.text = "Booking without credit card"
        roomSizeLabel.setSuperScripts(bigText: "\(room.roomSize)m", smallText: "2")
        occupancyLabel.text = "Max \(room.occupancy) adults"
        numberOfBedLabel.text = "\(room.description?.bed ?? 1) Bed"
        defaultPriceLabel.setStrikeThroughText("$\(room.defaultPrice)")
        afftercashbackLabel.text = "Affter Cashback"
        priceLabel.text = "$\(room.price)"
    }
    
}

extension RoomResultTableViewCell {
    @objc func handleBookButton() {
        delegate?.roomSelectTableViewCellhandleBookNavigation(self)
    }
}
