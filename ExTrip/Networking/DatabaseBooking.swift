//
//  DatabaseBooking.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 08/02/2023.
//

import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

class DatabaseBooking {
    
    static let shared = DatabaseBooking()
    private init() {}
    
    private let db = Firestore.firestore()
    
    // MARK: - Fetch all hotels
    func filterHotelByCity(city: String, numberOfRoom: Int, completion: @escaping (Result<[HotelModel], Error>) -> Void) {
        db.collection("hotels")
            .whereField("city", isEqualTo: city)
            .whereField("numberOfRoom", isGreaterThanOrEqualTo: numberOfRoom)
            .getDocuments { querySnapshot, error in
                var currentData: [HotelModel] = []
                if let querySnapshot = querySnapshot {
                    currentData = querySnapshot.documents.compactMap { document in
                        do {
                            let result = try document.data(as: HotelModel.self)
                            return result
                        
                        } catch { completion(.failure(error)) }
                        return nil
                    }
                }
                completion(.success(currentData))
            }
    }
    
    // MARK: - Fetch all rooms
    func fetchAllRoomByHotel(hotelId: String, completion: @escaping (Result<[RoomModel], Error>) -> Void) {
        db.collection("rooms")
            .whereField("hotelID", isEqualTo: hotelId)
            .getDocuments { querySnapshot, error in
                var data: [RoomModel] = []
                if let querySnapshot = querySnapshot {
                    data = querySnapshot.documents.compactMap { document in
                        do {
                            let result = try document.data(as: RoomModel.self)
                            return result
                        } catch { completion(.failure(error)) }
                        return nil
                    }
                }
                completion(.success(data))
            }
    }
    
    // MARK: - Fetch all booking
    func fetchAllBookingByHotel(hotelId: String, completion: @escaping (Result<[BookingModel], Error>) -> Void) {
        db.collection("booking")
            .whereField("hotelID", isEqualTo: hotelId)
            .getDocuments { querySnapshot, error in
                var data: [BookingModel] = []
                if let querySnapshot = querySnapshot {
                    data = querySnapshot.documents.compactMap { document in
                        do {
                            let result = try document.data(as: BookingModel.self)
                            return result
                        } catch { completion(.failure(error)) }
                        return nil
                    }
                }
                    completion(.success(data))
            }
    }
    
    func fetchAllBookingByRoom(roomId: String, completion: @escaping (Result<[BookingModel], Error>) -> Void) {
        db.collection("booking")
            .whereField("roomID", isEqualTo: roomId)
            .getDocuments { querySnapshot, error in
                var data: [BookingModel] = []
                if let querySnapshot = querySnapshot {
                    data = querySnapshot.documents.compactMap { document in
                        do {
                            let result = try document.data(as: BookingModel.self)
                            return result
                        } catch { completion(.failure(error)) }
                        return nil
                    }
                }
                completion(.success(data))
            }
    }
    
    func fetchAllBooking(completion: @escaping (Result<[BookingModel], Error>) -> Void) {
        db.collection("booking")
            .getDocuments { querySnapshot, error in
                var currentData: [BookingModel] = []
                if let querySnapshot = querySnapshot {
                    currentData = querySnapshot.documents.compactMap { document in
                        do {
                            let result = try document.data(as: BookingModel.self)
                            return result
                        } catch { completion(.failure(error)) }
                        return nil
                    }
                }
                completion(.success(currentData))
            }
    }
    
}
