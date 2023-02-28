//
//  LottieView.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 28/02/2023.
//

import UIKit
import Lottie

class LottieView: UIView {
    
    var startAnimate: Bool = true {
        didSet {
            setupAnimation()
        }
    }
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var animationView: LottieAnimationView = {
        let animationView = LottieAnimationView()
        let animation = LottieAnimation.named(Tag.Animation.loading)
        animationView.animation = animation
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.loopMode = .loop
        return animationView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .tertiarySystemFill.withAlphaComponent(0.6)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupAnimation() {
        if startAnimate {
            addSubview(containerView)
            containerView.addSubview(animationView)
            containerView.center(centerX: centerXAnchor, centerY: centerYAnchor)
            containerView.setWidth(width: 110)
            containerView.setHeight(height: 110)
            animationView.fillAnchor(containerView, padding: 3)
            animationView.play()
        } else {
            animationView.stop()
            for subview in self.subviews {
                subview.removeFromSuperview()
            }
            self.removeFromSuperview()
        }
    }
    
    func startAnimating() {
        startAnimate = true
    }
    
    func stopAnimating() {
        startAnimate = false
    }
    
}
