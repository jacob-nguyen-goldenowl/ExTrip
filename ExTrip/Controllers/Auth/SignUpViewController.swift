//
//  SignUpViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 09/12/2022.
//

import UIKit

class SignUpViewController: UIViewController {
    
    // MARK: - Properties        
    private var inputTextStackView = UIStackView()
    private var horizontalStackView = UIStackView()
    
    private lazy var userNameTextField: ETTextField = {
        let textField = ETTextField(type: .nomal)
        textField.placeholder = "Enter full name"
        return textField
    }()
    
    private lazy var stateTextField: ETTextField = {
        let textFiled = ETTextField(type: .nomal)
        textFiled.placeholder = "State*"
        textFiled.textChangeColor = "*"
        return textFiled
    }()
    
    private lazy var cityTextField: ETTextField = {
        let textFiled = ETTextField(type: .nomal)
        textFiled.placeholder = "City*"
        textFiled.textChangeColor = "*"
        return textFiled
    }()
    
    private lazy var emailTextField: ETTextField = {
        let textFiled = ETTextField(type: .nomal)
        textFiled.placeholder = "Enter Email ID*"
        textFiled.textChangeColor = "*"
        return textFiled
    }()
    
    private lazy var specialisationTextField: ETTextField = {
        let textFiled = ETTextField(type: .nomal)
        textFiled.placeholder = "Phone number*"
        textFiled.keyboardType = .decimalPad
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
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Create Account"
        navigationController?.configBackButton()
    }
    
    // MARK: - Setup views
    private func setupView() {
        view.backgroundColor = .systemBackground
        self.hideKeyboardWhenTappedAround()
        view.addSubviews(userNameTextField,
                         inputTextStackView,
                         registerButton)
        setupConstraintView()
        setupInputTextStackView()
    }
    
    private func setupConstraintView() {
        let paddingSize: CGFloat = 30
        
        inputTextStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                  leading: view.leadingAnchor,
                                  trailing: view.trailingAnchor,
                                  paddingTop: 50,
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
                                               horizontalStackView,
                                               specialisationTextField,
                                               passwordTextField)
        inputTextStackView.axis = .vertical
        inputTextStackView.spacing = 50
        inputTextStackView.distribution = .equalCentering
        setupHorizontalStackView()
    }
    
    private func setupHorizontalStackView() {
        horizontalStackView.addArrangedSubviews(stateTextField,
                                                 cityTextField)
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 20
        horizontalStackView.distribution = .fillEqually
    }
}

