//
//  ResquestDatabase.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 04/01/2023.
//

import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

class DatabaseRequest {
    
    static let shared = DatabaseRequest()
    private init() {}
    
    private let db = Firestore.firestore()
    
    // MARK: Search
    func searchEqualToFiled<T: Codable>(collection: String, field: String, query: String, completion: @escaping ([T]) -> Void) {
        db.collection(collection).whereField(field, isEqualTo: query.lowercased()).getDocuments { querySnapshot, error in
            var data: [T] = []
            if let querySnapshot = querySnapshot {
                data = querySnapshot.documents.compactMap { document in
                    do {
                        let result = try document.data(as: T.self)
                        return result
                    } catch { print(error) }
                    return nil
                }
            }
            completion(data)
        }
    }

    func searchHotelRelatedAddress(_ query: String, completion: @escaping ([HotelModel]) -> Void) {
        DatabaseResponse.shared.fetchData("hotels") { (data: [HotelModel]) in
            let filter = data.filter { data in
                data.address.contains(query)
            }
            completion(filter)
        }
    }
    
    func searchHotelRelatedKeyWord(_ query: String, completion: @escaping ([HotelModel]) -> Void) {
        DatabaseResponse.shared.fetchData("hotels") { (data: [HotelModel]) in
            let filter = data.filter { data in
                data.name.contains(query)
            }
            completion(filter)
        }
    }
    
    // MARK: - Filter
    func checkSelectedService(_ service: [String]) -> [String] {
        var newSerview: [String] = []
        if service.isEmpty {
            newSerview = ["Car Parking"]
        } else {
            newSerview = service
        }
        return newSerview
    }
    
    func filterHotel(_ filter: FilterModel, completion: @escaping (Result<[HotelModel], Error>) -> Void) {
        db.collection("hotels")
            .whereField("price", isGreaterThan: filter.price.minimun)
            .whereField("price", isLessThan: filter.price.maximun)
            .whereField("service", arrayContainsAny: checkSelectedService(filter.service))
            .whereField("star", isEqualTo: filter.star ?? "5")
            .getDocuments { querySnapshot, error in
                var currentData: [HotelModel]?
                var newData: [HotelModel] = []
                if let querySnapshot = querySnapshot {
                    currentData = querySnapshot.documents.compactMap { document in
                        do {
                            let result = try document.data(as: HotelModel.self)
                            return result
                        } catch { completion(.failure(error)) }
                        return nil
                    }
                }
                
                guard let currentData = currentData else {
                    completion(.failure("Not found" as! Error))
                    return
                }
                
                currentData.forEach { hotel in
                    if hotel.rating <= filter.rating {
                        newData.append(hotel)
                    }
                }
                completion(.success(newData))

            }
    }
    
    func addWishList(with wishlist: WishListModel, completion: @escaping (Bool) -> Void) {
        do {
            try db.collection("wishlist").addDocument(from: wishlist)
            completion(true)
        } catch {
            completion(false)
        }
    }
    
    func removeWishList(_ hotelID: String, completion: @escaping (Bool) -> Void) {
        db.collection("wishlist").whereField("hotelID", isEqualTo: hotelID).getDocuments { (querySnapshot, err) in 
            if let err = err {
                completion(false)
                print("Error getting documents: \(err)")
            } else { 
                for document in querySnapshot!.documents { 
                    document.reference.delete() 
                } 
                completion(true) 
            }
        }
    }
    
    func updateField(_ bookingID: String, status: String, completion: @escaping (Bool) -> Void) {
        let docRef = db.collection("booking").document(bookingID)
        docRef.updateData(["status": status])
        completion(true)
    }
    
    // MARK: Fetch one Hotel 
    func fetchHotel(_ hotelID: String, completion: @escaping (HotelModel?) -> Void ) {
        db.collection("hotels").document(hotelID).getDocument { (document, _) in
            if let document = document {
                do {
                    let result = try document.data(as: HotelModel.self)
                    completion(result)
                } catch {
                    completion(nil)
                }
            }
        }
    }
    
    func fetchBooking(_ bookingID: String, completion: @escaping (BookingModel?) -> Void ) {
        db.collection("booking").document(bookingID).getDocument { (document, _) in
            if let document = document {
                do {
                    let result = try document.data(as: BookingModel.self)
                    completion(result)
                } catch {
                    completion(nil)
                }
            }
        }
    }
    
}
