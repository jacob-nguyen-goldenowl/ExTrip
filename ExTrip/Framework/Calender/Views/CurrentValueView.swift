//
//  CurrentValueView.swift
//  CalendarExample
//
//  Created by Nguyễn Hữu Toàn on 21/12/2022.
//

import UIKit

final class CurrentValueView<Value: FastisValue>: UILabel {
    
    var isCheckIn: Bool = false
        // MARK: - Outlets
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.text = self.config.placeholderTextForRanges
        label.font = .poppins(style: .bold, size: 15)
        label.textAlignment = .center
        return label
    }()
    
        // MARK: - Variables
    private let config: FastisConfig.CurrentValueView
    
        /// Clear button tap handler
    internal var onClear: (() -> Void)?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = self.config.locale
        formatter.dateFormat = self.config.format
        return formatter
    }()
    
    internal var currentValue: Value? {
        didSet {
            self.updateStateForCurrentValue()
        }
    }
    
        // MARK: - Lifecycle
    internal init(config: FastisConfig.CurrentValueView) {
        self.config = config
        super.init(frame: .zero)
        self.configureUI()
        self.configureSubviews()
        self.configureConstraints()
        self.updateStateForCurrentValue()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        // MARK: - Configuration
    private func configureUI() {
        self.backgroundColor = .clear
    }
    
    private func configureSubviews() {
        self.addSubview(label)
    }
    
    private func configureConstraints() {
        label.fillAnchor(self)
    }
    
    private func updateStateForCurrentValue() {
        
        if let value = self.currentValue as? Date {
            
            self.label.text = self.dateFormatter.string(from: value)
            self.label.textColor = self.config.textColor
            
        } else if let value = self.currentValue as? FastisRange {
            
            self.label.textColor = self.config.textColor
            
            if isCheckIn {
                self.label.text = self.dateFormatter.string(from: value.toDate)
            } else {
                self.label.text = self.dateFormatter.string(from: value.fromDate)
            }
            
        } else {
            
            self.label.textColor = self.config.placeholderTextColor
            
            switch Value.mode {
                case .range:
                    self.label.text = self.config.placeholderTextForRanges
                    
                case .single:
                    self.label.text = self.config.placeholderTextForSingle
                    
            }
            
        }
        
    }
    
        // MARK: - Actions
    @objc private func clear() {
        self.onClear?()
    }
    
}

extension FastisConfig {
    
    /**
     Current value view appearance (clear button, date format, etc.)
     
     Configurable in FastisConfig.``FastisConfig/currentValueView-swift.property`` property
     */
    public struct CurrentValueView {
        
        /**
         Placeholder text in .range mode
         
         Default value — `"Select date range"`
         */
        public var placeholderTextForRanges: String = "Select date range"
        
        /**
         Placeholder text in .single mode
         
         Default value — `"Select date"`
         */
        public var placeholderTextForSingle: String = "Select date"
        
        /**
         Color of the placeholder for value label
         
         Default value — `.tertiaryLabel`
         */
        public var placeholderTextColor: UIColor = .tertiaryLabel
        
        /**
         Color of the value label
         
         Default value — `.label`
         */
        public var textColor: UIColor = .label
        
        /**
         Font of the value label
         
         Default value — `.systemFont(ofSize: 17, weight: .regular)`
         */
        public var textFont: UIFont = .systemFont(ofSize: 17, weight: .regular)
        
        /**
         Clear button image
         
         Default value — `UIImage(systemName: "xmark.circle")`
         */
        public var clearButtonImage: UIImage? = UIImage(systemName: "xmark.circle")
        
        /**
         Clear button tint color
         
         Default value — `.systemGray3`
         */
        public var clearButtonTintColor: UIColor = .systemGray3
        
        /**
         Insets of value view
         
         Default value — `"d MMMM"`
         */
        public var format: String = "EE d MMMM"
        
        /**
         Locale of formatter
         
         Default value — `Locale.autoupdatingCurrent`
         */
        public var locale: Locale = .current
    }
}
