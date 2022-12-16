//
//  DestinationModel.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 14/12/2022.
//

import UIKit

struct Photo {
    
    var country: String
    var rating: String
    var image: UIImage
    
    
    init(country: String, rating: String, image: UIImage) {
        self.country = country
        self.rating = rating
        self.image = image
    }
    
    init?(dictionary: [String: String]) {
        guard let country = dictionary["Country"], let rating = dictionary["Rating"], let photo = dictionary["Photo"],
              let image = UIImage(named: photo) else {
            return nil
        }
        self.init(country: country, rating: rating, image: image)
    }
    
    static func allPhotos() -> [Photo] {
        var photos = [Photo]()
        guard let URL = Bundle.main.url(forResource: "Photos", withExtension: "plist"),
              let photosFromPlist = NSArray(contentsOf: URL) as? [[String:String]] else {
            return photos
        }
        for dictionary in photosFromPlist {
            if let photo = Photo(dictionary: dictionary) {
                photos.append(photo)
            }
        }
        return photos
    }
    
}
