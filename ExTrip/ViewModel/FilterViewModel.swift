//
//  FilterViewModel.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 31/01/2023.
//

import Foundation

class FilterViewModel {
    
    var hotelsFilter: Observable<[HotelModel]?> = Observable(nil)
    var errorMsg: Observable<String?> = Observable(nil)
    
    func resultHotelByFilter(filter: FilterModel) {
        DatabaseRequest.shared.filterHotel(filter) { status in
            switch status {
                case .success(let hotels):
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.hotelsFilter.value = hotels
                    }
                case .failure(_):
                    self.errorMsg.value = "Not found"
            }
        }
    }

}
