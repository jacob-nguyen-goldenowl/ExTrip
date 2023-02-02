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
    var price: Double
    var image: [String]
    var rating: Double
    var review: String
    var like: Bool
    var numberOfRoom: String
    var star: Double
    var thumbnail: String
    var location: Location
    var type: String
    var address: String
    var road: String
    var kmFromCenter: Double

}

struct Location: Codable {
    var description: String
    var longitude: String
    var latitude: String
}
