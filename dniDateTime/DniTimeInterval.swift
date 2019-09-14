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

    public init(_ component: DniDateTimeComponent) {
        _interval = component.convert(to: .prorahn).value
    }
}
