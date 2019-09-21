//
//  DniDateComponentsFormatter.swift
//  dniDateTime
//
//  Created by Jeff Hitchcock on 2019-09-17.
//  Copyright © 2019 Jeff Hitchcock. All rights reserved.
//

import Foundation
import DniNumberFormatter

/// A formatter that creates string representations of quantities of D'ni time.
///
/// 
public final class DniDateComponentsFormatter: Formatter {
    // MARK: Formatting Values
    /// Returns a formatted string based on the specified date components.
    ///
    ///
    public func string(from components: DniDateTimeComponent...) -> String? {
        let prorahn = components.reduce(0) {
            $0 + $1.convert(to: .prorahn).value
        }
        return string(from: prorahn)
    }

    ///
    ///
    public override func string(for: Any?) -> String? {
        fatalError()
    }

    ///
    ///
    public func string(from: DniDateTime, to: DniDateTime) -> String? {
        fatalError()
    }

    ///
    ///
    public func string(from interval: DniTimeInterval) -> String? {
        fatalError()
    }

    /// Create a string from a number of Prorahntee.
    ///
    ///
    public func string(from prorahntee: Double) -> String? {
        let components = padWithZeroes(pruneUnits(createComponents(prorahntee)))
        return formString(components)
    }

    // MARK: Configuring the Formatter Options
    /// The array of calendrical units such as day and month to include in the output string.
    ///
    /// The default value of this property is `nil`, which does not restrict any units.
    public var allowedUnits: [DniDateTimeUnit]? = nil

    /// A Boolean indicating whether non-integer units may be used for values.
    ///
    /// Fraction units may be used when a value cannot be exactly represented using the available units.
    /// For example, if prorahntee are not allowed, the value "1t 5p" could be formatted as "1.5t".
    ///
    /// The default value of this property is `false`.
    public var allowsFractionalUnits: Bool = false

    // TODO: includesApproximationPhrase
    // TODO: includesTimeRemainingPhrase

    /// The maximum number of time units to include in the output string.
    ///
    /// Use this property to limit the number of units displayed in the resulting string. For example, with this
    /// property set to 2, instead of "1pa 14t 24p", the resulting string would be "1pa 14t". Use this property
    /// when you are constrained for space or want to round values up to the nearst large unit.
    ///
    /// The default value of this property is `nil`, which does not cause the elimination of any units.
    ///
    /// - Precondition: Value must be greater than zero.
    public var maximumUnitCount: Int? = nil {
        willSet {
            guard let value = newValue else { return }
            precondition(value > 0, "Maximum unit count cannot be less than one.")
        }
    }

    /// The formatting style for unit names.
    ///
    /// Configures the strings to use (if any) for unit names such as yahrtee, tahvotee, gorahntee,
    /// and prorahntee. Use this property to specify whether you want abbreviated or shortened
    /// versions of unit names—for example, `pro` instead of `prorahn`.
    ///
    /// The default value of this property is `positional`.
    public var unitsStyle: UnitsStyle = .positional

    /// The formatting style for units whose value is 0.
    ///
    /// When the value for a particular unit is 0, the zero formatting behavior determins whether the value
    /// is retained or omitted from any resulting strings. For example, when the formatting behavior is
    /// `dropTrailing`, the value of one tahvotee, fifteen gorahntee, and zero, prorahntee would omit
    /// the mention of prorahntee.
    ///
    /// The default value of this property is `default`.
    public var zeroFormattingBehavior: ZeroFormattingBehavior = .default


    // MARK: Constants
    /// Constants for specifying how to represent quantities of time.
    public enum UnitsStyle {
        /// A style that spells out the units and quantities of time.
        ///
        /// Example: "".
        case spellOut

        /// A style that spells out the units of time, but not the quantities.
        ///
        /// Example: "7 pahrtahvotee, 14 tahvotee, 24 prorahntee".
        case full

        /// A style that uses a shortened spelling for units of time.
        ///
        /// Example: "7 pahr, 14 tah, 24 pro".
        case short

