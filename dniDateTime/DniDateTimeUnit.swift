//
//  DniDateTimeUnit.swift
//  dniDateTime
//
//  Created by Jeff Hitchcock on 2019-03-11.
//  Copyright © 2019 Jeff Hitchcock. All rights reserved.
//

public enum DniDateTimeUnit: String, Codable {
    case prorahn, gorahn, tahvo, pahrtahvo, gahrtahvo, yahr, vailee, hahr
}

public extension DniDateTimeUnit {
    var name: String {
        switch self {
        case .prorahn:
            return "Prorahn"
        case .gorahn:
            return "Gorahn"
        case .tahvo:
            return "Tahvo"
        case .pahrtahvo:
            return "Pahrtahvo"
        case .gahrtahvo:
            return "Gahrtahvo"
        case .yahr:
            return "Yahr"
        case .vailee:
            return "Vailee"
        case .hahr:
            return "Hahr"
        }
    }

    var pluralName: String {
        return "\(name)tee"
    }

    var value: Double {
        switch self {
        case .prorahn:
            // about 1.5 seconds
            return 1
        case .gorahn:
            // about 35 seconds, 1 prorahn x 25
            return 25
        case .tahvo:
            // about 14.5 minutes, 1 gorahn x 25
            return 625
        case .pahrtahvo:
            // about 1 hour 13 minutes, 1 tahvo x 5
            return 3_125
        case .gahrtahvo:
            // about 6 hours 3 minutes, 1 pahtavo x 5
            return 15_625
        case .yahr:
            // about 30 hours 14 minutes, 1 pahtavo x 25
            return 78_125
        case .vailee:
            // about one month, 1 yahr x 29
            return 2_265_625
        case .hahr:
            // about one year, 1 vailee x 10
            return 22_656_250
        }
    }

    var min: Int {
        switch self {
        case .prorahn, .gorahn, .tahvo, .pahrtahvo, .gahrtahvo, .hahr:
            return 0
        case .yahr, .vailee:
            return 1
        }
    }

    var max: Int {
        switch self {
        case .prorahn, .gorahn, .pahrtahvo:
            return 25
        case .tahvo, .gahrtahvo:
            return 5
        case .yahr:
            return 29
        case .vailee:
            return 10
        case .hahr:
            return Int.max
        }
    }
}

public extension DniDateTimeUnit {
    enum Vailee: Int {
        case leefo = 1, leebro, leesahn, leetar, leevot, leevofo, leevobro, leevosahn, leevotar, leenovoo

        public var name: String {
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
}
