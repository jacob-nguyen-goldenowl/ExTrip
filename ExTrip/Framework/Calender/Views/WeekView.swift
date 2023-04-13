//
//  WeekView.swift
//  CalendarExample
//
//  Created by Nguyễn Hữu Toàn on 21/12/2022.
//

import UIKit

final class WeekView: UIView {
    
        // MARK: - Outlets
    public lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.spacing = 0
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
        // MARK: - Variables
    private let config: FastisConfig.WeekView
    private let calendar: Calendar
    
        // MARK: - Lifecycle
    init(calendar: Calendar, config: FastisConfig.WeekView) {
        self.config = config
        self.calendar = calendar
        super.init(frame: .zero)
        configureUI()
        configureSubviews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        // MARK: - Configuration
    private func configureUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = self.config.backgroundColor
        layer.cornerRadius = self.config.cornerRadius
    }
    
    private func configureSubviews() {
        let numDays = calendar.shortStandaloneWeekdaySymbols.count
        let first = calendar.firstWeekday - 1
        let end = first + numDays - 1
        let days = (first...end).map({ calendar.shortStandaloneWeekdaySymbols[$0 % numDays] })
        for weekdaySymbol in days {
            self.stackView.addArrangedSubview(makeWeekLabel(for: weekdaySymbol))
        }
        self.addSubview(self.stackView)
    }
    
    func makeWeekLabel(for symbol: String) -> UILabel {
        let label = UILabel()
        label.text = config.uppercaseWeekName ? symbol.uppercased() : symbol
        label.font = config.textFont
        label.textColor = config.textColor
        label.textAlignment = .center
        return label
    }
    
    private func configureConstraints() {
        stackView.anchor(top: topAnchor,
                         bottom: bottomAnchor,
                         leading: leadingAnchor,
                         trailing: trailingAnchor,
                         paddingLeading: 4,
                         paddingTrailing: 4)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: config.height)
        ])
    }
    
}

extension FastisConfig {
    
    /**
     Top header view with week day names
     Configurable in FastisConfig.``FastisConfig/weekView-swift.property`` property
     */
    public struct WeekView {
        
        /**
         Calendar which is used to get a `.shortWeekdaySymbols`
         
         Default value — `.current`
         */
        @available(*, unavailable, message: "Use FastisConfig.calendar propery instead")
        public var calendar: Calendar = .current
        
        /**
         Background color of the view
         
         Default value — `.secondarySystemBackground`
         */
        public var backgroundColor: UIColor = .secondarySystemBackground
        
        /**
         Text color of labels
         
         Default value — `.secondaryLabel`
         */
        public var textColor: UIColor = .secondaryLabel
        
        /**
         Text font of labels
         
         Default value — `.systemFont(ofSize: 10, weight: .bold)`
         */
        public var textFont: UIFont = .systemFont(ofSize: 10, weight: .bold)
        
        /**
         Height of the view
         
         Default value — `28pt`
         */
        public var height: CGFloat = 28
        
        /**
         Corner radius of the view
         
         Default value — `8pt`
         */
        public var cornerRadius: CGFloat = 8
        
        /**
         Make week names uppercased
         
         Default value — `true`
         */
        public var uppercaseWeekName: Bool = true
    }
}
