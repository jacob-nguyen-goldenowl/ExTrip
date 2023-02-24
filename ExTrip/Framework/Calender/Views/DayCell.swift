//
//  DateCell.swift
//  CalendarExample
//
//  Created by Nguyễn Hữu Toàn on 21/12/2022.
//

import UIKit
import JTAppleCalendar

final class DayCell: JTACDayCell {
    
        // MARK: - Outlets
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var selectionBackgroundView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var leftRangeView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerCurve = .continuous
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var rightRangeView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerCurve = .continuous
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
        // MARK: - Variables
    private var config: FastisConfig.DayCell = FastisConfig.default.dayCell
    private var rangeViewTopAnchorConstraints: [NSLayoutConstraint] = []
    private var rangeViewBottomAnchorConstraints: [NSLayoutConstraint] = []
    
        // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        configureConstraints()
        applyConfig(.default)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        // MARK: - Configurations
    public func applyConfig(_ config: FastisConfig) {
        backgroundColor = config.controller.backgroundColor
        
        let config = config.dayCell
        self.config = config
        rightRangeView.backgroundColor = config.onRangeBackgroundColor
        leftRangeView.backgroundColor = config.onRangeBackgroundColor
        rightRangeView.layer.cornerRadius = config.rangeViewCornerRadius
        leftRangeView.layer.cornerRadius = config.rangeViewCornerRadius
        selectionBackgroundView.backgroundColor = config.selectedBackgroundColor
        dateLabel.font = config.dateLabelFont
        dateLabel.textColor = config.dateLabelColor
        if let cornerRadius = config.customSelectionViewCornerRadius {
            selectionBackgroundView.layer.cornerRadius = cornerRadius
        }
        rangeViewTopAnchorConstraints.forEach({ $0.constant = config.rangedBackgroundViewVerticalInset })
        rangeViewBottomAnchorConstraints.forEach({ $0.constant = -config.rangedBackgroundViewVerticalInset })
    }
    
    public func configureSubviews() {
        contentView.addSubview(leftRangeView)
        contentView.addSubview(rightRangeView)
        contentView.addSubview(selectionBackgroundView)
        contentView.addSubview(dateLabel)
        selectionBackgroundView.layer.cornerRadius = 20
    }
    
    public func configureConstraints() {
        let inset = self.config.rangedBackgroundViewVerticalInset
        dateLabel.fillAnchor(contentView.self)

        NSLayoutConstraint.activate([
            leftRangeView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            leftRangeView.rightAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            rightRangeView.leftAnchor.constraint(equalTo: contentView.centerXAnchor),
            rightRangeView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 1) // Add small offset to prevent spacing between cells
        ])