        /// A style that uses an even shorter spelling for units of time
        /// compared to `DniDateComponentsFormatter.Style.short`.
        ///
        /// Example: "7pahr 14tah 24pro".
        case brief

        /// A style that uses the most abbreviated spelling for units of time.
        ///
        /// Example: "7pa 14t 24p".
        case abbreviated

        /// A style that uses the position of the unit of time to identify its value.
        ///
        /// Example: "7:14:0:24".
        case positional
    }

    /// Formatting constants for when values contain zeroes.
    public enum ZeroFormattingBehavior {
        /// The default formatting behavior for each style is used.
        ///
        /// When using positional units, this behavior drops leading zeroes but pads midding and trailing values
        /// with zeroes when needed. For example, with tahvotee, gorahntee, and prorahntee displayed, the value
        /// for one tahvo and 23 prorahntee is "1:0:23". For all other unit styles, this behavior drops all units
        /// whose values are 0. For example, when pahtahvotee, tahvrotee, gorahntee, and prorahntee are allowed,
        /// the abbreviated version of one tahvo and 23 prorahntee is displayed as "1t 23p".
        case `default`

        ///
        ///
        case dropLeading

        ///
        ///
        case dropMiddle

        ///
        ///
        case dropTrailing

        ///
        ///
        case dropAll

        /// The add padding zeroes bahvior.
        ///
        /// This behavior pads values with zeroes as appropriate. For example, consider the value
        /// of one tahvo formatted using the position and abbreviated unit styles. When pahrtahvotee, gorahntee,
        /// and prorahntee are allowed, the value is displayed as "0:1:0:0" using the positional style, and as
        /// "0pt 1t 0g 0p" using the abbreviated style.
        case pad
    }
}

extension DniDateComponentsFormatter {
    fileprivate static var numberFormatter: DniNumberFormatter = {
        let formatter = DniNumberFormatter()
        formatter.roundingMode = .nearest
        return formatter
    }()

    fileprivate func orderedAllowedUnits() -> [DniDateTimeUnit] {
        let units = allowedUnits ?? DniDateTimeUnit.allCases
        return units.sorted { $0.value > $1.value }
    }

    /// Takes a Prorahn value and converts it to an array of components allowed by `allowedUnits` with
    /// any appropriate fractional amounts if allowed.
    ///
    /// - Parameter interval: Length of time for which to create components.
    /// - Returns: Array of components.
    fileprivate func createComponents(_ interval: Double) -> [DniDateTimeComponent] {
        guard interval != 0 else { return [] }

        var workingInterval = interval
        let units = orderedAllowedUnits()
        var results: [DniDateTimeComponent] = units.compactMap {
            var component = DniDateTimeComponent(workingInterval, type: .prorahn).convert(to: $0)
            guard component.value >= 1 || (workingInterval < 1 && component.value > 0) else { return nil }
            if $0 != units.last {
                component.round(.towardZero)
            }
            workingInterval -= component.convert(to: .prorahn).value
            return component.value > 0 ? component : nil
        }
        if results.isEmpty, let smallestUnit = units.last {
            results.append(DniDateTimeComponent(interval, type: .prorahn).convert(to: smallestUnit))
        }
        return results
    }

    /// Merge and remove units to accompidate `maximumUnitCount`.
    fileprivate func pruneUnits(_ components: [DniDateTimeComponent]) -> [DniDateTimeComponent] {
        guard let maxUnits = maximumUnitCount, components.count > maxUnits else { return components }
        let discardedComponents = Array(components.suffix(from: maxUnits))
        var keptComponents = Array(components.prefix(upTo: maxUnits))

        keptComponents[maxUnits - 1] = discardedComponents.reduce(keptComponents[maxUnits - 1], +)

        return keptComponents
    }

