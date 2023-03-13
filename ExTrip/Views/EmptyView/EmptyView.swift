//
//  EmptyView.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 03/03/2023.
//

import UIKit
import Lottie

protocol EmptyViewDelgate: AnyObject {
    func emptyViewHandleSignIn()
}

class EmptyView: UIView {
    
    weak var delegate: EmptyViewDelgate?
        
    var shouldHidenView: Bool = true {
        didSet {
            setupEmptyView()
        }
    }
    
    var isLogin: Bool = false {
        didSet {
            setupEmptyView()
        }
    }

    private let padding: CGFloat = 50
    private let paddingTop: CGFloat = 20
    
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
        let animation = LottieAnimation.named(Constant.Animation.emptyBox)
        animationView.animation = animation
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.loopMode = .loop
        animationView.play()
        return animationView
    }()
    
    private lazy var signInButton: ETRippleButton = {
        let button = ETRippleButton()
        button.setTitle("Sign in", for: .normal)
        button.titleLabel?.font = .poppins(style: .bold, size: 14)
        button.addTarget(self, action: #selector(handleSignInAction), for: .touchUpInside)
        button.trackTouchLocation = true
        button.rippleBackgroundColor = .blue
        button.buttonCornerRadius = 5
        button.backgroundColor = .blue
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupEmptyView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupEmptyView() {
        if shouldHidenView {
            addSubviews(animationView,
                        emptyLabel, 
                        signInButton)
            
            animationView.center(centerX: centerXAnchor,
                                 centerY: centerYAnchor,
                                 paddingY: -100)
            animationView.setWidth(width: 200)
            animationView.setHeight(height: 200)
            
            emptyLabel.anchor(top: animationView.bottomAnchor, 
                              leading: leadingAnchor, 
                              trailing: trailingAnchor,
                              paddingTop: paddingTop,
                              paddingLeading: padding,
                              paddingTrailing: padding)
            if isLogin {
                signInButton.isHidden = true
            } else {
                signInButton.anchor(top: emptyLabel.bottomAnchor, 
                                    paddingTop: paddingTop)
                signInButton.center(centerX: centerXAnchor)
                signInButton.setWidth(width: 150)
                signInButton.setHeight(height: 50)
            }
        } else {
            for subview in self.subviews {
                subview.removeFromSuperview()
            }
            self.removeFromSuperview()
        }
    }
    
    @objc func handleSignInAction() {
        delegate?.emptyViewHandleSignIn()
    }
    
    func showEmptyView() {
        shouldHidenView = true
        let currentUserID = AuthManager.shared.getCurrentUserID()
        if !currentUserID.isEmpty {
            isLogin = true
        } else {
            isLogin = false
        }
    }
    
    func hiddenEmptyView() {
        shouldHidenView = false
    }
    
}
