//
//  MainViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 08/12/2022.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "background")
        return imageView
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Or"
        label.textColor = UIColor.theme.black ?? .black
        label.font = .poppins(style: .medium)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private let horizontalStackView = UIStackView()
    
    private lazy var signInButton = ETGradientButton(title: .signIn,
                                                     style: .nomal,
                                                     backgroundColor: UIColor.theme.black, 
                                                     titleColor: UIColor.theme.white)
    private lazy var signUpButton = ETGradientButton(title: .signUp,
                                                     style: .nomal)
    
    private lazy var facebookButton = ETIconButton(style: .facebook)
    private lazy var googleButton = ETIconButton(style: .google)

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupActionButton()
    }
    
    // MARK: - Setup UI
    private func setupViews() {
        view.backgroundColor = .systemBackground
        navigationController?.configBackButton()
        view.insertSubview(backgroundImageView, at: 0)
        view.addSubview(facebookButton)
        view.addSubviews(horizontalStackView,
                         subtitleLabel,
                         googleButton)
        setupConstraintViews()
        setupStackView()
    }
    
    private func setupConstraintViews() {
        let padding: CGFloat = 15
        let heightButton: CGFloat = 50
        
        backgroundImageView.fillAnchor(view)
        horizontalStackView.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                   leading: view.leadingAnchor,
                                   trailing: view.trailingAnchor,
                                   paddingBottom: 50,
                                   paddingLeading: padding,
                                   paddingTrailing: padding)
        horizontalStackView.setHeight(height: heightButton)
        
        subtitleLabel.anchor(bottom: horizontalStackView.topAnchor,
                             leading: backgroundImageView.leadingAnchor,
                             trailing: backgroundImageView.trailingAnchor,
                             paddingBottom: padding)
        subtitleLabel.setHeight(height: 30)
        
        facebookButton.anchor(bottom: subtitleLabel.topAnchor,
                              leading: backgroundImageView.leadingAnchor, 
                              trailing: backgroundImageView.trailingAnchor,
                              paddingBottom: padding,
                              paddingLeading: padding,
                              paddingTrailing: padding)
        facebookButton.setHeight(height: heightButton)
        
        googleButton.anchor(bottom: facebookButton.topAnchor,
                            leading: backgroundImageView.leadingAnchor, 
                            trailing: backgroundImageView.trailingAnchor,
                            paddingBottom: padding,
                            paddingLeading: padding,
                            paddingTrailing: padding)
        googleButton.setHeight(height: heightButton)
    }

    // MARK: - Setup stackview
    private func setupStackView() {
        horizontalStackView.addArrangedSubviews(signInButton,
                                                signUpButton)
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fillEqually
        horizontalStackView.spacing = 20
    }
    
    // MARK: - Setup action
    fileprivate func setupActionButton() {
        facebookButton.addTarget(self, action: #selector(handleFacebookAction), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(handleGoogleAction), for: .touchUpInside)
        signInButton.addTarget(self, action: #selector(handleSignInAction), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(handleSignUpAction), for: .touchUpInside)
    }
}

// MARK: - Handle action
extension MainViewController {
    @objc func handleFacebookAction() {
    }

    @objc func handleGoogleAction() {
    }
    
    @objc func handleSignInAction() {
        let vc = SignInViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func handleSignUpAction() {
        let vc = SignUpViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
