//
//  Sunlight.swift
//  Sunlight
//
//  Created by Tibor Bödecs on 2019. 02. 10..
//  Copyright © 2018-2019. Tibor Bödecs. All rights reserved.
//

import Foundation

public struct SunlightCalculator {

    public let algorithm: SunlightCalculatorAlgorithm
    public let latitude: Double
    public let longitude: Double
    public let date: Date

    public init(using algorithm: SunlightCalculatorAlgorithm = SchlyterAlgorithm(),
         date: Date = Date(),
         latitude: Double,
         longitude: Double) {
        self.algorithm = algorithm
        self.latitude = latitude
        self.longitude = longitude
        self.date = date
    }

    public func calculate(_ transition: Transition, twilight: Twilight) -> Date? {
        return self.algorithm.calculate(transition,
                                        on: self.date,
                                        latitude: self.latitude,
                                        longitude: self.longitude,
                                        twilight: twilight)
    }
}
