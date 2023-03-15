//
//  BookingModel.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 07/02/2023.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct BookingModel: Codable {
    @DocumentID var id: String?
    var hotelID: String
    var roomID: String
    var guestID: String
    var bookingDate: Timestamp
    var arrivalDate: Timestamp
    var departureDate: Timestamp
    var roomNumber: Int
    var roomCharge: Double
    var numAdults: Int
    var numChildren: Int
    var specialReq: String
}
