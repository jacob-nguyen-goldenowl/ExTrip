//
//  ETRippleButton.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 28/02/2023.
//

import UIKit
import QuartzCore

class ETRippleButton: UIButton {
    
    var ripplePercent: Float = 0.8 {
        didSet {
            setupRippleView()
        }
    }
    
    var rippleColor: UIColor = UIColor(white: 0.95, alpha: 0.6) {
        didSet {
            rippleView.backgroundColor = rippleColor
        }
    }
    
    var rippleBackgroundColor: UIColor = UIColor(white: 0.95, alpha: 1) {
        didSet {
            rippleBackgroundView.backgroundColor = rippleBackgroundColor
        }
    }
    
    var buttonCornerRadius: Float = 0 {
        didSet {
            layer.cornerRadius = CGFloat(buttonCornerRadius)
        }
    }
    
    var shadowRippleRadius: Float = 1
    var trackTouchLocation: Bool = false
    var touchUpAnimationTime: Double = 0.6
    
    let rippleView = UIView()
    let rippleBackgroundView = UIView()
    
    fileprivate var tempShadowRadius: CGFloat = 0
    fileprivate var tempShadowOpacity: Float = 0
    fileprivate var touchCenterLocation: CGPoint?
    
    fileprivate var rippleMask: CAShapeLayer? {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: bounds,
                                      cornerRadius: layer.cornerRadius).cgPath
        return maskLayer
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    fileprivate func setup() {
        setupRippleView()
        
        rippleBackgroundView.backgroundColor = rippleBackgroundColor
        rippleBackgroundView.frame = bounds
        rippleBackgroundView.addSubview(rippleView)
        rippleBackgroundView.alpha = 0
        addSubview(rippleBackgroundView)
        
        layer.shadowRadius = 0
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowColor = UIColor(white: 0.0, alpha: 0.5).cgColor
    }
    
    fileprivate func setupRippleView() {
        let size: CGFloat = bounds.width * CGFloat(ripplePercent)
        let x: CGFloat = (bounds.width/2) - (size/2)
        let y: CGFloat = (bounds.height/2) - (size/2)
        let corner: CGFloat = size/2
        
        rippleView.backgroundColor = rippleColor
        rippleView.frame = CGRect(x: x, y: y, width: size, height: size)
        rippleView.layer.cornerRadius = corner
    }
    
    override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        if trackTouchLocation {
            touchCenterLocation = touch.location(in: self)
        } else {
            touchCenterLocation = nil
        }
        
        UIView.animate(withDuration: 0.1, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
            self.rippleBackgroundView.alpha = 1
        }, completion: nil)
        
        rippleView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 0.7, delay: 0, options: [UIView.AnimationOptions.curveEaseOut, UIView.AnimationOptions.allowUserInteraction],
                       animations: {
            self.rippleView.transform = CGAffineTransform.identity
        }, completion: nil)

        return super.beginTracking(touch, with: event)
    }
    
    override open func cancelTracking(with event: UIEvent?) {
        super.cancelTracking(with: event)
        animateToNormal()
    }
    
    override open func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        animateToNormal()
    }
    
    fileprivate func animateToNormal() {
        UIView.animate(withDuration: 0.1, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
            self.rippleBackgroundView.alpha = 1
        }, completion: {(_: Bool) -> Void in
            UIView.animate(withDuration: self.touchUpAnimationTime, delay: 0, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                self.rippleBackgroundView.alpha = 0
            }, completion: nil)
        })
        
        UIView.animate(withDuration: 0.7, delay: 0,
                       options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction],
                       animations: {
            self.rippleView.transform = CGAffineTransform.identity
            
            let shadowAnim = CABasicAnimation(keyPath: "shadowRadius")
            shadowAnim.toValue = self.tempShadowRadius
            
            let opacityAnim = CABasicAnimation(keyPath: "shadowOpacity")
            opacityAnim.toValue = self.tempShadowOpacity
            
            let groupAnim = CAAnimationGroup()
            groupAnim.duration = 0.7
            groupAnim.fillMode = CAMediaTimingFillMode.forwards
            groupAnim.isRemovedOnCompletion = false
            groupAnim.animations = [shadowAnim, opacityAnim]
            
            self.layer.add(groupAnim, forKey: "shadowBack")
        }, completion: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupRippleView()
        if let knownTouchCenterLocation = touchCenterLocation {
            rippleView.center = knownTouchCenterLocation
        }
        
        rippleBackgroundView.layer.frame = bounds
        rippleBackgroundView.layer.mask = rippleMask
    }
}