        NSLayoutConstraint.activate([
            {
                let constraint = selectionBackgroundView.heightAnchor.constraint(equalToConstant: 70)
                constraint.priority = .defaultLow
                return constraint
            }(),
            selectionBackgroundView.leftAnchor.constraint(greaterThanOrEqualTo: contentView.leftAnchor),
            selectionBackgroundView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor),
            selectionBackgroundView.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor),
            selectionBackgroundView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            selectionBackgroundView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            selectionBackgroundView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            selectionBackgroundView.widthAnchor.constraint(equalTo: selectionBackgroundView.heightAnchor)
        ])  
        rangeViewTopAnchorConstraints = [
            leftRangeView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            rightRangeView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset)
        ]
        rangeViewBottomAnchorConstraints = [
            leftRangeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
            rightRangeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
        ]
        NSLayoutConstraint.activate(rangeViewTopAnchorConstraints)
        NSLayoutConstraint.activate(rangeViewBottomAnchorConstraints)
    }
    // swiftlint:disable cyclomatic_complexity
    public static func makeViewConfig(
        for state: CellState,
        minimumDate: Date?,
        maximumDate: Date?,
        rangeValue: FastisRange?,
        calendar: Calendar
    ) -> ViewConfig {
        
        var config = ViewConfig()
        
        if state.dateBelongsTo != .thisMonth {
            
            config.isSelectedViewHidden = true
            
            if let value = rangeValue {
                
                let calendar = Calendar.current
                var showRangeView: Bool = false
                
                if state.dateBelongsTo == .followingMonthWithinBoundary {
                    let endOfPreviousMonth = calendar.date(byAdding: .month, value: -1, to: state.date)!.endOfMonth(in: calendar)
                    let startOfCurrentMonth = state.date.startOfMonth(in: calendar)
                    let fromDateIsInPast = value.fromDate < endOfPreviousMonth
                    let toDateIsInFutureOrCurrent = value.toDate > startOfCurrentMonth
                    showRangeView = fromDateIsInPast && toDateIsInFutureOrCurrent
                } else if state.dateBelongsTo == .previousMonthWithinBoundary {
                    let startOfNextMonth = calendar.date(byAdding: .month, value: 1, to: state.date)!.startOfMonth(in: calendar)
                    let endOfCurrentMonth = state.date.endOfMonth(in: calendar)
                    let toDateIsInFuture = value.toDate > startOfNextMonth
                    let fromDateIsInPastOrCurrent = value.fromDate < endOfCurrentMonth
                    showRangeView = toDateIsInFuture && fromDateIsInPastOrCurrent
                }
                
                if showRangeView {
                    
                    if state.day.rawValue == calendar.firstWeekday {
                        config.rangeView.leftSideState = .rounded
                        config.rangeView.rightSideState = .squared
                    } else if state.day.rawValue == calendar.lastWeekday {
                        config.rangeView.leftSideState = .squared
                        config.rangeView.rightSideState = .rounded
                    } else {
                        config.rangeView.leftSideState = .squared
                        config.rangeView.rightSideState = .squared
                    }
                }
                
            }
            
            return config
        }
        
        config.dateLabelText = state.text
        
        if let minimumDate = minimumDate, state.date < minimumDate.startOfDay() {
            config.isDateEnabled = false
            return config
        } else if let maximumDate = maximumDate, state.date > maximumDate.endOfDay() {
            config.isDateEnabled = false
            return config
        }
        
        if state.isSelected {
            
            let position = state.selectedPosition()
            
            switch position {
                    
                case .full:
                    config.isSelectedViewHidden = false
                    
                case .left, .right, .middle:
                    config.isSelectedViewHidden = position == .middle
                    
                    if position == .right && state.day.rawValue == calendar.firstWeekday {
                        config.rangeView.leftSideState = .rounded
                        
                    } else if position == .left && state.day.rawValue == calendar.lastWeekday {
                        config.rangeView.rightSideState = .squared
                        
                    } else if position == .left {
                        config.rangeView.rightSideState = .squared
                        
                    } else if position == .right {
                        config.rangeView.leftSideState = .squared
                        
                    } else if state.day.rawValue == calendar.firstWeekday {
                        config.rangeView.leftSideState = .squared
                        config.rangeView.rightSideState = .squared
                        
                    } else if state.day.rawValue == calendar.lastWeekday {
                        config.rangeView.leftSideState = .squared
                        config.rangeView.rightSideState = .rounded
                        
                    } else {
                        config.rangeView.leftSideState = .squared
                        config.rangeView.rightSideState = .squared
                    }
                    
                default:
                    break
            }
            
        }
        
        return config
    }
    
    enum RangeSideState {
        case squared
        case rounded
        case hidden
    }
    
    struct RangeViewConfig: Hashable {
        
        var leftSideState: RangeSideState = .hidden
        var rightSideState: RangeSideState = .hidden
        
        var isHidden: Bool {
            return leftSideState == .hidden && rightSideState == .hidden
        }
        
    }
    
    struct ViewConfig {
        var dateLabelText: String?
        var isSelectedViewHidden: Bool = true
        var isDateEnabled: Bool = true
        var rangeView: RangeViewConfig = RangeViewConfig()
    }
    
    internal func configure(for config: ViewConfig) {
        
        selectionBackgroundView.isHidden = config.isSelectedViewHidden
        isUserInteractionEnabled = config.dateLabelText != nil && config.isDateEnabled
        clipsToBounds = config.dateLabelText == nil
        
        if let dateLabelText = config.dateLabelText {
            dateLabel.isHidden = false
            dateLabel.text = dateLabelText
            if !config.isDateEnabled {
                dateLabel.textColor = self.config.dateLabelUnavailableColor
            } else if !config.isSelectedViewHidden {
                dateLabel.textColor = self.config.selectedLabelColor
            } else if !config.rangeView.isHidden {
                dateLabel.textColor = self.config.onRangeLabelColor
            } else {
                dateLabel.textColor = self.config.dateLabelColor
            }
            
        } else {
            dateLabel.isHidden = true
        }
        
        switch config.rangeView.rightSideState {
            case .squared:
                rightRangeView.isHidden = false
                rightRangeView.layer.maskedCorners = []
            case .rounded:
                rightRangeView.isHidden = false
                rightRangeView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            case .hidden:
                rightRangeView.isHidden = true
        }
        
        switch config.rangeView.leftSideState {
            case .squared:
                leftRangeView.isHidden = false
                leftRangeView.layer.maskedCorners = []
            case .rounded:
                leftRangeView.isHidden = false
                leftRangeView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            case .hidden:
                leftRangeView.isHidden = true
        }
        
    }
    
}

extension FastisConfig {
    
    /**
     Day cells (selection parameters, font, etc.)
     
     Configurable in FastisConfig.``FastisConfig/dayCell-swift.property`` property
     */
    public struct DayCell {
        
        /**
         Font of date label in cell
         
         Default value — `.systemFont(ofSize: 17)`
         */
        public var dateLabelFont: UIFont = .systemFont(ofSize: 17)
        
        /**
         Color of date label in cell
         
         Default value — `.label`
         */
        public var dateLabelColor: UIColor = .label
        
        /**
         Color of date label in cell when date is unavailable for select
         
         Default value — `.tertiaryLabel`
         */
        public var dateLabelUnavailableColor: UIColor = .tertiaryLabel
        
        /**
         Color of background of cell when date is selected
         
         Default value — `.systemBlue`
         */
        public var selectedBackgroundColor: UIColor = UIColor.theme.lightBlue ?? .systemBlue
        
        /**
         Color of date label in cell when date is selected
         Default value — `.white`
         */
        public var selectedLabelColor: UIColor = .white
        
        /**
         Corner radius of cell when date is a start or end of selected range
         Default value — `6pt`
         */
        public var rangeViewCornerRadius: CGFloat = 0
        
        /**
         Color of background of cell when date is a part of selected range
         
         Default value — `.systemBlue.withAlphaComponent(0.2)`
         */
        public var onRangeBackgroundColor: UIColor = .tertiarySystemGroupedBackground
        
        /**
         Color of date label in cell when date is a part of selected range
         
         Default value — `.label`
         */
        public var onRangeLabelColor: UIColor = .label
        
        /**
         Inset of cell's background view when date is a part of selected range
         
         Default value — `3pt`
         */
        public var rangedBackgroundViewVerticalInset: CGFloat = 10
        
        /**
         This property allows to set custom radius for selection view
         
         If this value is not `nil` then selection view will have corner radius `.height / 2`
         
         Default value — `nil`
         */
        public var customSelectionViewCornerRadius: CGFloat?
    }
    
}

