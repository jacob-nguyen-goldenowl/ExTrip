//
//  Constaint.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 01/03/2023.
//

import Foundation

struct Constant {
    
    enum Animation {
        static let loading = "loading"
        static let emptyBox = "emptyBox"
        static let active = "active"
        static let pass = "pass"
        static let cancel = "cancel"
    }
    
    enum Image {
        static let defaultImage = "account"
    }
    
    enum URL {
        static let github = "https://github.com/jacob-nguyen-goldenowl/ExTrip"
    }
}

struct FeatureFlags {
    static var isUpdateWishlist: Bool = false
    static var isLiked: Bool = false
    static var isLogout: Bool = false
}
