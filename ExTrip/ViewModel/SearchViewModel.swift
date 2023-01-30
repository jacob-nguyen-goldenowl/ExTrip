//
//  SearchViewModel.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 14/01/2023.
//

import UIKit

class SearchViewModel {
    
    var result: Observable<[HotelModel]?> = Observable(nil)
    var hotelsRelated: Observable<[HotelModel]?> = Observable(nil)
    
    func resultHotelsByDestination(_ query: String) {
        DatabaseRequest.shared.searchDestination(query: query) { destination in
            destination.forEach {
                DatabaseResponse.shared.fetchDataById(collection: query,
                                                      filed: "destination_id",
                                                      documentId: $0.id) { (result: [HotelModel]) in
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.result.value = result
                    }
                }
            }
        }
    }
    
    func resultHotelByRelatedKeyWord(_ query: String) {
        DatabaseRequest.shared.searchHotelRelatedKeyWord(query) { (hotels) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.hotelsRelated.value = hotels
            }
        }
    }

}
