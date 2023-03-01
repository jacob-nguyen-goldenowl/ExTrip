//
//  EmptyView.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 01/03/2023.
//

import UIKit
import Lottie

class EmptyView: UIView {
    
    var padding: CGFloat = 55 {
        didSet {
            setupAnimation()
        }
    }
    
    var emptyString: String? {
        didSet {
            emptyLabel.text = emptyString
        }
    }
    
    private lazy var emptyLabel = ETLabel(style: .small,
                                          textAlignment: .center,
                                          size: 15, 
                                          numberOfLines: 3)
    
    private lazy var animationView: LottieAnimationView = {
        let animationView = LottieAnimationView()
        let animation = LottieAnimation.named(Tag.Animation.empty)
        animationView.animation = animation
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.loopMode = .loop
        animationView.play()
        return animationView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAnimation() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        self.removeFromSuperview()

        addSubviews(animationView, emptyLabel)
        animationView.center(centerX: centerXAnchor,
                             centerY: centerYAnchor,
                             paddingY: -50)
        animationView.setWidth(width: 150)
        animationView.setHeight(height: 150)
        
        emptyLabel.anchor(top: animationView.bottomAnchor, 
                          leading: leadingAnchor, 
                          trailing: trailingAnchor,
                          paddingLeading: padding,
                          paddingTrailing: padding)
    }

}
