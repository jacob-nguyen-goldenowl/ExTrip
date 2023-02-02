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
    
    func searchByDestination(query: String, completion: @escaping ([DestinationModel]) -> Void) {
        db.collection("destinations").whereField("country", isEqualTo: query).getDocuments { querySnapshot, error in
            var data: [DestinationModel] = []
            if let querySnapshot = querySnapshot {
                data = querySnapshot.documents.compactMap { document in
                    do {
                        let result = try document.data(as: DestinationModel.self)
                        return result
                    }
                    catch { print(error) }
                    return nil
                }
            }
            completion(data)
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
        print(filter)
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
                        }
                        catch { completion(.failure(error)) }
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
        
}
