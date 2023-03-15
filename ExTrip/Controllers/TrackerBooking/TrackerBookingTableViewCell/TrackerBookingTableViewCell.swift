//
//  ActiveTableViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 14/03/2023.
//

import UIKit

protocol TrackerBookingTableViewCellDelegate: AnyObject {
    func trackerBookingTableViewCellHandleCancelBooking(_ cell: TrackerBookingTableViewCell)
}

class TrackerBookingTableViewCell: UITableViewCell {

    static let identifier = "TrackerBookingTableViewCell"
    
    weak var delegate: TrackerBookingTableViewCellDelegate? 
    
    let padding: CGFloat = 10
    
    private lazy var bookingImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.sizeToFit()
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "logo")
        return imageView
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = .poppins(style: .bold, size: 12)
        button.addTarget(self, action: #selector(handleCancelBookingAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.theme.tertiarySystemFill
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var arrivalDate = ETLabel(style: .medium, textAlignment: .left, size: 13)
    private lazy var departureDate = ETLabel(style: .medium, textAlignment: .left, size: 13)
    private lazy var roomChargeLabel = ETLabel(style: .large, textAlignment: .left)
    private lazy var roomNumberLabel = ETLabel(style: .large, textAlignment: .left, size: 11)
    
    private lazy var containerDateStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [arrivalDate, departureDate])
        stackView.distribution = .fillEqually
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
        contentView.addSubviews(containerView)
        containerView.addSubviews(containerDateStackView,
                                  cancelButton, 
                                  roomChargeLabel,
                                  bookingImageView, 
                                  roomNumberLabel)
        setupConstraintSubViews()
    }
    
    // MARK: - Constraints
    private func setupConstraintSubViews() {
        let buttonSize: CGSize = CGSize(width: 58, height: 28)
        let imageSize: CGFloat = 30
                    
        containerView.fillAnchor(contentView, padding: padding)
        
        roomChargeLabel.anchor(top: containerView.topAnchor,
                               leading: containerView.leadingAnchor,
                               trailing: cancelButton.leadingAnchor, 
                               paddingTop: padding,
                               paddingLeading: padding,
                               paddingTrailing: padding)
        roomChargeLabel.setHeight(height: 30)
        
        cancelButton.anchor(top: containerView.topAnchor, 
                            trailing: containerView.trailingAnchor, 
                            paddingTop: padding,
                            paddingTrailing: padding)
        cancelButton.setHeight(height: buttonSize.height)
        cancelButton.setWidth(width: buttonSize.width)
        cancelButton.layer.cornerRadius = buttonSize.height/2
        
        containerDateStackView.anchor(top: roomChargeLabel.bottomAnchor,
                                      leading: containerView.leadingAnchor,
                                      trailing: containerView.trailingAnchor, 
                                      paddingLeading: padding,
                                      paddingTrailing: padding)
        
        bookingImageView.anchor(top: containerDateStackView.bottomAnchor,
                                leading: containerView.leadingAnchor, 
                                paddingLeading: padding)
        bookingImageView.setHeight(height: imageSize)
        bookingImageView.setWidth(width: imageSize)
        bookingImageView.layer.cornerRadius = imageSize/2
        
        roomNumberLabel.anchor(top: containerDateStackView.bottomAnchor,
                               bottom: containerView.bottomAnchor,
                               leading: bookingImageView.trailingAnchor, 
                               trailing: containerView.trailingAnchor,
                               paddingBottom: padding,
                               paddingLeading: padding)
    }
    
    func setupDataTrackerBooking(booking: BookingCellViewModel) {
        arrivalDate.text = "Check-in: " + booking.arrivaleDate
        departureDate.text = "Check-out: " + booking.departureDate
        roomChargeLabel.text = "Total: \(booking.roomChange)"
        roomNumberLabel.text = "\(booking.numberOfRoom) rooms"
    }

    @objc func handleCancelBookingAction() {
        delegate?.trackerBookingTableViewCellHandleCancelBooking(self)
    }
    
}
