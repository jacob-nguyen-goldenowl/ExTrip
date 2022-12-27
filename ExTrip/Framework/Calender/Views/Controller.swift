//
//  Controller.swift
//  CalendarExample
//
//  Created by Nguyễn Hữu Toàn on 21/12/2022.
//

import UIKit
import JTAppleCalendar

class FastisController<Value: FastisValue>: UIViewController {
                
    private lazy var calendarView: JTACMonthView = {
        let monthView = JTACMonthView()
        monthView.translatesAutoresizingMaskIntoConstraints = false
        monthView.backgroundColor = appearance.backgroundColor
        monthView.ibCalendarDelegate = self
        monthView.ibCalendarDataSource = self
        monthView.minimumInteritemSpacing = 0
        monthView.minimumLineSpacing = 0
        monthView.showsHorizontalScrollIndicator = false
        monthView.allowsMultipleSelection = Value.mode == .range
        monthView.allowsRangedSelection = true
        monthView.scrollDirection = .horizontal
        monthView.isPagingEnabled = true
        monthView.rangeSelectionMode = .continuous
        monthView.contentInsetAdjustmentBehavior = .never
        return monthView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Select date"
        label.font = .poppins(style: .bold, size: 25)
        return label
    }()
    
    private lazy var doneButton = ETGradientButton(title: .done, style: .mysticBlue)
    
    private lazy var weekView: WeekView = {
        let view = WeekView(calendar: config.calendar, config: config.weekView)
        return view
    }()
    
    private lazy var currentCheckInView: CurrentValueView<Value> = {
        let view = CurrentValueView<Value>(config: config.currentValueView)
        view.currentValue = value
        view.isCheckIn = false
        return view
    }()
    
    private lazy var currentCheckOutView: CurrentValueView<Value> = {
        let view = CurrentValueView<Value>(config: config.currentValueView)
        view.currentValue = value
        view.isCheckIn = true
        return view
    }()
    
    private lazy var checkInLabel: UILabel = {
        let label = UILabel()
        label.text = "Check-In"
        label.textAlignment = .center
        label.textColor = UIColor.theme.lightGray ?? .gray
        label.font = .poppins(style: .regular, size: 13)
        return label
    }()
    
    private lazy var checkOutLabel: UILabel = {
        let label = UILabel()
        label.text = "Check-Out"
        label.textAlignment = .center
        label.textColor = UIColor.theme.lightGray ?? .gray
        label.font = .poppins(style: .regular, size: 13)
        return label
    }()
    
    // MARK: - Variables
    private let config: FastisConfig
    private var appearance: FastisConfig.Controller = FastisConfig.default.controller
    private let dayCellReuseIdentifier = "DayCellReuseIdentifier"
    private let monthHeaderReuseIdentifier = "MonthHeaderReuseIdentifier"
    private var viewConfigs: [IndexPath: DayCell.ViewConfig] = [:]
    private var privateMinimumDate: Date?
    private var privateMaximumDate: Date?
    private var privateSelectMonthOnHeaderTap: Bool = false
    private var value: Value? {
        didSet {
            currentCheckInView.currentValue = value
            currentCheckOutView.currentValue = value
            doneButton.isEnabled = allowToChooseNilDate || value != nil
        }
    }

    public var allowToChooseNilDate: Bool = false

    public var dismissHandler: (() -> Void)?

    public var doneHandler: ((Value?) -> Void)?

    public var initialValue: Value?

    public var minimumDate: Date? {
        get {
            return privateMinimumDate
        }
        set {
            privateMinimumDate = newValue?.startOfDay()
        }
    }

    public var allowDateRangeChanges: Bool = true

    public var maximumDate: Date? {
        get {
            return privateMaximumDate
        }
        set {
            privateMaximumDate = newValue?.endOfDay()
        }
    }
    
