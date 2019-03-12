//
//  DniDateTimeComponentTests.swift
//  dniDateTimeTests
//
//  Created by Jeff Hitchcock on 2019-03-11.
//  Copyright © 2019 Jeff Hitchcock. All rights reserved.
//

import XCTest
@testable import dniDateTime

class DniDateTimeComponentTests: XCTestCase {
    let allUnits: [DniDateTimeUnit] = [.prorahn, .gorahn, .tahvo, .pahrtahvo, .gahrtahvo, .yahr, .vailee, .hahr]

    func conversionToProrahn(from: DniDateTimeUnit, value: Double) {
    }

    func testConvertToProrahn() {
        for unit in allUnits {
            for value in 0...10 {
                let first = DniDateTimeComponent(value, type: unit).convert(to: .prorahn).value
                let second = Double(unit.value) * Double(value)
                XCTAssertEqual(first, second, """
                    Converting \(unit.name) to \(DniDateTimeUnit.prorahn.name) didn't work for value of \(value).
                    Expected to get \(second) but got \(first) instead.
                    """)
            }
        }
    }
}
