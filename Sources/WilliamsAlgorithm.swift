//
//  WilliamsAlgorithm.swift
//  Sunlight
//
//  Created by Tibor Bödecs on 2019. 02. 11..
//  Copyright © 2018-2019. Tibor Bödecs. All rights reserved.
//

import Foundation

// http://edwilliams.org/sunrise_sunset_algorithm.htm
public struct WilliamsAlgorithm: SunlightCalculatorAlgorithm {
    
    public init() {
        
    }

    public func calculate(_ transition: Transition,
                          on date: Date,
                          latitude: Double,
                          longitude: Double,
                          twilight: Twilight) -> Date? {

        let zenith = -1 * twilight.degrees + 90
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let dayInt = calendar.ordinality(of: .day, in: .year, for: date)!
        let day = Double(dayInt)
        
        // longitude to hour value and calculate an approx. time
        let lngHour = longitude / 15
        let hourTime: Double = transition == .dawn ? 6 : 18
        let t = day + ((hourTime - lngHour) / 24)
        
        // Calculate the suns mean anomaly
        let M = (0.9856 * t) - 3.289
        
        // Calculate the sun's true longitude
        let subexpression1 = 1.916 * sin(M.radians)
        let subexpression2 = 0.020 * sin(2 * M.radians)
        var L = M + subexpression1 + subexpression2 + 282.634
        L = L.normalise(withMaximum: 360)
        
        // sun's right ascension
        var RA = atan(0.91764 * tan(L.radians)).degrees
        RA = RA.normalise(withMaximum: 360)
        
        // RA value needs to be in the same quadrant as L
        let Lquadrant = floor(L / 90) * 90
        let RAquadrant = floor(RA / 90) * 90
        RA = RA + (Lquadrant - RAquadrant)
        // RA into hours
        RA = RA / 15
        
        // declination
        let sinDec = 0.39782 * sin(L.radians)
        let cosDec = cos(asin(sinDec))
        
        // local hour angle
        let cosH = (cos(zenith.radians) - (sinDec * sin(latitude.radians))) / (cosDec * cos(latitude.radians))
        
        // no transition
        guard cosH < 1, cosH > -1 else {
            return nil
        }

        let tempH = transition == .dawn ? 360 - acos(cosH).degrees : acos(cosH).degrees
        let H = tempH / 15.0
        
        // local mean time of rising
        let T = H + RA - (0.06571 * t) - 6.622

        var UT = T - lngHour
        UT = UT.normalise(withMaximum: 24)
        
        let hour = floor(UT)
        let minute = floor((UT - hour) * 60.0)
        let second = (((UT - hour) * 60) - minute) * 60.0
        let shouldBeYesterday = lngHour > 0 && UT > 12 && transition == .dawn
        let shouldBeTomorrow = lngHour < 0 && UT < 12 && transition == .dusk
        let setDate: Date
        if shouldBeYesterday {
            setDate = Date(timeInterval: -86_400, since: date)
        }
        else if shouldBeTomorrow {
            setDate = Date(timeInterval: 86_400, since: date)
        }
        else {
            setDate = date
        }

        var components = calendar.dateComponents([.day, .month, .year], from: setDate)
        components.hour = Int(hour)
        components.minute = Int(minute)
        components.second = Int(second)
        return calendar.date(from: components)
    }
}