    // MARK: - Initialization
    public init(config: FastisConfig = .default) {
        self.config = config
        appearance = config.controller
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSubviews()
        configureConstraints()
        configureInitialState()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        view.frame.size.height = UIScreen.main.bounds.height - 15
        view.frame.origin.y = 15
        view.roundCorners(corners: [.topLeft, .topRight], radius: 25.0)
    }
    
    // MARK: - Configuration
    private func configureUI() {
        view.backgroundColor = appearance.backgroundColor
    }
    
    private func configureSubviews() {
        
        calendarView.register(DayCell.self, forCellWithReuseIdentifier: dayCellReuseIdentifier)
        calendarView.register(MonthHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: monthHeaderReuseIdentifier)
        
        doneButton.addTarget(self, action: #selector(done), for: .touchUpInside)
        
        view.addSubviews(currentCheckInView,
                         currentCheckOutView,
                         weekView,
                         calendarView,
                         checkInLabel,
                         checkOutLabel,
                         titleLabel,
                         doneButton)
    }
    
    private func configureConstraints() {
        let padding: CGFloat = 12
        let haftView: CGFloat = view.frame.size.width / 2
        titleLabel.anchor(top: view.topAnchor, 
                          leading: view.leadingAnchor, 
                          trailing: view.trailingAnchor,
                          paddingTop: 50,
                          paddingLeading: padding,
                          paddingTrailing: padding)
        titleLabel.setHeight(height: 30)
        
        weekView.anchor(top: titleLabel.bottomAnchor,
                        leading: view.leadingAnchor,
                        trailing: view.trailingAnchor,
                        paddingTop: padding,
                        paddingLeading: padding,
                        paddingTrailing: padding)
        
        calendarView.anchor(top: weekView.bottomAnchor,
                            leading: view.leadingAnchor,
                            trailing: view.trailingAnchor)
        calendarView.setHeight(height: 350)
        
        checkInLabel.anchor(top: calendarView.bottomAnchor, 
                            leading: view.leadingAnchor)
        checkInLabel.setWidth(width: haftView)
        checkInLabel.setHeight(height: 30)
        
        checkOutLabel.anchor(top: calendarView.bottomAnchor, 
                             trailing: view.trailingAnchor)
        checkOutLabel.setWidth(width: haftView)
        checkOutLabel.setHeight(height: 30)
        
        currentCheckInView.anchor(top: checkInLabel.bottomAnchor,
                                  leading: view.leadingAnchor)
        currentCheckInView.setWidth(width: haftView)
        currentCheckInView.setHeight(height: 20)
        
        currentCheckOutView.anchor(top: checkOutLabel.bottomAnchor,
                                   trailing: view.trailingAnchor)
        currentCheckOutView.setWidth(width: haftView)
        currentCheckOutView.setHeight(height: 20)
        
        doneButton.anchor(top: currentCheckInView.bottomAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor,
                          paddingTop: 25,
                          paddingLeading: 30,
                          paddingTrailing: 30)
        doneButton.setHeight(height: 50)
    }
    
    private func configureInitialState() {
        value = initialValue
        if let date = value as? Date {
            calendarView.selectDates([date])
            calendarView.scrollToHeaderForDate(date)
        } else if let rangeValue = value as? FastisRange {
            selectRange(rangeValue, in: calendarView)
            calendarView.scrollToHeaderForDate(rangeValue.fromDate)
        } else {
            let nowDate = Date()
            let targetDate = privateMaximumDate ?? nowDate
            if targetDate < nowDate {
                calendarView.scrollToHeaderForDate(targetDate)
            } else {
                calendarView.scrollToHeaderForDate(Date())
            }
        }
    }
    
    private func configureCell(_ cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? DayCell else { return }
        if let cachedConfig = viewConfigs[indexPath] {
            cell.configure(for: cachedConfig)
        } else {
            let newConfig = DayCell.makeViewConfig(for: cellState,
                                                   minimumDate: privateMinimumDate,
                                                   maximumDate: privateMaximumDate,
                                                   rangeValue: value as? FastisRange,
                                                   calendar: config.calendar)
            viewConfigs[indexPath] = newConfig
            cell.applyConfig(config)
            cell.configure(for: newConfig)
        }
    }
    
    private func cancel() {
        dismiss(animated: true)
    }
    
    @objc private func done() {
        doneHandler?(value)
        cancel()
    }
    
    private func selectValue(_ value: Value?, in calendar: JTACMonthView) {
        if let date = value as? Date {
            calendar.selectDates([date])
        } else if let range = value as? FastisRange {
            selectRange(range, in: calendar)
        }
    }
    
    private func handleDateTap(in calendar: JTACMonthView, date: Date) {
        
        switch Value.mode {
            case .single:
                value = date as? Value
                selectValue(date as? Value, in: calendar)
                return
                
            case .range:
                var newValue: FastisRange!
                if let currentValue = value as? FastisRange {
                    let dateRangeChangesDisabled = !allowDateRangeChanges
                    let rangeSelected = !currentValue.fromDate.isInSameDay(date: currentValue.toDate)
                    if dateRangeChangesDisabled && rangeSelected {
                        newValue = .from(date.startOfDay(in: config.calendar), to: date.endOfDay(in: config.calendar))
                    } else if date.isInSameDay(in: config.calendar, date: currentValue.fromDate) {
                        let newToDate = date.endOfDay(in: config.calendar)
                        newValue = .from(currentValue.fromDate, to: newToDate)
                    } else if date.isInSameDay(in: config.calendar, date: currentValue.toDate) {
                        let newFromDate = date.startOfDay(in: config.calendar)
                        newValue = .from(newFromDate, to: currentValue.toDate)
                    } else if date < currentValue.fromDate {
                        let newFromDate = date.startOfDay(in: config.calendar)
                        newValue = .from(newFromDate, to: currentValue.toDate)
                    } else {
                        let newToDate = date.endOfDay(in: config.calendar)
                        newValue = .from(currentValue.fromDate, to: newToDate)
                    }
                    
                } else {
                    newValue = .from(date.startOfDay(in: config.calendar), to: date.endOfDay(in: config.calendar))
                }
                
                value = newValue as? Value
                selectValue(newValue as? Value, in: calendar)
                
        }
    }
    
    private func selectRange(_ range: FastisRange, in calendar: JTACMonthView) {
        calendar.deselectAllDates(triggerSelectionDelegate: false)
        calendar.selectDates(from: range.fromDate, to: range.toDate, triggerSelectionDelegate: true, keepSelectionIfMultiSelectionAllowed: false)
        calendar.visibleDates { (segment) in
            UIView.performWithoutAnimation {
                calendar.reloadItems(at: (segment.outdates + segment.indates).map({ $0.indexPath }))
            }
        }
    }

}

// MARK: - JTACMonthViewDelegate
extension FastisController: JTACMonthViewDelegate, JTACMonthViewDataSource  {
    
