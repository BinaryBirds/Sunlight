//
//  FloatingPoint+Extensions.swift
//  Sunlight
//
//  Created by Tibor Bödecs on 2019. 02. 07..
//  Copyright © 2018-2019. Tibor Bödecs. All rights reserved.
//

import Foundation

extension FloatingPoint {
    
    var radians: Self {
        return self * .pi / 180
    }
    
    var degrees: Self {
        return self * 180 / .pi
    }
    
    // Reduce angle to within 0..360 degrees
    var reduceAngle: Self {
        return self - 360 * floor(self / 360) as Self
    }
    
    // Reduce angle to within -180..+180 degrees
    var reduceAngle180: Self {
        let value = self / 360 + 1 / 2
        return self - 360 * floor(value)
    }
    
    func normalise(withMaximum maximum: Self) -> Self {
        var value = self
        if value < 0 {
            value += maximum
        }
        if value > maximum {
            value -= maximum
        }
        return value
    }
}
