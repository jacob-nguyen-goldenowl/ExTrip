//
//  BookingViewModel.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 08/02/2023.
//

import Foundation

struct BookingTime {
    let arrivalDate: Date
    let departureDate: Date
}

class BookingViewModel {
    
    var hotelsRelatedCity: Observable<[HotelModel]?> = Observable(nil)
    var roomAvailible: Observable<[RoomModel]?> = Observable(nil)
    var bookingStatus: Observable<Bool> = Observable(true)

    // MARK: - HOTEL
    func dataHotelByCity(city: String,
                         numberOfRoom: Int,
                         time: BookingTime) {
        DatabaseBooking.shared.filterHotelByCity(city: city, numberOfRoom: numberOfRoom) { status in
            switch status {
            case .success(let hotels):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.checkHotelHasRooms(with: hotels, time: time) { listRoom in
                        self.hotelsRelatedCity.value = hotels
                        self.roomAvailible.value = listRoom
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func dataRoomByOneHotel(_ hotelID: String, time: BookingTime) {
        print(time)
        DatabaseBooking.shared.fetchAllRoomByHotel(hotelId: hotelID) { status in
            var newRooms: [RoomModel] = []
            switch status {
            case .success(let rooms):
                self.checkRoomHasBooking(with: rooms, time: time) { roomAvailable in 
                    newRooms.append(roomAvailable)
                DispatchQueue.main.async { [weak self] in 
                            self?.roomAvailible.value = newRooms 
                }
                }
            case .failure(let error):
                print(error)    
            }
        }
    }
    
    // MARK: - ROOM
    func checkHotelHasRooms(with hotels: [HotelModel], 
                            time: BookingTime,
                            completion: @escaping (([RoomModel]) -> Void)) {
        var newRooms: [RoomModel] = []
        hotels.forEach {
            DatabaseBooking.shared.fetchAllRoomByHotel(hotelId: $0.id) { status in
                switch status {
                case .success(let rooms):
                    self.checkRoomHasBooking(with: rooms, time: time) { roomAvailable in 
                        newRooms.append(roomAvailable)
                        completion(newRooms)
                    }
                case .failure(let error):
                    print(error)    
                }
            }
        }
    }
    
    func checkRoomHasBooking(with rooms: [RoomModel], 
                             time: BookingTime,
                             completion: @escaping ((RoomModel) -> Void)) {
        rooms.forEach {
            self.dataBookingByRoom(room: $0, 
                                   time: time) { (room, isRoomNotAvailable)  in
                if !isRoomNotAvailable {
                    completion(room)
                }
            }
        }
    }
    // MARK: - BOOKING
    func dataBookingByRoom(room: RoomModel,
                           time: BookingTime,
                           completion: @escaping (RoomModel, Bool) -> Void) {
        DatabaseBooking.shared.fetchAllBookingByRoom(roomId: room.id) { status in 
            switch status {
            case .success(let booking):
                if self.checkListBookingDuplicate(time: time, booking: booking) {
                    completion(room, true)
                } else {
                    completion(room, false)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

// MARK: - Check condition
extension BookingViewModel {
    func checkListBookingDuplicate(time: BookingTime, booking: [BookingModel]) -> Bool {
        var numBookingDuplicate: Int = 0
        if booking.isEmpty {
            return false
        }
        booking.forEach {
            if checkBookingTimeDuplicate(arrival: time.arrivalDate,
                                         departure: time.departureDate,
                                         booking: $0) {
                numBookingDuplicate += 1
            }
        }
        return numBookingDuplicate != 0 ? true : false
    }

    func checkBookingTimeDuplicate(arrival arrivalDate: Date,
                                   departure departureDate: Date,
                                   booking: BookingModel) -> Bool {
        if arrivalDate.isGreaterThanOrEqualTo(booking.arrivalDate.timestampToDate()) && arrivalDate.isLessThanOrEqualTo(booking.departureDate.timestampToDate()) {
            return true
        }
        if departureDate.isGreaterThanOrEqualTo(booking.arrivalDate.timestampToDate()) && departureDate.isLessThanOrEqualTo(booking.departureDate.timestampToDate()) {
            return true
        }
        if arrivalDate.isLessThanOrEqualTo(booking.arrivalDate.timestampToDate()) && departureDate.isGreaterThanOrEqualTo(booking.departureDate.timestampToDate()) {
            return true
        }
        return false
    }
    
    // MARK: Add booking
    func addBooking(_ booking: BookingModel) {
        DatabaseBooking.shared.addBooking(booking) { success in
            if success {
                self.bookingStatus.value = true
            } else {
                self.bookingStatus.value = false
            }
        }
    }
}
