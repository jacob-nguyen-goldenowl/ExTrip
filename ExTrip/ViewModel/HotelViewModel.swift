//
//  HotelViewModel.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 04/01/2023.
//

import UIKit 

class HotelViewModel {
    
    var hotels: Observable<[HotelModel]?> = Observable(nil)
    var limitHotels: Observable<[HotelModel]?> = Observable(nil)
    
    func fetchLimitData(destinationID: String?) {
        DatabaseResponse.shared.fetchLimitDataById(collection: "hotels",
                                                   filed: "destination_id",
                                                   documentId: destinationID) { (result: [HotelModel]) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.limitHotels.value = result
            }
        }
    }
    
    func fetchAllData(destinationID: String?) {
        DatabaseResponse.shared.fetchLimitDataById(collection: "hotels",
                                                   filed: "destination_id",
                                                   documentId: destinationID) { (result: [HotelModel]) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.hotels.value = result
            }
        }
    }
    
}
