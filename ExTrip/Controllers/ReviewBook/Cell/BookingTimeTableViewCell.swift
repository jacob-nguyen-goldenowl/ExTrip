//
//  TimeTableViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 17/02/2023.
//

import UIKit

class BookingTimeTableViewCell: ETTableViewCell {

    static let identifier = "BookingTimeTableViewCell"
    
    private let padding: CGFloat = 10
    private let paddingBorder: CGFloat = 30
    private let rightImage = UIImage(named: "right")
    
    var infoBooking: HotelBookingModel? {
        didSet {
            if let room = infoBooking?.room, let time = infoBooking?.date as? FastisRange {
                checkInTimeLabel.text = time.fromDate.displayMonthString
                checkOutTimeLabel.text = time.toDate.displayMonthString
                guestInfoLabel.text = "\(room.numberOfGuest(adults: room.adults, children: room.children, infants: room.infants))"
            }
            setupConstraintSubView()
        }
    }
    
    var numberOfRoom: Int = 1 {
        didSet {
            roomNumberLabel.text = "\(numberOfRoom)"
        }
    }
    
    private lazy var boxView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 0.8
        view.layer.borderColor = UIColor.theme.tertiarySystemFill?.cgColor
        return view
    }()
    
    private lazy var checkInLabel = ETLabel(style: .small)
    private lazy var checkInTimeLabel = ETLabel(style: .large)
    
    private lazy var checkOutLabel = ETLabel(style: .small)
    private lazy var checkOutTimeLabel = ETLabel(style: .large)

    private lazy var guestLabel = ETLabel(style: .small)
    private lazy var guestInfoLabel = ETLabel(style: .large)
    
    private lazy var roomLabel = ETLabel(style: .small)
    private lazy var roomNumberLabel = ETLabel(style: .large)
    
    private lazy var rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.sizeToFit()
        imageView.contentMode = .scaleAspectFit
        imageView.changeColorImage(image: rightImage, color: lightGrayColor)
        return imageView
    }()
    
    private lazy var checkInTimeStackView = setupVerticalStackView(title: checkInLabel, info: checkInTimeLabel)
    private lazy var checkOutTimeStackView = setupVerticalStackView(title: checkOutLabel, info: checkOutTimeLabel)
    private lazy var guestStackView = setupVerticalStackView(title: guestLabel, info: guestInfoLabel)
    private lazy var roomStackView = setupVerticalStackView(title: roomLabel, info: roomNumberLabel)
    
        // MARK: - INIT
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubView()
        setupTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubView() {
        addSubview(boxView) 
        boxView.addSubviews(rightImageView,
                            checkInTimeStackView, 
                            checkOutTimeStackView, 
                            guestStackView, 
                            roomStackView)
        boxView.fillAnchor(self, padding: padding)        
    }
    
    private func setupTitleLabel() {
        checkInLabel.text = "Check-in"
        checkOutLabel.text = "Check-out"
        guestLabel.text = "Guest"
        roomLabel.text = "Room"
    }
    
    private func setupConstraintSubView() {
        checkInTimeStackView.anchor(top: boxView.topAnchor,
                                    bottom: boxView.bottomAnchor,
                                    leading: boxView.leadingAnchor, 
                                    paddingTop: padding, 
                                    paddingBottom: padding,
                                    paddingLeading: paddingBorder,
                                    paddingTrailing: padding)
        
        rightImageView.anchor(leading: checkInTimeStackView.trailingAnchor,
                              paddingLeading: padding)
        rightImageView.center(centerY: checkInTimeStackView.centerYAnchor)
        rightImageView.setWidth(width: 20)
        rightImageView.setHeight(height: 20)
        
        checkOutTimeStackView.anchor(top: boxView.topAnchor,
                                     bottom: boxView.bottomAnchor,
                                     leading: rightImageView.trailingAnchor, 
                                     paddingTop: padding, 
                                     paddingBottom: padding,
                                     paddingLeading: padding,
                                     paddingTrailing: padding)
        
        guestStackView.anchor(top: boxView.topAnchor,   
                              bottom: boxView.bottomAnchor,
                              trailing: roomStackView.leadingAnchor, 
                              paddingTop: padding, 
                              paddingBottom: padding,
                              paddingTrailing: paddingBorder)
        
        roomStackView.anchor(top: boxView.topAnchor,   
                             bottom: boxView.bottomAnchor,
                             trailing: boxView.trailingAnchor, 
                             paddingTop: padding, 
                             paddingBottom: padding,
                             paddingTrailing: paddingBorder)
    }
    
    func setupVerticalStackView(title: UILabel, info: UILabel) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.addArrangedSubviews(title, info)
        stackView.backgroundColor = .systemBackground
        return stackView
    }
    
}
