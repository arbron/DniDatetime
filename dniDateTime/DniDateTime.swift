//
//  dniDateTime.swift
//  dniDateTime
//
//  Created by Jeff Hitchcock on 2016-09-22.
//  Copyright © 2016 Jeff Hitchcock. All rights reserved.
//

import Foundation

public class DniDateTime {
    struct Units {
        // Conversion ratio between Seconds and Prorahn
        // Seconds in One Hahr (31556925.216) ÷ Prorahn in One Hahr (22,656,250)
        static let seconds_in_one_prorahn = 1.392_857_388_844_140
        
        // Difference between new years on Hahr 0 and 2001-01-01 00:00:00 UTC in Prorahn
        static let epoch_offset = 218_784_575_046.51
        
        // about 1.5 seconds
        static let prorahn = (value: 1.0, name: "Prorahn", min: 0, max: 25)
        // about 35 seconds, 1 prorahn x 25
        static let gorahn = (value: 25.0, name: "Gorahn", min: 0, max: 25)
        // about 14.5 minutes, 1 gorahn x 25
        static let tahvo = (value: 625.0, name: "Tahvo", min: 0, max: 5)
        // about 1 hour 13 minutes, 1 tahvo x 5
        static let pahrtahvo = (value: 3_125.0, name: "Pahrtahvo", min: 0, max: 25)
        // about 6 hours 3 minutes, 1 pahtavo x 5
        static let gahrtahvo = (value: 15_625.0, name: "Gahrtahvo", min: 0, max: 5)
        // about 30 hours 14 minutes, 1 pahtavo x 25
        static let yahr = (value: 78_125.0, name: "Yahr", min: 1, max: 5)
        // about one month, 1 yahr x 29
        static let vailee = (value: 2_265_625.0, name: "Vailee", min: 1, max: 29)
        // about one year, 1 vailee x 10
        static let hahr = (value: 22_656_250.0, name: "Hahr", min: 0, max: Int.max)
    }
    
    enum Vailee: Int {
        case leefo = 1, leebro, leesahn, leetar, leevot, leevofo, leevobro, leevosahn, leevotar, leenovoo
        
        func description() -> String {
            switch self {
            case .leefo:
                return "Leefo"
            case .leebro:
                return "Leebro"
            case .leesahn:
                return "Leesahn"
            case .leetar:
                return "Leetar"
            case .leevot:
                return "Leevot"
            case .leevofo:
                return "Leevofo"
            case .leevobro:
                return "Leevobro"
            case .leevosahn:
                return "Leevosahn"
            case .leevotar:
                return "Leevotar"
            case .leenovoo:
                return "Leenovoo"
            }
        }
    }
    
    var dateTime: Date
    
    var timeInProrahntee: Double {
        return dateTime.timeIntervalSinceReferenceDate.toProrahntee
    }
    
    var prorahntee: Int {
        return Int(timeInProrahntee.truncatingRemainder(dividingBy: Units.gorahn.value)) + Units.prorahn.min
    }
    var gorahntee: Int {
        return Int(timeInProrahntee.truncatingRemainder(dividingBy: Units.tahvo.value) / Units.gorahn.value) + Units.gorahn.min
    }
    var tahvotee: Int {
        return Int(timeInProrahntee.truncatingRemainder(dividingBy: Units.pahrtahvo.value) / Units.tahvo.value) + Units.tahvo.min
    }
    var pahrtahvotee: Int {
        return Int(timeInProrahntee.truncatingRemainder(dividingBy: Units.yahr.value) / Units.pahrtahvo.value) + Units.pahrtahvo.min
    }
    var gahrtahvotee: Int {
        return self.pahrtahvotee / 5
    }
    var yahrtee: Int {
        return Int(timeInProrahntee.truncatingRemainder(dividingBy: Units.vailee.value) / Units.yahr.value) + Units.yahr.min
    }
    var vaileetee: Int {
        return Int(timeInProrahntee.truncatingRemainder(dividingBy: Units.hahr.value) / Units.vailee.value) + Units.vailee.min
    }
    var hahrtee: Int {
        return Int(timeInProrahntee / Units.hahr.value) + Units.hahr.min
    }
    
    var fractional_prorahntee: Double {
        return timeInProrahntee - Double(Int(timeInProrahntee))
    }
    
    init() {
        dateTime = Date()
    }
    
    init(withDate date: Date) {
        dateTime = date
    }
    
    convenience init(withHahr hahrtee: Int,
         vaileetee: Int,
         yahrtee: Int,
         pahrtahvotee: Int,
         tahvotee: Int,
         gorahntee: Int,
         prorahntee: Int) {
        var prorahnteeTime = Double(prorahntee - Units.prorahn.min)
        prorahnteeTime += Double(gorahntee - Units.gorahn.min) * Units.gorahn.value
        prorahnteeTime += Double(tahvotee - Units.tahvo.min) * Units.tahvo.value
        prorahnteeTime += Double(pahrtahvotee - Units.pahrtahvo.min) * Units.pahrtahvo.value
        prorahnteeTime += Double(yahrtee - Units.yahr.min) * Units.yahr.value
        prorahnteeTime += Double(vaileetee - Units.vailee.min) * Units.vailee.value
        prorahnteeTime += Double(hahrtee - Units.hahr.min) * Units.hahr.value
        let secondsTime = prorahnteeTime.toSeconds
        let newDateTime = Date(timeIntervalSinceReferenceDate: secondsTime)
        self.init(withDate: newDateTime)
    }
    
    convenience init(newYearsForHahr hahrtee: Int) {
        self.init(withHahr: hahrtee,
                  vaileetee: 1,
                  yahrtee: 1,
                  pahrtahvotee: 0,
                  tahvotee: 0,
                  gorahntee: 0,
                  prorahntee: 0)
    }
    
    convenience init?(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0, second: Int = 0) {
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

extension Double {
    var toSeconds: Double { return (self - DniDateTime.Units.epoch_offset) * DniDateTime.Units.seconds_in_one_prorahn }
    var toProrahntee: Double { return (self / DniDateTime.Units.seconds_in_one_prorahn) + DniDateTime.Units.epoch_offset }
}
