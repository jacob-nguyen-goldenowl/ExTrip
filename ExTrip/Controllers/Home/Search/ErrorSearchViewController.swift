//
//  ErrorSearchViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 16/01/2023.
//

import UIKit

class ErrorSearchViewController: UIViewController {
    
    let cryImage = UIImage(named: "cry")
    let errorText = "Sorry, we couldn't find any result"
    
    private lazy var searchBar: ETSearchBar = {
        let searchBar = ETSearchBar()
        searchBar.delegate = self
        searchBar.allowShowCancel = true
        searchBar.setLeftImage(isLoading: false)
        return searchBar
    }()
    
    private let errorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.text = errorText
        label.textAlignment = .center
        label.font = .poppins(style: .bold, size: 14)
        return label
    }()
    
    private lazy var errorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = cryImage
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.theme.primary
        view.addSubviews(errorView)
        errorView.addSubviews(errorImageView, 
                              errorLabel)
        setupConstraintView()
    }
    
    private func setupNavigationBar() {
        navigationController?.configBackButton()
        navigationItem.titleView = searchBar
        
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.barTintColor = UIColor.theme.primary
    }
    
    private func setupConstraintView() {
        let imageSize: CGFloat = 150
        let padding: CGFloat = 20
        errorView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         bottom: view.bottomAnchor,
                         leading: view.leadingAnchor,
                         trailing: view.trailingAnchor)
        
        errorImageView.center(centerX: view.centerXAnchor,
                              centerY: view.centerYAnchor)
        errorImageView.setWidth(width: imageSize)
        errorImageView.setHeight(height: imageSize)
        
        errorLabel.anchor(top: errorImageView.bottomAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor,
                          paddingTop: padding,
                          paddingLeading: padding,
                          paddingTrailing: padding)
    }

    private func popViewControler() {
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - UISearchBarDelegate
extension ErrorSearchViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        popViewControler()
        return true
    }
}
