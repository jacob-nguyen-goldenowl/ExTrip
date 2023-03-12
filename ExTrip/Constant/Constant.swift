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
    }
    
    enum Image {
        static let defaultBackground = "default"
    }
    
}

struct FeatureFlags {
    static var isUpdateWishlist: Bool = false
    static var isLiked: Bool = false
}
