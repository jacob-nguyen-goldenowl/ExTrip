//
//  RoomModel.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 27/12/2022.
//

import Foundation

struct RoomModel {
    var room: Int
    var adults: Int
    var children: Int
    var infants: Int

    func room(room: Int, adults: Int, children: Int, infants: Int) -> RoomModel {
        return RoomModel(room: room, adults: adults, children: children, infants: infants)
    }
    
    func numberOfGuest(adults: Int, children: Int, infants: Int) -> Int {
        return adults + children + infants
    }
}

