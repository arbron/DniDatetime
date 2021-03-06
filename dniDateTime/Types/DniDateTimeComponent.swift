//
//  DniDateTimeComponent.swift
//  dniDateTime
//
//  Created by Jeff Hitchcock on 2019-03-11.
//  Copyright © 2019 Jeff Hitchcock. All rights reserved.
//

public struct DniDateTimeComponent {
    public let value: Double
    public let type: DniDateTimeUnit

    public init(_ value: Double, type: DniDateTimeUnit) {
        self.value = value
        self.type = type
    }

    public init(_ value: Int, type: DniDateTimeUnit) {
        self.init(Double(value), type: type)
    }

    public init(convertSeconds seconds: TimeInterval, to type: DniDateTimeUnit) {
        self = DniDateTimeComponent(seconds.toProrahntee, type: .prorahn).convert(to: type)
    }
}

// Conversions
extension DniDateTimeComponent {
    public func convert(to targetType: DniDateTimeUnit) -> DniDateTimeComponent {
        return DniDateTimeComponent(prorahnteeValue / targetType.value, type: targetType)
    }

    private var prorahnteeValue: Double {
        return value * type.value
    }

    /// Returns this value rounded to an integral value using the specified rounding rule.
    ///
    /// - Parameter rule: The rounding rule to use, the default value is "schoolbook rounding".
    /// - Returns: The nearest integral value, or, if two integral values are equally close,
    ///     the integral value with greater magnitute.
    public func rounded(_ rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) -> DniDateTimeComponent {
        return DniDateTimeComponent(value.rounded(rule), type: type)
    }

    /// Rounds this value to an integral value using the specified rounding rule..
    ///
    /// - Parameter rule: The rounding rule to use, the default value is "schoolbook rounding".
    public mutating func round(_ rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) {
        self = self.rounded(rule)
    }
}

extension DniDateTimeComponent {
    // Addition
    public static func + (left: DniDateTimeComponent, right: DniDateTimeComponent) -> DniDateTimeComponent {
        return DniDateTimeComponent(left.prorahnteeValue + right.prorahnteeValue, type: .prorahn).convert(to: left.type)
    }
    public static func + (left: DniDateTimeComponent, right: Double) -> DniDateTimeComponent {
        return left + DniDateTimeComponent(right, type: left.type)
    }
    public static func + (left: DniDateTimeComponent, right: Int) -> DniDateTimeComponent {
        return left + DniDateTimeComponent(right, type: left.type)
    }

    public static func += (left: inout DniDateTimeComponent, right: DniDateTimeComponent) { left = left + right }
    public static func += (left: inout DniDateTimeComponent, right: Double) { left = left + right }
    public static func += (left: inout DniDateTimeComponent, right: Int) { left = left + right }

    // Subtraction
    public static func - (left: DniDateTimeComponent, right: DniDateTimeComponent) -> DniDateTimeComponent {
        return DniDateTimeComponent(left.prorahnteeValue - right.prorahnteeValue, type: .prorahn).convert(to: left.type)
    }
    public static func - (left: DniDateTimeComponent, right: Double) -> DniDateTimeComponent {
        return left - DniDateTimeComponent(right, type: left.type)
    }
    public static func - (left: DniDateTimeComponent, right: Int) -> DniDateTimeComponent {
        return left - DniDateTimeComponent(right, type: left.type)
    }

    public static func -= (left: inout DniDateTimeComponent, right: DniDateTimeComponent) { left = left - right }
    public static func -= (left: inout DniDateTimeComponent, right: Double) { left = left - right }
    public static func -= (left: inout DniDateTimeComponent, right: Int) { left = left - right }
}

extension DniDateTimeComponent: Equatable {
    public static func == (lhs: DniDateTimeComponent, rhs: DniDateTimeComponent) -> Bool {
        return lhs.value == rhs.value && lhs.type == rhs.type
    }
}