    public func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        dateFormatter.timeZone = config.calendar.timeZone
        dateFormatter.locale = config.calendar.locale
        var startDate = dateFormatter.date(from: "2000 01 01")!
        var endDate = dateFormatter.date(from: "2030 12 01")!
        
        if let maximumDate = privateMaximumDate,
           let endOfNextMonth = config.calendar.date(byAdding: .month, value: 2, to: maximumDate)?
            .endOfMonth(in: config.calendar) {
            endDate = endOfNextMonth
        }
        
        if let minimumDate = privateMinimumDate,
           let startOfPreviousMonth = config.calendar.date(byAdding: .month, value: -2, to: minimumDate)?
            .startOfMonth(in: config.calendar) {
            startDate = startOfPreviousMonth
        }
        
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 6,
                                                 calendar: config.calendar,
                                                 generateInDates: .forAllMonths,
                                                 generateOutDates: .tillEndOfGrid,
                                                 firstDayOfWeek: .monday,
                                                 hasStrictBoundaries: true)
        return parameters
    }
    
    // Header
    public func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: monthHeaderReuseIdentifier, for: indexPath) as! MonthHeader
        header.applyConfig(config.monthHeader)
        header.configure(for: range.start)
        if privateSelectMonthOnHeaderTap, Value.mode == .range {
            header.tapHandler = {
                var fromDate = range.start.startOfMonth(in: self.config.calendar)
                var toDate = range.start.endOfMonth(in: self.config.calendar)
                if let minDate = self.minimumDate {
                    if toDate < minDate { return } else if fromDate < minDate {
                        fromDate = minDate.startOfDay(in: self.config.calendar)
                    }
                }
                if let maxDate = self.maximumDate {
                    if fromDate > maxDate { return } else if toDate > maxDate {
                        toDate = maxDate.endOfDay(in: self.config.calendar)
                    }
                }
                let newValue: FastisRange = .from(fromDate, to: toDate)
                self.value = newValue as? Value
                self.selectRange(newValue, in: calendar)
            }
        }
        return header
    }
    
    public func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: dayCellReuseIdentifier, for: indexPath)
        configureCell(cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    
    public func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
    }
    
    public func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        if cellState.selectionType == .some(.userInitiated) {
            handleDateTap(in: calendar, date: date)
        } else if let cell = cell {
            configureCell(cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        }
    }
    
    public func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        if cellState.selectionType == .some(.userInitiated) && Value.mode == .range {
            handleDateTap(in: calendar, date: date)
        } else if let cell = cell {
            configureCell(cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        }
    }
    
    public func calendar(_ calendar: JTACMonthView, shouldSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
        viewConfigs.removeAll()
        return true
    }
    
    public func calendar(_ calendar: JTACMonthView, shouldDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
        viewConfigs.removeAll()
        return true
    }
    
    public func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return config.monthHeader.height
    }
}

