//
//  dniDateTime.swift
//  dniDateTime
//
//  Created by Jeff Hitchcock on 2016-09-22.
//  Copyright © 2016 Jeff Hitchcock. All rights reserved.
//

import Foundation

fileprivate typealias U = DniDateTimeUnit

public struct DniDateTime {
    private let dateTime: Date

    private var timeInProrahntee: Double {
        return dateTime.timeIntervalSinceReferenceDate.toProrahntee
    }

    public var prorahntee: Int {
        return Int(timeInProrahntee.truncatingRemainder(dividingBy: U.gorahn.value)) + U.prorahn.min
    }
    public var gorahntee: Int {
        return Int(timeInProrahntee.truncatingRemainder(dividingBy: U.tahvo.value) / U.gorahn.value) + U.gorahn.min
    }
    public var tahvotee: Int {
        return Int(timeInProrahntee.truncatingRemainder(dividingBy: U.pahrtahvo.value) / U.tahvo.value) + U.tahvo.min
    }
    public var pahrtahvotee: Int {
        return Int(timeInProrahntee.truncatingRemainder(dividingBy: U.yahr.value) / U.pahrtahvo.value) + U.pahrtahvo.min
    }
    public var gahrtahvotee: Int {
        return self.pahrtahvotee / 5
    }
    public var yahrtee: Int {
        return Int(timeInProrahntee.truncatingRemainder(dividingBy: U.vailee.value) / U.yahr.value) + U.yahr.min
    }
    public var vaileetee: Int {
        return Int(timeInProrahntee.truncatingRemainder(dividingBy: U.hahr.value) / U.vailee.value) + U.vailee.min
    }
    public var hahrtee: Int {
        return Int(timeInProrahntee / U.hahr.value) + U.hahr.min
    }

    public var vaileeteeName: String {
        return DniDateTimeUnit.Vailee(rawValue: self.vaileetee)?.name ?? ""
    }

    private var fractional_prorahntee: Double {
        return timeInProrahntee - Double(Int(timeInProrahntee))
    }

    public init() {
        dateTime = Date()
    }

    public init(withDate date: Date) {
        dateTime = date
    }

    public init(_ components: DniDateTimeComponent...) {
        let addedComponents: DniDateTimeComponent = components.reduce(DniDateTimeComponent(0, type: .prorahn)) { $0 + $1 }
        let secondsTime = addedComponents.value.toSeconds
        let newDateTime = Date(timeIntervalSinceReferenceDate: secondsTime)
        self.init(withDate: newDateTime)
    }

    public init(withHahr hahrtee: Int,
         vaileetee: Int,
         yahrtee: Int,
         pahrtahvotee: Int,
         tahvotee: Int,
         gorahntee: Int,
         prorahntee: Int) {
        self.init(
            DniDateTimeComponent(hahrtee, type: .hahr),
            DniDateTimeComponent(vaileetee - DniDateTimeUnit.vailee.min, type: .vailee),
            DniDateTimeComponent(yahrtee - DniDateTimeUnit.yahr.min, type: .yahr),
            DniDateTimeComponent(pahrtahvotee, type: .pahrtahvo),
            DniDateTimeComponent(tahvotee, type: .tahvo),
            DniDateTimeComponent(gorahntee, type: .gorahn),
            DniDateTimeComponent(prorahntee, type: .prorahn)
        )
    }

    public init(newYearsForHahr hahrtee: Int) {
        self.init(withHahr: hahrtee,
                  vaileetee: 1,
                  yahrtee: 1,
                  pahrtahvotee: 0,
                  tahvotee: 0,
                  gorahntee: 0,
                  prorahntee: 0)
    }

    public init?(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0, second: Int = 0) {
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "PST")!
        let components = DateComponents(calendar: calendar, timeZone: calendar.timeZone, year: year, month: month, day: day, hour: hour, minute: minute, second: second)
        if components.date == nil {
            return nil
        }
        self.init(withDate: components.date!)
    }
}

extension DniDateTime: Equatable, Comparable {
    public static func == (lhs: DniDateTime, rhs: DniDateTime) -> Bool {
        return
            lhs.hahrtee == rhs.hahrtee &&
            lhs.vaileetee == rhs.vaileetee &&
            lhs.yahrtee == rhs.yahrtee &&
            lhs.gahrtahvotee == rhs.gahrtahvotee &&
            lhs.pahrtahvotee == rhs.pahrtahvotee &&
            lhs.tahvotee == rhs.tahvotee &&
            lhs.gorahntee == rhs.gorahntee &&
            lhs.prorahntee == rhs.prorahntee
    }
    
    public static func < (lhs: DniDateTime, rhs: DniDateTime) -> Bool {
        return Int(lhs.timeInProrahntee) < Int(rhs.timeInProrahntee)
    }
}

extension DniDateTime: CustomStringConvertible {
    public var description: String {
        let formatter = DniDateTimeFormatter()
        formatter.dateFormat = .full
        formatter.timeFormat = .full
        return formatter.string(from: self)
    }
}

fileprivate extension Double {
    // Conversion ratio between Seconds and Prorahn
    // Seconds in One Hahr (31556925.216) ÷ Prorahn in One Hahr (22,656,250)
    static let secondsInOneProrahn = 1.392_857_388_844_140

    // Difference between new years on Hahr 0 and 2001-01-01 00:00:00 UTC in Prorahn
    static let epochOffset = 218_784_575_046.51

    var toSeconds: Double { return (self - Double.epochOffset) * Double.secondsInOneProrahn }
    var toProrahntee: Double { return (self / Double.secondsInOneProrahn) + Double.epochOffset }
}
