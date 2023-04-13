//
//  ProfileTableHeaderView.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 02/03/2023.
//

import UIKit

protocol ProfileTableHeaderViewDelegate: AnyObject {
    func profileTableHeaderViewHandleSignInAction()
}

class ProfileTableHeaderView: UIView {
    
    private let imageSize: CGFloat = 60
    private let paddingSignUp: CGFloat = 15
    private let paddingSignIn: CGFloat = 5
    
    let currentUserId: String?
    let userName = UserDefaults.standard.string(forKey: UserDefaultKey.userName)
    let avatarURL = UserDefaults.standard.string(forKey: UserDefaultKey.userPhotoURL)
    
    weak var delegate: ProfileTableHeaderViewDelegate?
    
    private lazy var avatarImageView: AsyncImageView = {
        let imageView = AsyncImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var nameUserLabel = ETLabel(style: .large, textAlignment: .center, size: 16)
    private lazy var titleProfileLabel = ETLabel(style: .small, textAlignment: .center, size: 14)
    
    private lazy var loginButton: ETRippleButton = {
        let button = ETRippleButton()
        button.setTitle("Sign In/Register", for: .normal)
        button.titleLabel?.font = .poppins(style: .bold, size: 12)
        button.addTarget(self, action: #selector(handleSignInAction), for: .touchUpInside)
        button.trackTouchLocation = true
        button.rippleBackgroundColor = .blue
        button.buttonCornerRadius = 5
        button.backgroundColor = .blue
        return button
    }()
    
    override init(frame: CGRect) {
        let currentUser = AuthManager.shared.currentUser()
        currentUserId = currentUser?.uid
        super.init(frame: frame)
        updateViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateViews() {
        
        setupAvatarUser()
        
        if currentUserId != nil {
            addSubviews(avatarImageView,
                        nameUserLabel)
            
            avatarImageView.setWidth(width: imageSize)
            avatarImageView.setHeight(height: imageSize)
            avatarImageView.layer.cornerRadius = imageSize/2
            avatarImageView.anchor(top: topAnchor,
                                   paddingTop: paddingSignUp)
            avatarImageView.center(centerX: centerXAnchor)
            
            nameUserLabel.anchor(top: avatarImageView.bottomAnchor,
                                 bottom: bottomAnchor,
                                 leading: leadingAnchor,
                                 trailing: trailingAnchor,
                                 paddingTop: paddingSignUp,
                                 paddingBottom: paddingSignUp,
                                 paddingLeading: paddingSignUp,
                                 paddingTrailing: paddingSignUp)
            nameUserLabel.text = userName?.uppercased() ?? "---"
        } else {
            for subview in subviews {
                subview.removeFromSuperview()
            }
            addSubviews(avatarImageView, 
                        titleProfileLabel, 
                        loginButton)
            
            avatarImageView.setWidth(width: imageSize)
            avatarImageView.setHeight(height: imageSize)
            avatarImageView.layer.cornerRadius = imageSize/2
            avatarImageView.anchor(top: topAnchor,
                                   paddingTop: paddingSignIn)
            avatarImageView.center(centerX: centerXAnchor)
            
            titleProfileLabel.anchor(top: avatarImageView.bottomAnchor,
                                     leading: leadingAnchor,
                                     trailing: trailingAnchor,
                                     paddingTop: paddingSignUp,
                                     paddingLeading: paddingSignUp,
                                     paddingTrailing: paddingSignUp)
            titleProfileLabel.text = "Sign In and Plan Your Trip"
            
            loginButton.anchor(top: titleProfileLabel.bottomAnchor, 
                               bottom: bottomAnchor,
                               paddingTop: paddingSignUp,
                               paddingBottom: paddingSignUp)
            loginButton.center(centerX: centerXAnchor)
            loginButton.setWidth(width: 150)
        }
    }
    
    @objc func handleSignInAction() {
        delegate?.profileTableHeaderViewHandleSignInAction()
    }
    
    func setupAvatarUser() {
        avatarImageView.fetchImage(imageURL: avatarURL,
                                   defaultImage: UIImage(named: Constant.Image.defaultImage))
    }
    
}
