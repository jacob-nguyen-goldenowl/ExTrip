//
//  TimeTableViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 15/02/2023.
//

import UIKit

class TimeTableViewCell: UITableViewCell {

    static let identifier = "TimeTableViewCell"
    
    private let lightBlueColor = UIColor.theme.lightBlue ?? .blue
    private let lightGrayColor = UIColor.theme.lightGray ?? .gray
    private let padding: CGFloat = 10
    private let paddingBorder: CGFloat = 30
    private let rightImage = UIImage(named: "right")
    
    var infoBooking: HotelBookingModel? {
        didSet {
            if let room = infoBooking?.room, let time = infoBooking?.date as? FastisRange {
                checkInTimeLabel.text = time.fromDate.displayMonthString
                checkOutTimeLabel.text = time.toDate.displayMonthString
                guestInfoLabel.text = "\(room.numberOfGuest(adults: room.adults, children: room.children, infants: room.infants))"
                roomInfoLabel.text = "\(room.room)"
            }
            setupConstraintSubView()
        }
    }
    
    private let boxView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 0.8
        view.layer.borderColor = UIColor.theme.lightGray?.cgColor
        return view
    }()
    
    private lazy var checkInLabel = setupLabel(text: "Check-in",
                                               font: .poppins(style: .light, size: 11))
    private lazy var checkInTimeLabel = setupLabel(text: "Feb, 25",
                                                   color: lightBlueColor,
                                                   font: .poppins(style: .bold, size: 15))
    
    private lazy var checkOutLabel = setupLabel(text: "Check-out", 
                                                font: .poppins(style: .light, size: 11))
    private lazy var checkOutTimeLabel = setupLabel(text: "Feb, 28",
                                                    color: lightBlueColor, 
                                                    font: .poppins(style: .bold, size: 15))
    
    private lazy var guestLabel = setupLabel(text: "Guest",
                                             font: .poppins(style: .light, size: 11))
    private lazy var guestInfoLabel = setupLabel(text: "1",
                                                 color: lightBlueColor, 
                                                 font: .poppins(style: .bold, size: 15))
    
    private lazy var roomLabel = setupLabel(text: "Room", 
                                            font: .poppins(style: .light, size: 11))
    private lazy var roomInfoLabel = setupLabel(text: "1",
                                                color: lightBlueColor,
                                                font: .poppins(style: .bold, size: 15))
    
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
    private lazy var roomStackView = setupVerticalStackView(title: roomLabel, info: roomInfoLabel)
    
        // MARK: - INIT
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubView() {
        backgroundColor = .clear
        addSubview(boxView) 
        boxView.addSubviews(rightImageView,
                            checkInTimeStackView, 
                            checkOutTimeStackView, 
                            guestStackView, 
                            roomStackView)
        boxView.fillAnchor(self, padding: padding)        
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
        return stackView
    }
    
    private func setupLabel(text: String? = nil,
                            color: UIColor? = UIColor.theme.lightGray,
                            font: UIFont) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = color
        label.textAlignment = .center
        label.font = font
        return label
    }
    
}
