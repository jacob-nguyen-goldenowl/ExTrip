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
        setupBinders()
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
    private func setupBinders() {
        signInViewModel.errorMessage.bind { [weak self] error in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.stopAnimation()
                strongSelf.showAlert(title: "Notify",
                          message: error,
                          style: .alert)
            } else {
                strongSelf.stopAnimation()
                strongSelf.goToHomePage()
            }
        }
    }
    
    // MARK: - Go to home screen
    private func goToHomePage() {
        // Code here ...
        print("Home page")
    } 
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}

// MARK: - Handle action
extension SignInViewController {
    @objc func handleLoginButton() {
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
        if !isValidEmail(email) { 
            stopAnimation()
            showAlert(title: "Notify",
                      message: "Email is not valid",
                      style: .alert)
        } else {
            startAnimation()
            signInViewModel.login(email: email, password: password)
        }
    }
    
    @objc func handleRegisterButton() {
        let vc = SignUpViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
