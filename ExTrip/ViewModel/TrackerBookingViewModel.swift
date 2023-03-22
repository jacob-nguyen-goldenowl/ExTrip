//
//  TrackerBookingViewModel.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 15/03/2023.
//

import UIKit

class TrackerBookingViewModel: ETViewModel<BookingModel> {
    
    let activeEmptyString = "You haven't started any trips yet. Once you make a booking, it'll appear here."
    let passEmptyString = "Here you can refer to all past trips and get inspiration for your next ones."
    let cancelEmptyString = "Here you can refer to all the trips you've canceled."
    
    func requestFetchData(_ status: String) {
        let currentUser = AuthManager.shared.getCurrentUserID()
        isLoading = true
        DatabaseResponse.shared.fetchDataById(collection: "booking",
                                              filed: "guestID",
                                              documentId: currentUser) { [weak self] (result: [BookingModel], error) in
            guard let self = self else { return }
            self.isLoading = false
            if result.isEmpty {
                self.emptyData = "Empty"
            }
            if let error = error {
                self.alertMessage = error.rawValue
            } else {
                let bookings = result.filter { $0.status == status }
                if bookings.isEmpty {
                    self.emptyData = "Empty"
                }
                self.listOfData = bookings
            }
        }
    }
    
    func createCellViewModel(booking: BookingModel) -> TrackerBookingModel {
        let bookingID: String? = booking.id
        let arrivalDate: String = booking.arrivalDate.timestampToDate().displayMonthString
        let departureDate: String = booking.departureDate.timestampToDate().displayMonthString
        let numberOfRoom: Int = booking.roomNumber
        let totalPrice = booking.roomCharge
        let status = booking.status
        return TrackerBookingModel(id: bookingID,
                                   arrivaleDate: arrivalDate,
                                   departureDate: departureDate,
                                   numberOfRoom: numberOfRoom, 
                                   roomChange: totalPrice,
                                   status: status)
    }
    
    func updateBooking(_ bookingID: String?, status: String) {
        guard let bookingID = bookingID else { return }
        DatabaseRequest.shared.updateField(bookingID, status: status) { result in
            if result {
                print("update success")
            } else {
                print("update failed")
            }
        }
    }

}
