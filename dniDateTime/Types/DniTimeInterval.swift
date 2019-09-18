//
//  DniTimeInterval.swift
//  dniDateTime
//
//  Created by Jeff Hitchcock on 2019-09-13.
//  Copyright © 2019 Jeff Hitchcock. All rights reserved.
//

import Foundation

fileprivate typealias U = DniDateTimeUnit

public struct DniTimeInterval {
    public typealias Prorahn = Double

    private let _interval: Prorahn

    public var prorahntee: Double {
        return gorahnteeRemainder
    }
    public var gorahntee: Int {
        return Int(tahvoteeRemainder / U.gorahn.value)
    }
    public var tahvotee: Int {
        return Int(pahrtahvoteeRemainder / U.tahvo.value)
    }
    public var pahrtahvotee: Int {
        return Int(_interval / U.pahrtahvo.value)
    }

    public var toSeconds: TimeInterval {
        return _interval.toSeconds
    }

    public func component(forUnit unit: DniDateTimeUnit) -> DniDateTimeComponent? {
        switch unit {
        case .prorahn: return DniDateTimeComponent(prorahntee, type: .prorahn)
        case .gorahn: return DniDateTimeComponent(gorahntee, type: .gorahn)
        case .tahvo: return DniDateTimeComponent(tahvotee, type: .tahvo)
        case .pahrtahvo: return DniDateTimeComponent(pahrtahvotee, type: .pahrtahvo)
        default: return nil
        }
    }

    private var gorahnteeRemainder: Double {
        return tahvoteeRemainder - (Double(gorahntee) * U.gorahn.value)
    }
    private var tahvoteeRemainder: Double {
        return pahrtahvoteeRemainder - (Double(tahvotee) * U.tahvo.value)
    }
    private var pahrtahvoteeRemainder: Double {
        return _interval - (Double(pahrtahvotee) * U.pahrtahvo.value)
    }

    public init(_ seconds: TimeInterval) {
        _interval = seconds.toProrahntee
    }

    public init(_ components: DniDateTimeComponent...) {
        var interval: Prorahn = 0.0
        for component in components {
            interval += component.convert(to: .prorahn).value
        }
        _interval = interval
    }
}

extension DniTimeInterval {
    public func replacedUnit(with value: DniDateTimeComponent) -> DniTimeInterval {
        let subtractedValue = _interval - (component(forUnit: value.type)?.value ?? 0)
        return DniTimeInterval(value, DniDateTimeComponent(subtractedValue, type: .prorahn))
    }
}
