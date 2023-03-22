//
//  HotelViewModel.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 04/01/2023.
//

import UIKit 

class HotelViewModel: ETViewModel<HotelModel> {
    
    var hotels: Observable<[HotelModel]?> = Observable(nil)
    
    var countryID: String?
    var titleHeader: String = ""
    var scoreDestination: String?
    var titleDestination: String?
    var imageDestination: String?
        
    var bookingID: String? {
        didSet {
            if let bookingID = bookingID, !bookingID.isEmpty {
                fetchRoom(bookingID)
            } else {
                self.emptyData = "Error"
            }
        }
    }
    
    var hotelID: String? {
        didSet {
            if let hotelID = hotelID, !hotelID.isEmpty {
                fetchHotel(hotelID)
            } else {
                self.emptyData = "Error"
            }
        }
    }
        
    var hotel: HotelModel? {
        didSet {
            if hotel != nil {
                self.reloadTableViewClosure?()
            } else {
                self.emptyData = "Error"
            }
        }
    }
    
    var booking: BookingModel?
    
    func fetchLimitData(destinationID: String?) {
        DatabaseResponse.shared.fetchLimitDataById(collection: "hotels",
                                                   filed: "destination_id",
                                                   documentId: destinationID) { (result: [HotelModel]) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.listOfData = result
            }
        }
    }
    
    func fetchAllData(destinationID: String?) {
        DatabaseResponse.shared.fetchLimitDataById(collection: "hotels",
                                                   filed: "destination_id",
                                                   documentId: destinationID) { (result: [HotelModel]) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.hotels.value = result
            }
        }
    }
    
    // Tracker booking detail 
    func fetchHotel(_ hotelID: String) {
        DatabaseRequest.shared.fetchHotel(hotelID) { hotel in
            self.hotel = hotel
        }
    }
    
    func fetchRoom(_ bookingID: String) {
        DatabaseRequest.shared.fetchBooking(bookingID, completion: { booking in
            self.booking = booking
        })
    }

}
