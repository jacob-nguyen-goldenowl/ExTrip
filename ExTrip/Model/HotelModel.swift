//
//  HotelModel.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 04/01/2023.
//

import Foundation

struct HotelModel: Codable {
    
    var id: String
    var name: String
    var description: String
    var price: String
    var image: [String]
    var rating: String
    var review: String
    var like: Bool
    var numberOfRoom: String
    var star: String
    var thumbnail: String
    var location: Location
    var type: String
    var address: String

}

struct Location: Codable {
    var description: String
    var longitude: String
    var latitude: String
}
