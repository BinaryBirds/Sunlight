//
//  SchlyterAlgorithm.swift
//  Sunlight
//
//  Created by Tibor Bödecs on 2018. 01. 16..
//  Copyright © 2018-2019. Tibor Bödecs. All rights reserved.
//

import Foundation

// http://stjarnhimlen.se/comp/sunriset.c
public struct SchlyterAlgorithm: SunlightCalculatorAlgorithm {
    
    public init() {
        
    }
    
    private func daysSince2000Jan0(_ y: Int, _ m: Int, _ d: Int) -> Int {
        return (367 * y - ((7 * (y + ((m + 9) / 12))) / 4) + (275 * m / 9) + d - 730_530)
    }

    private func GMST0(_ d: Double) -> Double {
        return ((180.0 + 356.047_0 + 282.940_4) + (0.985_600_258_5 + 4.70935e-5) * d).reduceAngle
    }

    private func sunposAtDay(_ d: Double, lon: inout Double, r: inout Double) {
        let M = (356.047_0 + 0.985_600_258_5 * d).reduceAngle
        let w = 282.940_4 + 4.70935e-5 * d
        let e = 0.016_709 - 1.151e-9 * d

        let E = M + e.degrees * sin(M.radians) * (1.0 + e * cos(M.radians))
        let x = cos(E.radians) - e
        let y = sqrt(1.0 - e * e) * sin(E.radians)
        r = sqrt(x * x + y * y)
        let v = atan2(y, x).degrees
        lon = v + w
        if lon >= 360.0 {
            lon -= 360.0
        }
    }

    private func sun_RA_decAtDay(_ d: Double, RA: inout Double, dec: inout Double, r: inout Double) {
        var lon: Double = 0

        self.sunposAtDay(d, lon: &lon, r: &r)

        let xs = r * cos(lon.radians)
        let ys = r * sin(lon.radians)
        let obl_ecl = 23.439_3 - 3.563E-7 * d
        let xe = xs
        let ye = ys * cos(obl_ecl.radians)
        let ze = ys * sin(obl_ecl.radians)
        RA = atan2(ye, xe).degrees
        dec = atan2(ze, sqrt(xe * xe + ye * ye)).degrees
    }

    public func calculate(_ transition: Transition,
                          on date: Date,
                          latitude: Double,
                          longitude: Double,
                          twilight: Twilight) -> Date? {

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(abbreviation: "UTC")!

        let dcs = calendar.dateComponents([.year, .month, .day], from: date)
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let newDate = calendar.date(from: dcs)!
        
        var sRA: Double = 0
        var sdec: Double = 0
        var sr: Double = 0
        
        let d = Double(self.daysSince2000Jan0(year, month, day)) + 0.5 - longitude / 360.0
        let sidtime = (self.GMST0(d) + 180.0 + longitude).reduceAngle

        self.sun_RA_decAtDay(d, RA: &sRA, dec: &sdec, r: &sr)

        let tsouth = 12.0 - (sidtime - sRA).reduceAngle180 / 15.0
        let sradius = 0.266_6 / sr

        var alt = twilight.degrees
        if case .official = twilight { //upper_limb = 1
            alt -= sradius
        }

        let cost = (sin(alt.radians) - sin(latitude.radians) * sin(sdec.radians)) / (cos(latitude.radians) * cos(sdec.radians))
        guard cost < 1, cost > -1 else {
            return nil
        }
        let t = acos(cost).degrees / 15.0

        var val = tsouth + t
        if transition == .dawn {
            val = tsouth - t
        }
        return newDate.addingTimeInterval(val * 3_600)
    }
}
