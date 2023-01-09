//
//  HotelModel.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 04/01/2023.
//

import Foundation

struct HotelModel {
    
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
    
    init(id: String,
         name: String,
         description: String,
         price: String,
         image: [String],
         rating: String,
         review: String,
         like: Bool,
         numberOfRoom: String,
         star: String) {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.image = image
        self.rating = rating
        self.review = review
        self.like = like
        self.numberOfRoom = numberOfRoom
        self.star = star
    }
    
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"],
              let name = dictionary["name"],
              let description = dictionary["description"],
              let price = dictionary["price"],
              let image = dictionary["image"],
              let rating = dictionary["rating"],
              let review = dictionary["review"],
              let like = dictionary["like"],
              let numberOfRoom = dictionary["numberOfRoom"],
              let star = dictionary["star"] else { return nil }
        
        self.init(id: id as! String,
                  name: name as! String,
                  description: description as! String,
                  price: price as! String,
                  image: image as! [String],
                  rating: rating as! String,
                  review: review as! String,
                  like: like as! Bool,
                  numberOfRoom: numberOfRoom as! String,
                  star: star as! String)
    }
}

