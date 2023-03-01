//
//  ConfirmHotelTableViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 28/02/2023.
//

import UIKit

class ConfirmHotelTableViewCell: ETConfirmTableViewCell {

    static let identifier = "ConfirmHotelTableViewCell"

    // Check In
    private lazy var checkInTimeLabel = ETLabel(style: .small, size: 13)
    private lazy var checkInStackView = setupHorizontalStackView(title: "Check-in:", info: checkInTimeLabel)
    
    // Check Out
    private lazy var checkOutTimeLabel = ETLabel(style: .small, size: 13)
    private lazy var checkOutStackView = setupHorizontalStackView(title: "Check-out:", info: checkOutTimeLabel)
    
    private lazy var timeVerticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [checkInStackView, checkOutStackView])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
        
    // MARK: - INIT
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubViews() {
        addSubviews(posterImageView,
                    titleLabel, 
                    descriptionLabel, 
                    refuldLabel,
                    separatorView,
                    timeVerticalStackView)
        setupConstraintSubViews()   
    }
    
        // MARK: - Constraints
    private func setupConstraintSubViews() {
        
        posterImageView.anchor(top: topAnchor,
                               trailing: trailingAnchor,
                               paddingTop: paddingSize,
                               paddingBottom: paddingSize,
                               paddingTrailing: paddingSize)
        posterImageView.layer.cornerRadius = 5
        posterImageView.setHeight(height: 70)
        posterImageView.setWidth(width: 70)
        
        titleLabel.anchor(top: topAnchor, 
                          leading: leadingAnchor, 
                          trailing: posterImageView.leadingAnchor,
                          paddingTop: padding,
                          paddingLeading: padding,
                          paddingTrailing: paddingSize)
        
        refuldLabel.anchor(top: titleLabel.bottomAnchor, 
                           leading: leadingAnchor, 
                           trailing: posterImageView.leadingAnchor,
                           paddingTop: paddingTop,
                           paddingLeading: padding,
                           paddingTrailing: paddingSize)   
        
        descriptionLabel.anchor(top: refuldLabel.bottomAnchor,
                                leading: leadingAnchor, 
                                trailing: posterImageView.leadingAnchor,
                                paddingTop: paddingTop,
                                paddingBottom: paddingSize,
                                paddingLeading: padding,
                                paddingTrailing: paddingSize)
        
        separatorView.anchor(top: descriptionLabel.bottomAnchor,
                             leading: leadingAnchor,
                             trailing: trailingAnchor,
                             paddingTop: padding + paddingTop, 
                             paddingBottom: padding)
        separatorView.setHeight(height: 1.0)
        separatorView.backgroundColor = .tertiarySystemFill
        
        timeVerticalStackView.anchor(top: separatorView.bottomAnchor,
                                     bottom: bottomAnchor,
                                     leading: leadingAnchor,
                                     trailing: trailingAnchor,
                                     paddingTop: padding,
                                     paddingBottom: padding,
                                     paddingLeading: padding,
                                     paddingTrailing: padding)
    }
    
    func setDataForBookingHotel(_ room: RoomModel, arrivalDate: Date, departureDate: Date) {
        posterImageView.loadImage(url: room.image[0])
        titleLabel.text = room.type.capitalizeFirstLetter()
        refuldLabel.text = "Non-refulable"
        descriptionLabel.text = "\(room.description?.bedroom ?? 1) Bedroom"
        checkInTimeLabel.text = arrivalDate.displayDateString
        checkOutTimeLabel.text = departureDate.displayDateString
    }
}
