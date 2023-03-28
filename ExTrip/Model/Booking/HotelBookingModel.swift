//
//  HotelBookingModel.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 03/02/2023.
//

import Foundation

struct HotelBookingModel {
    let destination: String?
    let date: FastisValue?
    let room: RoomBookingModel?
    let day: Int
}
