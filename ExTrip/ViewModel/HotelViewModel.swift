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
        DatabaseManager.shared.fetchLimitOfHotels(destinationID) { hotels in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.limitHotels.value = hotels
            }
        }
    }
    
    func fetchAllData(destinationID: String?) {
        DatabaseManager.shared.fetchAllHotels(destinationID) { hotels in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.hotels.value = hotels
            }
        }
    }
    
}
