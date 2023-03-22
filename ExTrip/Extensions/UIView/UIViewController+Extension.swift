//
//  UIViewController+Extension.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 09/12/2022.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false            
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - show activity indicatory
    @discardableResult
    func customActivityIndicatory(_ view: UIView,
                                  startAnimate: Bool = true) -> UIActivityIndicatorView {
        let mainView = UIView(frame: view.frame)
        mainView.center = view.center
        mainView.backgroundColor = UIColor.gray
        mainView.alpha = 0.7
        mainView.tag = Tag.indicatoryView
        mainView.isUserInteractionEnabled = false
        
        let viewBackgroundLoading = UIView(frame: CGRect(x: 0.0,
                                                         y: 0.0,
                                                         width: 80.0,
                                                         height: 80.0))
        viewBackgroundLoading.center = view.center
        viewBackgroundLoading.backgroundColor = UIColor.theme.black
        viewBackgroundLoading.clipsToBounds = true
        viewBackgroundLoading.layer.cornerRadius = 15
        
        let activityIndicatorView = UIActivityIndicatorView() 
        activityIndicatorView.frame = CGRect(x: 0.0,
                                             y: 0.0,
                                             width: 40.0,
                                             height: 40.0)
        
        let x = viewBackgroundLoading.frame.size.width / 2
        let y = viewBackgroundLoading.frame.size.height / 2
        
        activityIndicatorView.style = .large
        activityIndicatorView.color = UIColor.theme.white
        activityIndicatorView.center = CGPoint(x: x,
                                               y: y)
        
        if startAnimate {
            viewBackgroundLoading.addSubview(activityIndicatorView)
            mainView.addSubview(viewBackgroundLoading)
            view.addSubview(mainView)
            activityIndicatorView.startAnimating()
        } else {
            for subview in view.subviews where subview.tag == Tag.indicatoryView {
                subview.removeFromSuperview()
            }
        }
        return activityIndicatorView
    }
    
    // MARK: - Show alert
    func showAlert(title: String? = nil,
                   message: String? = nil,
                   style: UIAlertController.Style ) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: style)
        
        let closeAction = UIAlertAction(title: "Close", 
                                        style: .cancel)
        alert.addAction(closeAction)
        present(alert, animated: true)
    }
    
    func navigationAction(_ viewController: UIViewController) {
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // Set navigation with subtitle
    func setTitle(title: String, subtitle: String) -> UIView {
        let titleLabel = UILabel(frame: .init(x: 0, y: -2, width: 0, height: 0))
        
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor.gray
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        let subtitleLabel = UILabel(frame: .init(x: 0, y: 18, width: 0, height: 0))
        subtitleLabel.backgroundColor = UIColor.clear
        subtitleLabel.textColor = UIColor.black
        subtitleLabel.font = UIFont.boldSystemFont(ofSize: 11)
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()
        
        let titleView = UIView(frame: .init(x: 0, y: 0, width: max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), height: 30))
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        
        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width
        
        if widthDiff < 0 {
            let newX = widthDiff / 2
            subtitleLabel.frame.origin.x = abs(newX)
        } else {
            let newX = widthDiff / 2
            titleLabel.frame.origin.x = newX
        }
        
        return titleView
    }
    
    // MARK: Open URL
    enum URLStype {
        case service, about
    }

    func openURL(type: URLStype) {
        let urlString: String
        
        switch type {
        case .service, .about:
            urlString = Constant.URL.github
        }
        
        guard let url = URL(string: urlString) else {
            errorAlert(message: "Can't not open \(urlString)")
            return
        }
        UIApplication.shared.open(url)
    }
    
    func errorAlert(message: String) {
        showAlert(title: "Error", message: message, style: .alert)
    }
}
