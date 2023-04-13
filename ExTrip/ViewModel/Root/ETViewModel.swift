//
//  ETViewModel.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 09/03/2023.
//

import Foundation

enum APIError: String, Error {
    case noNetwork = "No Network"
    case serverOverload = "Server is overloaded"
    case nilData = "Data set is empty"
}

class ETViewModel<T: Codable> {
    
    // MARK: Observed Properties
    var listOfData: [T] = [T]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    // MARK: Binding Closures
    var reloadTableViewClosure: (() -> Void)?
    var showAlertClosure: (() -> Void)?
    var updateLoadingStatus: (() -> Void)?
    var showEmptyViewClosure: (() -> Void)?
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var emptyData: String? {
        didSet {
            self.showEmptyViewClosure?()
        }
    }

    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> T {
        return listOfData[indexPath.row]
    }
    
    var numberOfRows: Int {
        return listOfData.count
    }

}
