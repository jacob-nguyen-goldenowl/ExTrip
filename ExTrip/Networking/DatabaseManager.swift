//
//  DatabaseManager.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 12/12/2022.
//

import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

class DatabaseManager {
    
    static let shared = DatabaseManager()
    private init() {}
    
    private let database = Database.database().reference()
    private let fireStore = Firestore.firestore()
    
    // Check user is existing
    public func canCreateNewUser(with email: String, username: String, completion: @escaping (Bool) -> Void) {
        database.child(email.safeDatabaseKey()).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.hasChild(email.safeDatabaseKey()) {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    // Insert new user
    public func insertNewUser(with info: UserInfoModel, uid: String , completion: @escaping(Bool) -> Void) {
        let users = fireStore.collection("users").document(uid)
        
        users.setData(info.dictionary) { error in 
            if error == nil {
                // success
                completion(true)
            } else {
                // failed
                completion(false)
            }
        }
    }
    
    // MARK: Fetch destination data
    public func fetchDataDestination(completion: @escaping([Destination]) -> Void) {
        fireStore.collection("destinations").getDocuments { (snapshot, error) in
            var destinations = [Destination]()
            snapshot?.documents.forEach({ (document) in
                let dictionary = document.data() 
                if let destination = Destination(dictionary: dictionary) {
                    destinations.append(destination) 
                }
            })
            completion(destinations)
        }
    }
    
    // MARK: Fetch hotels data
    public func fetchLimitOfHotels(_ countryID: String?, completion: @escaping([HotelModel]) -> Void) {
        guard let id = countryID else { return }
        fireStore.collection("hotels")
            .whereField("destination_id", isEqualTo: id).limit(to: 2)
            .getDocuments { (snapshot, error) in
                var hotels = [HotelModel]()
                snapshot?.documents.forEach({ (document) in
                    let dictionary = document.data() 
                    if let hotel = HotelModel(dictionary: dictionary) {
                        hotels.append(hotel) 
                    }
                })
                completion(hotels)
            }
    }
    
    // MARK: Fetch hotels data
    public func fetchAllHotels(_ countryID: String?, completion: @escaping([HotelModel]) -> Void) {
        guard let id = countryID else { return }
        fireStore.collection("hotels")
            .whereField("destination_id", isEqualTo: id)
            .getDocuments { (snapshot, error) in
                var hotels = [HotelModel]()
                snapshot?.documents.forEach({ (document) in
                    let dictionary = document.data() 
                    if let hotel = HotelModel(dictionary: dictionary) {
                        hotels.append(hotel) 
                    }
                })
                completion(hotels)
            }
    }
}

fileprivate extension String {
    func safeDatabaseKey() -> String {
        return self.replacingOccurrences(of: "@", with: "-").replacingOccurrences(of: ".", with: "-")
    }
}

