//
//  DoubledSlider.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 05/01/2023.
//


import UIKit

public protocol ViewProgrammatically {
    func addSubviews()
    func setupSubviews()
    func makeConstraints()
}

public final class DoubledSlider: UIControl, ViewProgrammatically {
    
    // MARK: - UI
    private lazy var track = UIView()
    private lazy var activeTrack = UIView()
    private lazy var leftThumb = UIImageView()
    private lazy var rightThumb = UIImageView()
    
        // MARK: - Initialization
    public convenience init(minimumValue: Float = .zero, maximumValue: Float = .zero) {
        self.init()
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
    }
    
    private override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        addSubviews()
        setupSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        // MARK: - Public API
    public var minimumValue: Float = .zero
    public var maximumValue: Float = .zero
    
    public var values: (minimum: Float, maximum: Float) {
        get { return (minimumValueNow, maximumValueNow) }
        set {
            var newMin: Float = .zero; var newMax: Float = .zero
            if newValue.0 <= .zero {
                newMin = minimumValue
            }
            if newValue.0 <= minimumValue {
                newMin = minimumValue
            }
            if newValue.0 > newValue.1 {
                newMin = newValue.1
            }
            if newValue.1 <= .zero {
                newMax = minimumValue
            }
            if newValue.1 >= maximumValue {
                newMax = maximumValue
            }
            if newValue.1 < newValue.0 {
                newMax = newValue.0
            }
            minimumValueNow = newMin
            maximumValueNow = newMax
        }
    }
    
        // MARK: - Private API
    private var minimumValueNow: Float = .zero
    private var maximumValueNow: Float = .zero
    
    private func updateValues(_ completion: @escaping () -> Void) {
        minimumValueNow = newMinimalValue
        maximumValueNow = newMaximumValue
        let originXDifference = abs(rightThumb.frame.origin.x - leftThumb.frame.origin.x)
        if originXDifference < 20 {
            minimumValueNow = maximumValueNow
        }
        completion()
    }
    
    private var newMinimalValue: Float {
        let leftThumbOriginX = leftThumbConstraint.constant
        let halfOfThumbWidth = leftThumb.frame.size.width / 2
        let distancePassed = leftThumbOriginX + halfOfThumbWidth
        let totalDistance = track.frame.size.width
        let distancePassedFraction = distancePassed / totalDistance
        if leftThumbOriginX < 3 {
            return minimumValue
        }
        if totalDistance - (leftThumbOriginX + leftThumb.frame.size.width) < 3 {
            return maximumValue
        }
        let newValue: Float = {
            let difference = maximumValue - minimumValue
            let addingValue = Float(distancePassedFraction) * difference
            return minimumValue + addingValue
        }()
        return newValue
    }
    
    private var newMaximumValue: Float {
        let constraintConstant = abs(rightThumbConstraint.constant)
        let distancePassed = constraintConstant + leftThumb.frame.size.width / 2
        let totalDistance = track.frame.size.width
        let distancePassedFraction = distancePassed / totalDistance
        if constraintConstant < 3 {
            return maximumValue
        }
        if totalDistance - (rightThumb.frame.size.width + constraintConstant) < 3 {
            return minimumValue
        }
        let newValue: Float = {
            let difference = maximumValue - minimumValue
            let addingValue = difference * Float(distancePassedFraction)
            return maximumValue - addingValue
        }()
        return newValue
    }
    
        // MARK: - View Programmatically
    public func addSubviews() {
        addSubviews(track,
                    leftThumb,
                    rightThumb)
        track.addSubview(activeTrack)
    }
    
    public func setupSubviews() {
        setupItself()
        setupTrack()
        setupActiveTrack()
        setupThumbs()
    }
    
    public func makeConstraints() {
        defer {
            [leftThumb, rightThumb].forEach { bringSubviewToFront($0) }
        }
        makeConstraintsForTrack()
        makeConstraintsForThumbs()
        makeConstraintsForActiveTrack()
    }
    
        // MARK: - Setups
    private func setupItself() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupTrack() {
        track.layer.masksToBounds = true
        track.layer.cornerRadius = 1.5
        track.backgroundColor = UIColor.lightGray
        track.clipsToBounds = true
    }
    
    private func setupActiveTrack() {
        activeTrack.backgroundColor = UIColor.theme.lightBlue
    }
    
