//
//  FilterModel.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 31/01/2023.
//

import Foundation

struct FilterModel {
    let price: Price
    let star: Int?
    let service: [String]
    let rating: Double
    let positionService: [IndexPath]
    let property: [String]
    let positionProperty: [IndexPath]
    let bed: [String]
    let positionBed: [IndexPath]
    let payment: [String]
    let positionPayment: [IndexPath]
}
