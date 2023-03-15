//
//  TrackerBookingViewModel.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 15/03/2023.
//

import UIKit

struct BookingCellViewModel {
    let id: String?
    let arrivaleDate: String
    let departureDate: String
    let numberOfRoom: Int
    let roomChange: Double
}

class TrackerBookingViewModel: ETViewModel<BookingModel> {
    
    let emptyString = "You don't have any favorites. Why not head to the homepage to find some?"
    
    func requestFetchData(_ status: String) {
        let currentUser = AuthManager.shared.getCurrentUserID()
        isLoading = true
        DatabaseResponse.shared.fetchDataById(collection: "booking",
                                              filed: "guestID",
                                              documentId: currentUser) { [weak self] (result: [BookingModel], error) in
            guard let self = self else { return }
            self.isLoading = false
            if result.isEmpty {
                self.emptyWishlist = self.emptyString
            }
            if let error = error {
                self.alertMessage = error.rawValue
            } else {
                let bookings = result.filter { $0.status == status }
                self.listOfData = bookings
            }
        }
    }
    
    func createCellViewModel(booking: BookingModel) -> BookingCellViewModel {
        let bookingID: String? = booking.id
        let arrivalDate: String = booking.arrivalDate.timestampToDate().displayMonthString
        let departureDate: String = booking.departureDate.timestampToDate().displayMonthString
        let numberOfRoom: Int = booking.roomNumber
        let totalPrice = booking.roomCharge
        return BookingCellViewModel(id: bookingID,
                                    arrivaleDate: arrivalDate,
                                    departureDate: departureDate,
                                    numberOfRoom: numberOfRoom, 
                                    roomChange: totalPrice)
    }
    
}