    /// Add components with a value of zero when required by `zeroFormattingBehavior`.
    ///
    /// - Parameter components: Array of `DniDateTimeComponent`s to modify.
    /// - Returns: Array of components modified if necessary.
    fileprivate func padWithZeroes(_ components: [DniDateTimeComponent]) -> [DniDateTimeComponent] {
        guard zeroFormattingBehavior != .dropAll else { return components }
        guard !components.isEmpty else {
            switch zeroFormattingBehavior {
            case .pad: return orderedAllowedUnits().map { DniDateTimeComponent(0, type: $0) }
            default: return []
            }
        }
        
        enum State {
            case beforeFirst, middle, afterLast
        }
        var state = State.beforeFirst

        return orderedAllowedUnits().compactMap { unit in
            if let last = components.last, last.type == unit {
                state = .afterLast
                return last
            } else if let first = components.first, first.type == unit {
                state = .middle
                return first
            } else if let other = components.first(where: { $0.type == unit }) {
                return other
            } else {
                switch (state, zeroFormattingBehavior, unitsStyle) {
                case (_, .pad, _),
                     (.middle, .default, .positional),
                     (.afterLast, .default, .positional):
                    return DniDateTimeComponent(0, type: unit)

                case (.beforeFirst, .dropLeading, _),
                     (.beforeFirst, .default, _),
                     (.middle, .dropMiddle, _),
                     (.middle, .default, _),
                     (.afterLast, .dropTrailing, _),
                     (.afterLast, .default, _):
                    return nil

                default:
                    return DniDateTimeComponent(0, type: unit)
                }
            }
        }
    }

    /// Take a list of components and form the full string using the unit style.
    ///
    /// - Parameter components: Components to use when forming the string.
    /// - Returns: Full string of values and units.
    fileprivate func formString(_ components: [DniDateTimeComponent]) -> String {
        guard !components.isEmpty else { return "" }

        let joiner: String
        switch self.unitsStyle {
        case .spellOut, .full: joiner = ", "
        case .short, .brief, .abbreviated: joiner = " "
        case .positional: joiner = ":"
        }

        DniDateComponentsFormatter.numberFormatter.maximumFractionDigits = allowsFractionalUnits ? 2 : 0
        let allowedUnits = orderedAllowedUnits()

        var lastRoundedUp = false
        var stringComponents: [String] = components.reversed().map {
            DniDateComponentsFormatter.numberFormatter.maximumIntegerDigits = $0.type == allowedUnits[0] ? 42 : 1

            let value = !lastRoundedUp ? $0.value : $0.value + 1
            let formattedNumber = DniDateComponentsFormatter.numberFormatter.string(forNumber: Decimal(value),
                                                                                    trackingOverflow: &lastRoundedUp)

            return formStringElement(value, formattedNumber, $0.type)
        }

        // If the final component was rounded around, add another component if possible.
        if lastRoundedUp && components[0].type != allowedUnits[0] {
            var nextType: DniDateTimeUnit?
            var index = allowedUnits.endIndex - 1
            while index > allowedUnits.startIndex {
                guard allowedUnits[index] != components[0].type else {
                    nextType = allowedUnits[index - 1]
                    break
                }
                index -= 1
            }
            if let type = nextType {
                stringComponents.append(
                    formStringElement(1, DniDateComponentsFormatter.numberFormatter.string(forNumber: 1), type)
                )
            }
        }

        return stringComponents.reversed().joined(separator: joiner)
    }

    ///
    ///
    ///
    fileprivate func formStringElement(_ number: Double, _ formattedNumber: String, _ type: DniDateTimeUnit) -> String {
        switch self.unitsStyle {
        case .spellOut:
            let writtenNumber = ""
            let typeName = number == 1 ? type.name : type.pluralName
            return "\(writtenNumber) \(typeName)"
        case .full:
            let typeName = number == 1 ? type.name : type.pluralName
            return "\(formattedNumber) \(typeName)"
        case .short:
            return "\(formattedNumber) \(type.shortName)"
        case .brief:
            return "\(formattedNumber)\(type.shortName)"
        case .abbreviated:
            return "\(formattedNumber)\(type.abbreviatedName)"
        case .positional:
            return formattedNumber
        }
    }
}
