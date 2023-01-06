//
//  DestinationModel.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 14/12/2022.
//

import UIKit

struct Destination {
    
    var id: String
    var country: String
    var rating: String
    var image: String
    
    init(id: String, country: String, rating: String, image: String) {
        self.id = id
        self.country = country
        self.rating = rating
        self.image = image
    }
    
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"],
              let country = dictionary["country"],
              let rating = dictionary["rating"],
              let image = dictionary["image"] else {
            return nil
        }
        
        self.init(id: id as! String,
                  country: country as! String,
                  rating: rating as! String,
                  image: image as! String)
    }
    
}

