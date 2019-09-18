//
//  Double+Extensions.swift
//  dniDateTime
//
//  Created by Jeff Hitchcock on 2019-09-13.
//  Copyright © 2019 Jeff Hitchcock. All rights reserved.
//

internal extension Double {
    // Conversion ratio between Seconds and Prorahn
    // Seconds in One Hahr (31556925.216) ÷ Prorahn in One Hahr (22,656,250)
    static let secondsInOneProrahn = 1.392_857_388_844_140

    // Difference between new years on Hahr 0 and 2001-01-01 00:00:00 UTC in Prorahn
    static let epochOffset = 218_784_575_046.51

    var toSecondsFromEpoch: Double { return (self - Double.epochOffset) * Double.secondsInOneProrahn }
    var toProrahnteeFromEpoch: Double { return (self / Double.secondsInOneProrahn) + Double.epochOffset }

    var toSeconds: Double { return self * Double.secondsInOneProrahn }
    var toProrahntee: Double { return self / Double.secondsInOneProrahn }
}
