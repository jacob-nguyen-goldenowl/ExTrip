//
//  HotelBookingTableViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 20/12/2022.
//

import UIKit

class HotelBookingTableViewCell: UITableViewCell {
    
    static let identifier = "HotelBookingTableViewCell"
    
    // Variables
    var destinationValue: String? {
        didSet {
            if let value = destinationValue , !value.isEmpty {
                stepResultLabel.text = value
            } else {
                stepResultLabel.text = "Enter your destination"
            }
        }
    }
    
    var timeValue: FastisValue? {
        didSet {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            if let rangeValue = self.timeValue as? FastisRange {
                stepResultLabel.text = formatter.string(from: rangeValue.fromDate) + " - " + formatter.string(from: rangeValue.toDate)
            } else if let date = self.timeValue as? Date {
                stepResultLabel.text = formatter.string(from: date)
            } else {
                stepResultLabel.text = "Enter your date"
            }
        }
    }
    
    var roomValue: String? {
        didSet {
            if roomValue != nil {
                stepResultLabel.text = roomValue 
            } else {
                stepResultLabel.text = "Enter your room" 
            }
        }
    }

    // MARK: - Properties
    private lazy var destinationView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        return view
    }()
    
    private lazy var stepImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.sizeToFit()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var stepTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(style: .bold, size: 17)
        return label
    }()
    
    private lazy var stepResultLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter your info"
        label.font = .poppins(style: .light, size: 14)
        return label
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.theme.lightGray
        return view
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup UI
    private func setupSubView() {
        contentView.addSubviews(destinationView,
                                stepTitleLabel,
                                stepResultLabel,
                                separatorView)
        
        destinationView.addSubview(stepImageView)
        
        setupConstraintSubView()
    }
    
    private func setupConstraintSubView() {
        let padding: CGFloat = 15
        destinationView.anchor(leading: leadingAnchor, 
                               paddingLeading: 20)
        destinationView.center(centerY: centerYAnchor)
        destinationView.setWidth(width: 60)
        destinationView.setHeight(height: 60)
                
        stepImageView.anchor(top: destinationView.topAnchor, 
                         bottom: destinationView.bottomAnchor,
                         leading: destinationView.leadingAnchor,
                         trailing: destinationView.trailingAnchor,
                         paddingTop: padding,
                         paddingBottom: padding,
                         paddingLeading: padding,
                         paddingTrailing: padding)
        
        stepTitleLabel.anchor(top: destinationView.topAnchor, 
                              leading: destinationView.trailingAnchor,
                              trailing: trailingAnchor,
                              paddingTop: 5,
                              paddingLeading: 10)
        stepTitleLabel.setHeight(height: 25)
        
        stepResultLabel.anchor(bottom: destinationView.bottomAnchor, 
                               leading: destinationView.trailingAnchor,
                               trailing: trailingAnchor, 
                               paddingBottom: 5, 
                               paddingLeading: 10)
        
        separatorView.anchor(bottom: bottomAnchor,
                             leading: leadingAnchor,
                             trailing: trailingAnchor,
                             paddingLeading: 20,
                             paddingTrailing: 20)
        separatorView.setHeight(height: 0.3)
    }
    
    private func createIconStep(image: UIImage?, color: UIColor?) {
        destinationView.backgroundColor = color?.withAlphaComponent(0.2)
        let image = image?.withRenderingMode(.alwaysTemplate)
        stepImageView.image = image
        stepImageView.tintColor = color
    }
    
    // MARK: - Get data
    func getDataStep(_ data: StepBookingModel) {
        stepTitleLabel.text = data.title.uppercased()
        createIconStep(image: data.icon, color: data.color)
    }
    
}

