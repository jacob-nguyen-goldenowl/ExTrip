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
    
    let padding: CGFloat = 8
    
    var bookingID: String?
    var hotelID: String?
    
    var bookingStatus: String = "active" {
        didSet {
            shouldCancelButton()
        }
    }
    
    private lazy var bookingImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.sizeToFit()
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "logo")
        return imageView
    }()
    
    private lazy var bookingButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .poppins(style: .bold, size: 12)
        button.addTarget(self, action: #selector(handleCancelBookingAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemFill
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
                                  bookingButton, 
                                  roomChargeLabel,
                                  bookingImageView, 
                                  roomNumberLabel)
        setupConstraintSubViews()
    }
    
    // MARK: - Constraints
    private func setupConstraintSubViews() {
        let buttonSize: CGSize = CGSize(width: 62, height: 28)
        let imageSize: CGFloat = 30
                    
        containerView.fillAnchor(contentView, padding: padding)
        
        roomChargeLabel.anchor(top: containerView.topAnchor,
                               leading: containerView.leadingAnchor,
                               trailing: bookingButton.leadingAnchor, 
                               paddingTop: padding,
                               paddingLeading: padding,
                               paddingTrailing: padding)
        roomChargeLabel.setHeight(height: 30)
        
        bookingButton.anchor(top: containerView.topAnchor, 
                             trailing: containerView.trailingAnchor, 
                             paddingTop: padding,
                             paddingTrailing: padding)
        bookingButton.setHeight(height: buttonSize.height)
        bookingButton.setWidth(width: buttonSize.width)
        bookingButton.layer.cornerRadius = buttonSize.height/2
        
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
    
    private func shouldCancelButton() {
        if bookingStatus == "active" {
            bookingButton.setTitle("Cancel", for: .normal)
            bookingButton.backgroundColor = .red
        } else {
            bookingButton.backgroundColor = .blue
            bookingButton.setTitle("Booking", for: .normal)
        }
    }
    
    func setupDataTrackerBooking(booking: TrackerBookingModel) {
        bookingStatus = booking.status 
        bookingID = booking.id
        arrivalDate.text = "Check-in: " + booking.arrivaleDate
        departureDate.text = "Check-out: " + booking.departureDate
        roomChargeLabel.text = "Total: \(booking.roomChange.convertDoubleToCurrency())"
        roomNumberLabel.text = "\(booking.numberOfRoom) rooms"
    }

    @objc func handleCancelBookingAction() {
        delegate?.trackerBookingTableViewCellHandleCancelBooking(self)
    }
    
}
