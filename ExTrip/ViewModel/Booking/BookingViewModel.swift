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

class BookingViewModel: ETViewModel<HotelModel> {
    
    var bookingStatus: Observable<Bool> = Observable(true)
    
    var hotel: HotelModel?
    var hotelBooking = HotelBookingModel(destination: nil,
                                         date: FastisRange(from: Date.today, to: Date.tomorrow), 
                                         room: RoomBookingModel(room: 1, adults: 2, children: 0, infants: 0), 
                                         day: 1) 
    
    var reloadingTableViewClosure: (() -> Void)?

    var rooms: [RoomModel]? {
        didSet {
            self.reloadingTableViewClosure?()
        }
    }

    // MARK: - HOTEL
    func dataHotelByCity(city: String,
                         numberOfRoom: Int,
                         time: BookingTime) {
        isLoading = true
        DatabaseBooking.shared.filterHotelByCity(city: city, numberOfRoom: numberOfRoom) { status in
            switch status {
            case .success(let hotels):
                self.checkHotelHasRooms(with: hotels, time: time) { rooms in
                    self.rooms = rooms
                }
                self.isLoading = false
                if hotels.isEmpty {
                    self.emptyData = "Empty data"
                } else {
                    self.listOfData = hotels
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchRoomByOneHotel(_ hotelID: String, time: BookingTime) {
        isLoading = true
        DatabaseBooking.shared.fetchAllRoomByHotel(hotelId: hotelID) { status in
            var newRooms: [RoomModel] = []
            switch status {
            case .success(let rooms):
                self.checkRoomHasBooking(with: rooms, time: time) { roomAvailable in 
                    if let room = roomAvailable {
                        newRooms.append(room)
                    }
                DispatchQueue.main.async { [weak self] in
                    if !rooms.isEmpty {
                        self?.rooms = newRooms
                    } else {
                        self?.rooms = []
                    }
                }
                }
                self.isLoading = false
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
                        if let room = roomAvailable {
                            newRooms.append(room)
                        }
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
                             completion: @escaping ((RoomModel?) -> Void)) {
        rooms.forEach {
            self.dataBookingByRoom(room: $0, 
                                   time: time) { (room, isRoomNotAvailable)  in
                if !isRoomNotAvailable {
                    completion(room)
                } else {
                    completion(nil)
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
                let bookingActive = self.filterBooking(booking: booking)
                if self.checkListBookingDuplicate(time: time, booking: bookingActive) {
                    completion(room, true)
                } else {
                    completion(room, false)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func filterBooking(booking: [BookingModel]) -> [BookingModel] {
        let bookingActive = booking.filter { $0.status == "active" }
        return bookingActive
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