extension FastisController where Value == FastisRange {
    
        /// Initiate FastisController
        /// - Parameters:
        ///   - mode: Choose `.range` or `.single` mode
        ///   - config: Custom configuration parameters. Default value is equal to `FastisConfig.default`
    internal convenience init(mode: FastisModeRange, config: FastisConfig = .default) {
        self.init(config: config)
        selectMonthOnHeaderTap = true
    }
    
    /**
     Set this variable to `true` if you want to allow select date ranges by tapping on months
     */
    internal var selectMonthOnHeaderTap: Bool {
        get {
            return privateSelectMonthOnHeaderTap
        }
        set {
            privateSelectMonthOnHeaderTap = newValue
        }
    }
}

extension FastisController where Value == Date {
    
        /// Initiate FastisController
        /// - Parameters:
        ///   - mode: Choose .range or .single mode
        ///   - config: Custom configuration parameters. Default value is equal to `FastisConfig.default`
    internal convenience init(mode: FastisModeSingle, config: FastisConfig = .default) {
        self.init(config: config)
    }
    
}

extension FastisConfig {
    
    /**
     Configuration of base view controller (`cancelButtonTitle`, `doneButtonTitle`, etc.)
     
     Configurable in FastisConfig.``FastisConfig/controller-swift.property`` property
     */
    public struct Controller {
        
        /**
         Controller's background color
         
         Default value — `.systemBackground`
         */
        public var backgroundColor: UIColor = .systemBackground
        
        /**
         Bar button items tint color
         
         Default value — `.systemBlue`
         */
        public var barButtonItemsColor: UIColor = .systemBlue
        
        /**
         Custom cancel button in navigation bar
         
         Default value — `nil`
         */
        public var customCancelButton: UIBarButtonItem?
        
        /**
         Custom done button in navigation bar
         
         Default value — `nil`
         */
        public var customDoneButton: UIBarButtonItem?
        
    }
}