    private func setupThumbs() {
        [leftThumb, rightThumb].forEach {
            $0.image = UIImage(named: "circle")
            $0.contentMode = .scaleAspectFit
            $0.clipsToBounds = true
            $0.isUserInteractionEnabled = true
            let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.dragThumb(using:)))
            $0.addGestureRecognizer(gesture)
        }
        leftThumb.tag = 1
        rightThumb.tag = 2
    }
    
    @objc private func dragThumb(using gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view else { return }
        let translation = gesture.translation(in: self)
        switch gesture.state {
            case .began:
                if [1, 2].contains(view.tag) { bringSubviewToFront(view) }
            case .changed:
                handleDragging(view, withTranslation: translation)
            case .ended:
                handleEndedDragging(view)
            default:
                break
        }
    }
    
    private func handleDragging(_ view: UIView, withTranslation translation: CGPoint) {
        switch view.tag {
            case 1:
                handleDraggingLeftThumb(view, withTranslation: translation)
            case 2:
                handleDraggingRightThumb(view, withTranslation: translation)
            default:
                break
        }
    }
    
    private func handleDraggingLeftThumb(_ thumb: UIView, withTranslation translation: CGPoint) {
        let newConstant = translation.x + leftThumbConstraintLastConstant
        guard newConstant > -0.001 else {
            leftThumbConstraint.constant = .zero
            leftActiveTrackConstraint.constant = .zero
            updateValues {
                self.sendActions(for: .valueChanged)
            }
            return
        }
        if self.thumbesInOnePlace(byDraggingThumb: thumb) && translation.x > .zero { return }
        leftThumbConstraint.constant = newConstant
        leftActiveTrackConstraint.constant = newConstant
        updateValues {
            self.sendActions(for: .valueChanged)
        }
    }
    
    private func handleDraggingRightThumb(_ thumb: UIView, withTranslation translation: CGPoint) {
        let newConstant = translation.x + rightThumbConstraintLastConstant
        guard newConstant < 0.001 else {
            rightThumbConstraint.constant = .zero
            rightActiveTrackConstraint.constant = .zero
            updateValues {
                self.sendActions(for: .valueChanged)
            }
            return
        }
        if thumbesInOnePlace(byDraggingThumb: thumb) && translation.x < .zero { return }
        rightThumbConstraint.constant = newConstant
        rightActiveTrackConstraint.constant = newConstant
        updateValues {
            self.sendActions(for: .valueChanged)
        }
    }
    
    private func handleEndedDragging(_ view: UIView) {
        switch view.tag {
            case 1:
                leftThumbConstraintLastConstant = leftThumbConstraint.constant
                leftActiveTrackConstraintLastConstant = leftActiveTrackConstraint.constant
            case 2:
                rightThumbConstraintLastConstant = rightThumbConstraint.constant
                rightActiveTrackConstraintLastConstant = rightActiveTrackConstraint.constant
            default:
                break
        }
    }
    
    private func thumbesInOnePlace(byDraggingThumb thumb: UIView) -> Bool {
        let difference = abs(self.leftThumb.center.x - rightThumb.center.x)
        let onePlace = difference < 10
        if onePlace {
            forceThumbsPositions(byActiveThumb: thumb)
        }
        return onePlace
    }
    
    private func forceThumbsPositions(byActiveThumb thumb: UIView) {
        switch thumb.tag {
            case 1:
                let newConstant = rightThumb.frame.origin.x
                leftThumbConstraint.constant = newConstant
                leftThumbConstraintLastConstant = newConstant
                leftActiveTrackConstraint.constant = newConstant
                leftActiveTrackConstraintLastConstant = newConstant
            case 2:
                let centerXDifference = rightThumb.center.x - leftThumb.center.x
                let newConstant = rightThumbConstraint.constant - centerXDifference
                rightThumbConstraint.constant = newConstant
                rightThumbConstraintLastConstant = newConstant
                rightActiveTrackConstraint.constant = newConstant
                rightActiveTrackConstraintLastConstant = newConstant
            default:
                break
        }
    }
    
        // MARK: - Constraints
    private func makeConstraintsForTrack() {
        track.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            track.leadingAnchor.constraint(equalTo: leadingAnchor),
            track.trailingAnchor.constraint(equalTo: trailingAnchor),
            track.heightAnchor.constraint(equalToConstant: 3.5),
            track.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func makeConstraintsForActiveTrack() {
        activeTrack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftActiveTrackConstraint,
            rightActiveTrackConstraint,
            activeTrack.topAnchor.constraint(equalTo: track.topAnchor),
            activeTrack.bottomAnchor.constraint(equalTo: track.bottomAnchor)
        ])
    }
    
    private func makeConstraintsForThumbs() {
        [leftThumb, rightThumb].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(equalToConstant: 32).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 32).isActive = true
            $0.topAnchor.constraint(equalTo: topAnchor).isActive = true
            $0.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }
        leftThumbConstraint.isActive = true
        rightThumbConstraint.isActive = true
    }
    
    private lazy var leftThumbConstraint: NSLayoutConstraint = {
        return leftThumb.leadingAnchor.constraint(greaterThanOrEqualTo: track.leadingAnchor)
    }()
    
    private lazy var rightThumbConstraint: NSLayoutConstraint = {
        return rightThumb.trailingAnchor.constraint(lessThanOrEqualTo: track.trailingAnchor)
    }()
    
    private var leftThumbConstraintLastConstant: CGFloat = .zero
    private var rightThumbConstraintLastConstant: CGFloat = .zero
    
    private lazy var leftActiveTrackConstraint: NSLayoutConstraint = {
        return activeTrack.leftAnchor.constraint(equalTo: track.leftAnchor)
    }()
    
    private lazy var rightActiveTrackConstraint: NSLayoutConstraint = {
        return activeTrack.rightAnchor.constraint(equalTo: track.rightAnchor)
    }()
    
    private var leftActiveTrackConstraintLastConstant: CGFloat = .zero
    private var rightActiveTrackConstraintLastConstant: CGFloat = .zero
}
