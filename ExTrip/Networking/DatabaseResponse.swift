//
//  ResponseDatabase.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 10/01/2023.
//

import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore
import FirebaseFirestoreSwift

class DatabaseResponse {
    
    static let shared = DatabaseResponse()
    private init() {}
    
    private let db = Firestore.firestore()

    // MARK: Fetch destination data
    public func fetchData<T: Codable>(_ collection: String,completion: @escaping([T]) -> Void) {
        db.collection(collection).addSnapshotListener { (querySnapshot, error) in
            var data = [T]()
            if let querySnapshot = querySnapshot {
                data = querySnapshot.documents.compactMap { document in
                    do {
                        return try document.data(as: T.self)
                    }
                    catch { print(error) }
                    return nil
                }
            }
            completion(data)
        }
    }
    
    // MARK: Fetch limit data
    public func fetchLimitDataById<T: Codable>(collection: String, filed: String, documentId: String?, completion: @escaping([T]) -> Void) {
        guard let id = documentId else { return }
        db.collection(collection)
            .whereField(filed, isEqualTo: id).limit(to: 5)
            .getDocuments { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    var data = [T]()
                    data = querySnapshot.documents.compactMap { document in
                        do {
                            return try document.data(as: T.self)
                        }
                        catch { print("Error of fetch limit data \(error)") }
                        return nil
                    }
                    completion(data)
                }
            }
    } 
    
    // MARK: Fetch all data
    public func fetchDataById<T: Codable>(collection: String, filed: String, documentId: String?, completion: @escaping([T]) -> Void) {
        guard let id = documentId else { return }
        db.collection(collection)
            .whereField(filed, isEqualTo: id)
            .getDocuments { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    var data = [T]()
                    data = querySnapshot.documents.compactMap { document in
                        do {
                            return try document.data(as: T.self)
                        }
                        catch { print(error) }
                        return nil
                    }
                    completion(data)
                }
            }
    } 
    
    
}
