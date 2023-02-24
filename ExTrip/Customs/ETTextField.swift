//
//  ETTextField.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 09/12/2022.
//

import Foundation
import UIKit 
import NotificationCenter

enum ETTextFieldType {
    case email
    case password
    case nomal
}

class ETTextField: UITextField {
    
    // MARK: - Properties
    var isHighlightedOnEdit: Bool = false
    var highlightedColor: UIColor = UIColor.theme.lightBlue ?? .blue
    let rightButton  = UIButton(type: .custom)
    var errorColor: UIColor = UIColor.theme.lightRed ?? .red
    
    var topPlaceholderText: String = "" {
        didSet {
            topPlaceholderLabel.text = topPlaceholderText
        }
    }
    
    var topPlaceholderColor: UIColor = .gray {
        didSet {
            topPlaceholderLabel.textColor = topPlaceholderColor
        }
    }
    
    var separatorLineViewColor: UIColor = UIColor.lightGray {
        didSet {
            separatorLineView.backgroundColor = separatorLineViewColor
        }
    }
    
    var topPlaceholderFont: UIFont = UIFont.systemFont(ofSize: 13) {
        didSet {
            topPlaceholderLabel.font = topPlaceholderFont
        }
    }
    
    var placeholderColor: UIColor = UIColor.lightGray {
        didSet {
            setPlaceholderColor(with: placeholderColor)
        }
    }
    
    var textChangeColor: String = "" {
        didSet {
            attributeStringWithPlaceholder(textChangedColor: textChangeColor)
        }
    }
    
    private var paddingView = UIView()
    
    var textRightOffset: CGFloat = 0 {
        didSet {
            rightViewMode = .always
            paddingView = UIView(frame: CGRect(x: 0, y: 0, width: textRightOffset, height: frame.height))
            rightView = paddingView
        }
    }
    
    private lazy var topPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.poppins(style: .regular)
        label.textColor = topPlaceholderColor
        return label
    }()
    
    private lazy var separatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = separatorLineViewColor
        return view
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView() 
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView() 
    }
    required init(type: ETTextFieldType) {
        super.init(frame: .zero)
        isHighlightedOnEdit = true
        setupTypeTextField(type: type)
        setupView()
    }
    
    // MARK: - Draw
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        clipsToBounds = false
        topPlaceholderLabel.frame = CGRect(x: 0,
                                           y: -15,
                                           width: frame.width,
                                           height: topPlaceholderFont.pointSize * 1.15)
        
        separatorLineView.frame = CGRect(x: 0,
                                         y: frame.height + 5,
                                         width: frame.width,
                                         height: 0.8)
    }

    // MARK: - Setup UI
    private func setupView() {
        setupObservers()
        addSubview(topPlaceholderLabel)
        addSubview(separatorLineView)
    }
    
    private func setPlaceholderColor(with color: UIColor) {
        if placeholder == nil {
            placeholder = " "
        }
        attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: color])
    }
    
    private func setupTypeTextField(type: ETTextFieldType) {
        switch type {
            case .email:
                setupTextField()
                setupImageView()
            case .password:
                setupTextField()
                setupToggleButton()
            case .nomal:
                setupTextField()
                setupNomalTextField()
        }
    }
    
    // MARK: - Observers
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextDidEndEditing), name: UITextField.textDidEndEditingNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextDidBeginEditing), name: UITextField.textDidBeginEditingNotification, object: self)
    }
    
    private func setupToggleButton() {
        rightButton.setImage(UIImage(systemName: "eye.circle.fill") , for: .normal)
        rightButton.addTarget(self, action: #selector(toggleShowHide), for: .touchUpInside)
        rightButton.frame = CGRect(x:0,
                                   y:0,
                                   width:40,
                                   height:40)
        rightViewMode = .always
        rightView = rightButton
        isSecureTextEntry = true
    }
    
    @objc func toggleShowHide(button: UIButton) {
        toggle()
    }
    
    private func toggle() {
        isSecureTextEntry = !isSecureTextEntry
        if isSecureTextEntry {
            rightButton.setImage(UIImage(systemName: "eye.circle.fill") , for: .normal)
        } else {
            rightButton.setImage(UIImage(systemName: "eye.slash.circle.fill") , for: .normal)
        }
    }
    
    private func setupImageView() {
        rightViewMode = .never
    }
    
    private func setupNomalTextField() {
        topPlaceholderLabel.removeFromSuperview()
    }
    
    private func setupTextField() {
        self.tintColor = UIColor.gray
        self.topPlaceholderFont = UIFont.systemFont(ofSize: 13)
        self.textColor = UIColor.gray
        self.placeholderColor = .lightGray
        self.font = UIFont.poppins(style: .light)  
        self.clearButtonMode = .whileEditing
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        textField.text = ""
        return true
    }
    
    private func attributeStringWithPlaceholder(textChangedColor: String) {
        guard let placeholder = self.placeholder else { return }
        let range = (placeholder as NSString).range(of: textChangedColor)
        let attributedText = NSMutableAttributedString.init(string: placeholder)
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: range)
        self.attributedPlaceholder = attributedText
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension ETTextField {
    
    // MARK: - TextField Editing Observer
    @objc func textFieldTextDidEndEditing(notification : NSNotification) {
        if isHighlightedOnEdit {
            separatorLineView.backgroundColor = separatorLineViewColor
        }
        if !text!.isEmpty {
            separatorLineViewColor = .lightGray
        }
        setPlaceholderColor(with: placeholderColor)
        attributeStringWithPlaceholder(textChangedColor: textChangeColor)
    }
    
    @objc func textFieldTextDidBeginEditing(notification : NSNotification) {
        setPlaceholderColor(with: .clear)
        if isHighlightedOnEdit {
            separatorLineView.backgroundColor = highlightedColor
        }
    }
}
