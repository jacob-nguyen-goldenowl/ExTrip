//
//  ResquestDatabase.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 04/01/2023.
//

import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

class RequestDatabase {
    
    static let shared = RequestDatabase()
    private init() {}
    
    private let db = Firestore.firestore()
    
    func filterByDestination(query: String, completion: @escaping ([String]) -> Void) {
        db.collection("hotels").whereField("city", isEqualTo: query).getDocuments { snapshot, error in
            snapshot?.documents.forEach({ document in
                let document = document.data()
                print(document)
            })
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
