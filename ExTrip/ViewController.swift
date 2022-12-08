//
//  ViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 08/12/2022.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var button = ETGradientButton(title: .skip, style: .small)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(button)
        button.frame = CGRect(x: 50, y: 100, width: view.frame.width - 100, height: 50)
    }


}

