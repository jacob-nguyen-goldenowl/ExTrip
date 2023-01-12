//
//  ProfileViewModel.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 14/12/2022.
//

import Foundation

class HomeViewModel {
    
    var welcomeMessage: Observable<String?> = Observable(nil)
    var destination: Observable<[DestinationModel]?> = Observable(nil)
    
    func welcomTitle() {
        let user = UserManager.shared.getUserInfo()
        if let name = user?.name?.prefix(4) {
            self.welcomeMessage.value = "Hi \(name)!"
        } else {
            print("Error when get name!")
        }
    }
    
    func fetchData() {
        DatabaseResponse.shared.fetchData("destinations") { (result: [DestinationModel]) in
            DispatchQueue.main.async { [weak self] in
                self?.destination.value = result
            }
        }
    }
    
}
