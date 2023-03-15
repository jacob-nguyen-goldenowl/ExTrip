//
//  ETMainViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 13/03/2023.
//

import UIKit

class ETMainViewController: UIViewController {
    
    var wishListViewModel = WishListViewModel()
    var currentUser = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    private func fetchData() {
        currentUser = AuthManager.shared.getCurrentUserID()
        wishListViewModel.fetchDataWishlist()
    }
    
}
