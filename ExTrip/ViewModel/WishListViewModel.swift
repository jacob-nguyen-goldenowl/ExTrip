//
//  WishListViewModel.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 03/03/2023.
//

import Foundation

class WishListViewModel: ETViewModel<HotelModel> {
    
    let emptyString = "You don't have any favorites. Why not head to the homepage to find some?"
    let addSuccessful = "Saved to wishlist"
    let addFailure = "Add new failure to wishlist"
    let removeSuccessful = "Remove from wishlist"
    
    var wishlists: [WishListModel] = [WishListModel]()
    
    func fetchDataWishlist() {
        let currentUser = AuthManager.shared.getCurrentUserID()
        requestFetchData(currentUser) { [weak self] result in
            result.forEach {
                self?.getHotelRelatedById(hotelID: $0.hotelID) { [weak self] result in
                    self?.processFetchListHotels(hotel: result)
                }
            }
        }
    }

    func processComparisonHotelId(_ hotelId: String) -> Bool {
        if wishlists.contains(where: { $0.hotelID == hotelId }) {
            return true
        }
        return false
    }
    
    func requestFetchData(_ userId: String, completion: @escaping ([WishListModel]) -> Void) {
        listOfData.removeAll()
        isLoading = true
        DatabaseResponse.shared.fetchDataById(collection: "wishlist",
                                              filed: "userID",
                                              documentId: userId) { [weak self] (result: [WishListModel], error) in
            guard let self = self else { return }
            self.isLoading = false
            if result.isEmpty {
                self.emptyWishlist = self.emptyString
            }
            if let error = error {
                self.alertMessage = error.rawValue
            } else {
                self.wishlists = result
                completion(result)            
            }
        }
    }
    
    func getHotelRelatedById(hotelID: String, completion: @escaping (HotelModel) -> Void ) {
        DatabaseResponse.shared.fetchDataById(collection: "hotels",
                                              filed: "id",
                                              documentId: hotelID) { (result: [HotelModel], error ) in
            if let error = error {
                self.alertMessage = error.localizedDescription
            } else {
                if let hotel = result.first {
                    completion(hotel)
                } else {
                    self.alertMessage = error?.rawValue
                }
            }
        }
    }
    
    private func processFetchListHotels(hotel: HotelModel) {
        if !listOfData.contains(where: { $0.id == hotel.id }) {
            listOfData.append(hotel)
        }
    }
    
    func addWishtlist(with wishlist: WishListModel) {
        FeatureFlags.isUpdateWishlist = true
        DatabaseRequest.shared.addWishList(with: wishlist) { success in
            if success {
                self.alertMessage = self.addSuccessful
                print("add success")
            } else {
                self.alertMessage = self.addFailure
            }
        }
    }
    
    func removeFromWishlist(with hotelId: String) {
        FeatureFlags.isUpdateWishlist = true
        DatabaseRequest.shared.removeWishList(hotelId) { success in
            if success {
                self.alertMessage = self.removeSuccessful
                print("remove success")
            } else {
                self.alertMessage = self.addFailure
            }
        }
    }
    
}
