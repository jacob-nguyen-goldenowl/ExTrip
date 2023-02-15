//
//  SearchViewModel.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 14/01/2023.
//

import UIKit

class SearchViewModel {
    
    var hotelsRelated: Observable<[HotelModel]?> = Observable(nil)
    var hotelsRelatedAddress: Observable<[HotelModel]?> = Observable(nil)
    var firstRoomByHotel: Observable<[RoomModel]?> = Observable(nil)
    var firstHotel: Observable<HotelModel?> = Observable(nil)
        
    func resultHotelByRelatedKeyWord(_ query: String) {
        DatabaseRequest.shared.searchHotelRelatedKeyWord(query) { (hotels) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.hotelsRelated.value = hotels
            }
        }
    }
    
    func resultHotelRelatedAddress(_ query: String) {
        DatabaseRequest.shared.searchHotelRelatedAddress(query) { (hotels) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.hotelsRelatedAddress.value = hotels
            }
        }
    }

    func resultHotelByName(with nameHotel: String) {
        DatabaseRequest.shared.searchEqualToFiled(collection: "hotels",
                                                  field: "name",
                                                  query: nameHotel) { (hotel: [HotelModel]) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.firstHotel.value = hotel.first
            }
        }
    }
        
}
