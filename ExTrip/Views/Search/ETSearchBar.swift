//
//  SearchBar.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 13/01/2023.
//

import UIKit

class ETSearchBar: UISearchBar {
    
    var allowShowCancel: Bool = false {
        didSet {
            showsCancelButton = allowShowCancel
        }
    }
    
    private lazy var activityIndicator = UIActivityIndicatorView(style: .medium)
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        activityIndicator.tintColor = .gray
        sizeToFit()
        placeholder = "Search for items, destinations"
        tintColor = UIColor.lightGray
        searchTextField.font = .systemFont(ofSize: 15)
        searchTextField.backgroundColor = .white
        changeColorOfCancelButton()
    }
    
    private func changeColorOfCancelButton() {
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes , for: .normal)
    }
    
    func setLeftImage(_ image: UIImage? = UIImage(named: "search"), with padding: CGFloat = 0, isLoading: Bool) {
        
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        iconImageView.image = tintedImage
        iconImageView.tintColor = .gray
        iconImageView.setHeight(height: 22)
        iconImageView.setWidth(width: 22)
        
        if padding != 0 {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.distribution = .fill
            
            let paddingView = UIView()
            paddingView.setWidth(width: padding)
            paddingView.setHeight(height: padding)
            stackView.addArrangedSubviews(paddingView,
                                          isLoading ? activityIndicator : iconImageView)
            self.searchTextField.leftView = stackView
        } else {
            self.searchTextField.leftView = isLoading ? activityIndicator : iconImageView
        }
        isLoading ? startIndicator() : stopIndicator()
    }
    
    private func startIndicator() {
        activityIndicator.startAnimating()
    }
    
    private func stopIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
    }

}

