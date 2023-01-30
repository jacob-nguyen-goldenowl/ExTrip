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
    
    func searchDestination(query: String, completion: @escaping ([DestinationModel]) -> Void) {
        db.collection("destinations").whereField("country", isGreaterThanOrEqualTo: query).getDocuments { querySnapshot, error in
            var data: [DestinationModel] = []
            if let querySnapshot = querySnapshot {
                data = querySnapshot.documents.compactMap { document in
                    do {
                        return try document.data(as: DestinationModel.self)
                    }
                    catch { print(error) }
                    return nil
                }
            }
            let filter = data.filter { data in
                data.country.contains(query)
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
    
    func filterByCategory(price: String, rating: String) {
        db.collection("hotels")
            .whereField("price", isEqualTo: price)
            .whereField("city", isEqualTo: rating).getDocuments { snapshot, error in
                snapshot?.documents.forEach({ document in
                    let document = document.data()
                    print(document)
                })
            }
    }
        
}
