//
//  SignInViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 09/12/2022.
//

import UIKit

class SignInViewController: UIViewController {
    
    private let signInViewModel = SignInViewModel()
    
    // MARK: - Properties
    private let verticalStackView = UIStackView()
    private let signUpStackView = UIStackView()
    
    private lazy var cancelButton: ETCancelButton = {
        let button = ETCancelButton()
        button.delegate = self
        return button
    }()

    private lazy var emailTextField: ETTextField = {
        let textField = ETTextField(type: .email)
        textField.topPlaceholderText = "Your Email / Username"
        textField.placeholder = "Email or Username"
        return textField
    }()
    
    private lazy var passwordTextField: ETTextField = {
        let textField = ETTextField(type: .password)
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
        setupErrorBinder()
        setupSuccessBinder()
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
        view.addSubviews(cancelButton, 
                         verticalStackView,
                         forgetPasswordButton,
                         loginButton, 
                         signUpStackView)
        
        setupConstraintViews()
    }
    
    private func setupConstraintViews() {
        let padding: CGFloat = 30
        
        cancelButton.anchor(top: view.topAnchor,
                            leading: view.leadingAnchor,
                            paddingTop: padding,
                            paddingLeading: 15)
        cancelButton.setWidth(width: 40)
        cancelButton.setHeight(height: 40)
        
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
        loginButton.addTarget(self, action: #selector(handleLoginAction), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(handleRegisterAction), for: .touchUpInside)
    }
    
    // MARK: - Start & stop animate
    private func startAnimation() {
        customActivityIndicatory(self.view)
        loginButton.isUserInteractionEnabled = false
    }
    
    private func stopAnimation() {
        customActivityIndicatory(self.view, startAnimate: false)
        loginButton.isUserInteractionEnabled = true
    }
    
    // MARK: - Binding
    private func setupErrorBinder() {
        signInViewModel.error.bind { [weak self] error in
            guard let self = self else { return }
            if error != nil {
                self.stopAnimation()
                self.showAlert(title: "Notify",
                               message: error,
                               style: .alert)
            }
        }
    }
    
    private func setupSuccessBinder() {
        signInViewModel.success.bind { [weak self] success in
            guard let self = self else { return }
            if success != nil {
                self.stopAnimation()
                self.goToHomePage()
            }
        }
    }
    
    // MARK: - Go to home screen
    private func goToHomePage() {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    } 
    
}

// MARK: - Handle action
extension SignInViewController {
    @objc func handleLoginAction() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              !password.isEmpty,
              !email.isEmpty else {
            stopAnimation()
            showAlert(title: "Notify",
                      message: "Please enter your email and password",
                      style: .alert)
            return 
        }
        if !email.isValidEmail() { 
            stopAnimation()
            showAlert(title: "Notify",
                      message: "Email is not valid",
                      style: .alert)
        } else {
            startAnimation()
            signInViewModel.login(email: email, password: password)
        }
    }
    
    @objc func handleRegisterAction() {
        let vc = SignUpViewController()
        navigationController?.pushViewController(vc, animated: true)
        emailTextField.text = ""
        passwordTextField.text = ""
    }
}

extension SignInViewController: ETCancelButtonDelegate {
    func eTCancelButtonHandleCancelAction() {
        dismiss(animated: true)
    }
}
