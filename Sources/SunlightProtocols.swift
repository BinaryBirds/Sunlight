//
//  SunlightProtocols.swift
//  Sunlight
//
//  Created by Tibor Bödecs on 2019. 02. 10..
//  Copyright © 2018-2019. Tibor Bödecs. All rights reserved.
//

import Foundation

public enum Transition {
    case dawn
    case dusk
}

public enum Twilight {

    case official
    case civil
    case nautical
    case astronomical
    case custom(Double)

    public var degrees: Double {
        switch self {
        case .official:
            return -35.0 / 60.0
        case .civil:
             return -6
        case .nautical:
            return -12
        case .astronomical:
            return -18
        case .custom(let value):
            return value
        }
    }
}

public protocol SunlightCalculatorAlgorithm {
    func calculate(_ transition: Transition,
                   on date: Date,
                   latitude: Double,
                   longitude: Double,
                   twilight: Twilight) -> Date?
}

