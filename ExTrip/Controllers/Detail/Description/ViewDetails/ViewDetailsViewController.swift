//
//  ViewDetailsViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 11/01/2023.
//

import UIKit

class ViewDetailsViewController: UIViewController {
    
    private var descriptionText: String = ""
    private var titleHeader: String = ""
    
    init(description: String, title: String) {
        self.descriptionText = description
        self.titleHeader = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(style: .bold, size: 14)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var descriptionTextField: UITextView = {
        let text = UITextView()
        text.font = .poppins(style: .light, size: 13)
        text.sizeToFit()
        text.isEditable = false
        text.isSelectable = false
        return text
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI() 
        setDataDescriptionHotel()
        setupNavigation()
    }
    
    private func setupNavigation() {
        navigationController?.configBackButton()
    }    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        let padding: CGFloat = 10
        view.addSubviews(descriptionTextField, 
                         titleHeaderLabel)
        
        titleHeaderLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, 
                                leading: view.leadingAnchor,
                                trailing: view.trailingAnchor,
                                paddingTop: padding,
                                paddingLeading: padding,
                                paddingTrailing: padding)
        titleHeaderLabel.setHeight(height: 30)
        
        descriptionTextField.anchor(top: titleHeaderLabel.bottomAnchor,
                                    bottom: view.bottomAnchor, 
                                    leading: view.leadingAnchor, 
                                    trailing: view.trailingAnchor,
                                    paddingTop: padding,
                                    paddingBottom: padding,
                                    paddingLeading: padding,
                                    paddingTrailing: padding)
    }
    
    private func noReceiveData() {
        descriptionTextField.text = "No result"
        descriptionTextField.textAlignment = .center
    }
    
    private func setDataDescriptionHotel() {
        descriptionTextField.text = descriptionText.newLineString()
        titleHeaderLabel.text = "Information about \(titleHeader) Hotel"
    }

}
