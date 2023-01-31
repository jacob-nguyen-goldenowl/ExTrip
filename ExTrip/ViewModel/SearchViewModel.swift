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
    
    func resultHotelByRelatedKeyWord(_ query: String) {
        DatabaseRequest.shared.searchHotelRelatedKeyWord(query) { (hotels) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.hotelsRelated.value = hotels
            }
        }
    }

}
