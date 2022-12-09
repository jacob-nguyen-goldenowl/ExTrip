//
//  SignInViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 09/12/2022.
//

import UIKit

class SignInViewController: UIViewController {
    
    // MARK: - Properties
    private let verticalStackView = UIStackView()
    private let signUpStackView = UIStackView()

    private lazy var emailTextField: HCTextField = {
        let textField = HCTextField(type: .email)
        textField.topPlaceholderText = "Your Email / Username"
        textField.placeholder = "Email or Username"
        return textField
    }()
    
    private lazy var passwordTextField: HCTextField = {
        let textField = HCTextField(type: .password)
        textField.topPlaceholderText = "Password"
        textField.placeholder = "Password"
        return textField
    }()
    
    private lazy var forgetPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Forget Password?", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.poppins(style: .regular)
        return button
    }()
    
    private lazy var signUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Don't have Account? "
        label.font = UIFont.poppins(style: .regular)
        label.textColor = UIColor.theme.gray
        return label
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.poppins(style: .regular)
        button.setTitleColor(UIColor.theme.lightBlue ?? .blue, for: .normal)
        return button
    }()
    
    private lazy var loginButton = ETGradientButton(title: .signIn, style: .mysticBlue)

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
        setupStackView()
        setupActionButton()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Sign Up"
        navigationController?.configBackButton()
    }
    
    // MARK: - Setup UI
    private func setupViews() {
        navigationController?.configBackButton()
        self.hideKeyboardWhenTappedAround() 

        view.backgroundColor = .systemBackground
        view.addSubviews(verticalStackView,
                         forgetPasswordButton,
                         loginButton, 
                         signUpStackView)
        
        setupConstraintViews()
    }
    
    private func setupConstraintViews() {
        let padding: CGFloat = 30
        
        verticalStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                 leading: view.leadingAnchor,
                                 trailing: view.trailingAnchor,
                                 paddingTop: 70,
                                 paddingLeading: padding,
                                 paddingTrailing: padding)
        verticalStackView.setHeight(height: 130)
        
        forgetPasswordButton.anchor(top: verticalStackView.bottomAnchor, 
                                    trailing: view.trailingAnchor,
                                    paddingTop: padding, 
                                    paddingTrailing: padding)
        forgetPasswordButton.setHeight(height: 20)
        
        loginButton.anchor(top: forgetPasswordButton.bottomAnchor, 
                           leading: view.leadingAnchor,
                           trailing: view.trailingAnchor,
                           paddingTop: padding,
                           paddingLeading: padding,
                           paddingTrailing: padding)
        loginButton.setHeight(height: 50)
        
        signUpStackView.anchor(top: loginButton.bottomAnchor,
                               paddingTop: padding)
        signUpStackView.center(centerX: view.centerXAnchor)
    }
    
    private func setupStackView() {
        verticalStackView.addArrangedSubviews(emailTextField,
                                              passwordTextField)
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fillEqually
        verticalStackView.spacing = 50
        
        signUpStackView.addArrangedSubviews(signUpLabel,
                                            registerButton)
        signUpStackView.spacing = 5
    }
    
    // MARK: - Setup action
    private func setupActionButton() {
        loginButton.addTarget(self, action: #selector(handleLoginButton), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(handleRegisterButton), for: .touchUpInside)
    }
}

// MARK: - Handle action
extension SignInViewController {
    @objc func handleLoginButton() {
        // Code here ...
    }
    
    @objc func handleRegisterButton() {
        let vc = SignUpViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
