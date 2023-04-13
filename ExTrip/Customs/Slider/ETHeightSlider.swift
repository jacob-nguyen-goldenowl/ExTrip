//
//  ETHeightSlider.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 02/02/2023.
//

import UIKit

class ETHeightSlider: UISlider {
    
    var trackHeight: CGFloat = 2.5
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = super.trackRect(forBounds: bounds)
        newBounds.size.height = trackHeight
        return newBounds
    }
}
