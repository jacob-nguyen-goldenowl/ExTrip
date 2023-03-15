//
//  RoomModel.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 07/02/2023.
//

import Foundation

struct RoomModel: Codable {
    var id: String
    var hotelID: String
    var description: Description?
    var image: [String]
    var price: Double
    var defaultPrice: Double
    var occupancy: Int
    var type: String
    var roomSize: Double
    var numOfRoomSameType: Int
    var taxes: Double
}

struct Description: Codable {
    var bed: Int?
    var bedroom: Int?
    var bathroom: Int?
    var kitchen: Int?
}
