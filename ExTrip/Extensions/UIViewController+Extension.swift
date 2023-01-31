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
            for subview in view.subviews{
                if subview.tag == Tag.indicatoryView {
                    subview.removeFromSuperview()
                }
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
}
