//
//  InfoUserTableViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 17/02/2023.
//

import UIKit

protocol InfoUserTableViewCellDelegate {
    func infoUserTableViewCellHandleChooseRoomNavigation(_ data: InfoUserTableViewCell) 
}

class InfoUserTableViewCell: ETTableViewCell {
    
    static let identifier = "InfoUserTableViewCell"
    
    var fullNameCallBack: ((String?) -> Void)?
    var emailCallBack: ((String?) -> Void)?
    var phoneCallBack: ((String?) -> Void)?

    let countries = ["VietNam": "+84", "English": "+44"]
    lazy var countriesKeys = Array(countries.keys)
    lazy var countriesValues = Array(countries.values)
    
    private lazy var countryPickerView = UIPickerView()
    
    private var user: UserInfoModel?
    var indexPath: IndexPath?
    
    var numberOfRoom: Int = 1 {
        didSet {
            chooseRoomButton.numberOfRoom = numberOfRoom
        }
    }

    var delegate: InfoUserTableViewCellDelegate?
    
    // Header
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubviews(titleInfoLabel,
                                      chooseRoomButton)
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var titleInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blue
        label.text = "User info"
        label.font = .poppins(style: .bold, size: 14)
        return label
    }()
    
    private lazy var chooseRoomButton = ETRoomButton()

    // Body
    private lazy var inputTextStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubviews(userNameTextField,
                                      emailTextField,
                                      phoneTextField)
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .equalCentering
        return stackView
    }()

    lazy var userNameTextField: ETTextField = {
        let textField = ETTextField(type: .nomal)
        textField.placeholder = "Enter full name"
        textField.addTarget(self, action: #selector(handleFullNameAction), for: .editingDidEnd)
        return textField
    }()
        
    lazy var phoneTextField: ETTextField = {
        let textField = ETTextField(type: .nomal)
        textField.placeholder = "Enter your phone"
        textField.keyboardType = .decimalPad
        textField.addTarget(self, action: #selector(handlePhoneAction), for: .editingDidEnd)
        setupChooseCountry(textField)  
        return textField
    }()
    
    lazy var emailTextField: ETTextField = {
        let textField = ETTextField(type: .nomal)
        textField.placeholder = "Enter email"
        textField.addTarget(self, action: #selector(handleEmailAction), for: .editingDidEnd)
        return textField
    }()

    // MARK: - INIT
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        emailCallBack?(emailTextField.text)
    }
    
    private func setupUI() {
        setupSubView()
        checkCurrentUser()
        setupAction()
        dismissAndClosePickerView()
        setupNotificationCenter()
    }

    private func setupSubView() {
        countryPickerView.delegate = self
        countryPickerView.dataSource  = self
        contentView.addSubviews(headerStackView,
                                inputTextStackView)
        setupConstraintView()
    }
    
    private func setupConstraintView() {
        let paddingTop: CGFloat = 10
        let paddingSize: CGFloat = 30
                                
        headerStackView.anchor(top: contentView.topAnchor,
                               leading: contentView.leadingAnchor,
                               trailing: contentView.trailingAnchor, 
                               paddingTop: paddingTop,
                               paddingLeading: paddingSize,
                               paddingTrailing: paddingSize)
        headerStackView.setHeight(height: 30)
        chooseRoomButton.setWidth(width: 80)
        
        inputTextStackView.anchor(top: headerStackView.bottomAnchor,
                                  bottom: contentView.bottomAnchor,
                                  leading: contentView.leadingAnchor,
                                  trailing: contentView.trailingAnchor,
                                  paddingBottom: paddingSize,
                                  paddingLeading: paddingSize,
                                  paddingTrailing: paddingSize)
        
        userNameTextField.setHeight(height: 30)
    }
    
    // MARK: - Setup left phone code 
    private lazy var leftTextField = UITextField()
    private lazy var outerView = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 30))
    
    private lazy var leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.changeColorImage(image: UIImage(named: "expand"),
                                   color: UIColor.theme.lightGray ?? .lightGray)
        return imageView
    }()
    
    private func setupChooseCountry(_ textField: UITextField) {
        let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
        stackView.axis = .horizontal
        stackView.addArrangedSubviews(leftTextField,
                                      leftImageView)
                
        leftTextField.textColor = .black
        leftTextField.inputView = countryPickerView
        leftTextField.text = countries.first?.value
        outerView.addSubview(stackView)
        textField.leftView = outerView
        textField.leftViewMode = .always
    }
    
    private func dismissAndClosePickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(handleDissmisAction))
        button.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.blue], for: .normal)
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        leftTextField.inputAccessoryView = toolBar
    }
    
    @objc func handleDissmisAction() {
        self.endEditing(true)
    }

    private func checkCurrentUser() {
        let email = UserDefaults.standard.string(forKey: UserDefaultKey.userEmail)
        emailTextField.text = email
    }
    
    private func setupAction() {
        chooseRoomButton.addTarget(self, action: #selector(handleChooseRoomButton), for: .touchUpInside)
    }
    
}

extension InfoUserTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countriesKeys[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        leftTextField.text = countriesValues[row]
        phoneTextField.resignFirstResponder()
    }
}

// MARK: - Handle action
extension InfoUserTableViewCell {
    @objc func handleChooseRoomButton() {
        delegate?.infoUserTableViewCellHandleChooseRoomNavigation(self)
    }
    
    @objc func handleFullNameAction() {
        fullNameCallBack?(userNameTextField.text)
    }
    
    @objc func handleEmailAction() {
        emailCallBack?(emailTextField.text)
    }
    
    @objc func handlePhoneAction() {
        phoneCallBack?(phoneTextField.text)
    }  
    
    // MARK: - Notification center
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNameEmptyAction(_:)),
                                               name: NSNotification.Name(UserDefaultKey.checkEmptyNotify),
                                               object: nil)
    }
    
    @objc func handleNameEmptyAction(_ notification: Notification) {
        if let name = userNameTextField.text, name.isEmpty {
            userNameTextField.separatorLineViewColor = .red
        } 
        if let email = emailTextField.text, email.isEmpty {
            emailTextField.separatorLineViewColor = .red
        }
        if let phone = phoneTextField.text, phone.isEmpty {
            phoneTextField.separatorLineViewColor = .red
        }
    }
}
