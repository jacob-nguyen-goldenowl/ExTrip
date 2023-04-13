//
//  SignUpViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 09/12/2022.
//

import UIKit

class SignUpViewController: UIViewController {
    
    private let signUpViewModel = SignUpViewModel()
    private var user: UserInfoModel?
    // MARK: - Properties        
    private var inputTextStackView = UIStackView()
    
    private lazy var userNameTextField: ETTextField = {
        let textField = ETTextField(type: .nomal)
        textField.placeholder = "Enter full name"
        return textField
    }()
    
    private lazy var cancelButton: ETCancelButton = {
        let button = ETCancelButton()
        button.delegate = self
        return button
    }()

    private lazy var emailTextField: ETTextField = {
        let textFiled = ETTextField(type: .nomal)
        textFiled.placeholder = "Enter Email ID*"
        textFiled.textChangeColor = "*"
        return textFiled
    }()
    
    private lazy var passwordTextField: ETTextField = {
        let textField = ETTextField(type: .nomal)
        textField.placeholder = "Password*"
        textField.textChangeColor = "*"
        return textField
    }()
    
    private lazy var registerButton = ETGradientButton(title: .signUp, style: .mysticBlue)
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        setupErrorBinder()
        setupSuccessBinder()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Create Account"
        navigationController?.configBackButton()
    }
    
    // MARK: - Setup views
    private func setupView() {
        view.backgroundColor = .systemBackground
        self.hideKeyboardWhenTappedAround()
        view.addSubviews(cancelButton,
                         userNameTextField,
                         inputTextStackView,
                         registerButton)
        setupConstraintView()
        setupInputTextStackView()
        registerButton.addTarget(self, action: #selector(handleRegisterButton), for: .touchUpInside)
    }
    
    private func setupConstraintView() {
        let paddingSize: CGFloat = 30
        
        cancelButton.anchor(top: view.topAnchor,
                            leading: view.leadingAnchor,
                            paddingTop: 30,
                            paddingLeading: 20)
        cancelButton.setWidth(width: 40)
        cancelButton.setHeight(height: 40)
        
        inputTextStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                  leading: view.leadingAnchor,
                                  trailing: view.trailingAnchor,
                                  paddingTop: 100,
                                  paddingLeading: paddingSize,
                                  paddingTrailing: paddingSize)
        
        registerButton.anchor(top: inputTextStackView.bottomAnchor,
                              leading: view.leadingAnchor,
                              trailing: view.trailingAnchor,
                              paddingTop: 50,
                              paddingLeading: paddingSize,
                              paddingTrailing: paddingSize)
        registerButton.setHeight(height: 50)
    }
    
    // MARK: Setup input stack views
    private func setupInputTextStackView() {
        inputTextStackView.addArrangedSubviews(userNameTextField,
                                               emailTextField,
                                               passwordTextField)
        inputTextStackView.axis = .vertical
        inputTextStackView.spacing = 40
        inputTextStackView.distribution = .fillEqually
    }

    // MARK: - Start & stop animate
    private func startAnimation() {
        customActivityIndicatory(self.view)
        registerButton.isUserInteractionEnabled = false
    }
    
    private func stopAnimation() {
        customActivityIndicatory(self.view, startAnimate: false)
        registerButton.isUserInteractionEnabled = true
    }
    
    // MARK: - Binding
    private func setupErrorBinder() {
        signUpViewModel.error.bind { [weak self] error in
            guard let strongSelf = self else { return }
            if let error = error {
                strongSelf.stopAnimation()
                strongSelf.showAlert(title: "Notify",
                                     message: error,
                                     style: .alert)
            }
        }
    }
    
    private func setupSuccessBinder() {
        signUpViewModel.success.bind { [weak self] success in
            guard let strongSelf = self else { return }
            if success != nil {
                strongSelf.stopAnimation()
                strongSelf.goToHomePage()
            }
        }
    }
    
    // MARK: - Go to home screen
    private func goToHomePage() {
        let vc = TabbarViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .flipHorizontal
        present(vc, animated: false)
    } 
    
}

// MARK: - Handle action
extension SignUpViewController {
    @objc func handleRegisterButton() { 
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let name = userNameTextField.text,
              !password.isEmpty,
              !email.isEmpty,
              !name.isEmpty else {
            stopAnimation()
            showAlert(title: "Notify",
                      message: "Please enter your information",
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
            user = UserInfoModel(email: email,
                                 name: name,
                                 image: nil) 
            guard let user = user else {
                stopAnimation()
                showAlert(title: "Notify",
                          message: "Failed to create an account. Please re-create",
                          style: .alert)
                return
        }
            signUpViewModel.register(info: user, password: password)
        }
    }
}

extension SignUpViewController: ETCancelButtonDelegate {
    func eTCancelButtonHandleCancelAction() {
        dismiss(animated: true)
    }
}
