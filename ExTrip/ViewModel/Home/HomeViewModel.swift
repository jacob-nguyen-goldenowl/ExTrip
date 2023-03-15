//
//  ProfileViewModel.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 14/12/2022.
//

import Foundation

class HomeViewModel {
    
    var destination: Observable<[DestinationModel]?> = Observable(nil)

    func fetchData() {
        DatabaseResponse.shared.fetchData("destinations") { (result: [DestinationModel]) in
            DispatchQueue.main.async { [weak self] in
                self?.destination.value = result
            }
        }
    }
    
}
