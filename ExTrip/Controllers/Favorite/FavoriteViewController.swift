//
//  FavoriteViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 14/12/2022.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    private lazy var emptyView: EmptyView = {
        let view = EmptyView()
        view.emptyString = "You don't have any favorites. Why not head to the homepage to find some?"
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setupSubViews()
    }
    
    private func setupSubViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(emptyView)
        emptyView.fillAnchor(view)
    }
}
