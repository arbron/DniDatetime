//
//  DniTimeIntervalTests.swift
//  dniDateTimeTests
//
//  Created by Jeff Hitchcock on 2019-09-13.
//  Copyright © 2019 Jeff Hitchcock. All rights reserved.
//

import XCTest
@testable import dniDateTime

class dniTimeIntervalTests: XCTestCase {
    func testValues() {
        let interval = DniTimeInterval(
            DniDateTimeComponent(9805.0, type: .prorahn)
        )
        print("\(interval.pahrtahvotee) | \(interval.tahvotee) | \(interval.gorahntee) | \(interval.prorahntee)")
        XCTAssertEqual(interval.pahrtahvotee, 3)
        XCTAssertEqual(interval.tahvotee, 0)
        XCTAssertEqual(interval.gorahntee, 17)
        XCTAssertEqual(interval.prorahntee, 5.0)
    }
}
