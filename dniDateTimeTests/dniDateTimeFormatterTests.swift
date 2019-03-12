//
//  dniDateTimeFormatterTests.swift
//  dniDateTimeTests
//
//  Created by Jeff Hitchcock on 2019-03-11.
//  Copyright © 2019 Jeff Hitchcock. All rights reserved.
//

import XCTest
@testable import dniDateTime

class dniDateTimeFormatterTests: XCTestCase {

    func testStringOutput() {
        let time = DniDateTime(newYearsForHahr: 9876)
        let formatter = DniDateTimeFormatter()

        formatter.dateFormat = .full
        formatter.timeFormat = .full
        XCTAssertEqual("9876 Leefo 1 0:0:0:0", formatter.string(from: time))
        formatter.dateFormat = .long
        XCTAssertEqual("9876.1.1 0:0:0:0", formatter.string(from: time))
        formatter.dateFormat = .medium
        XCTAssertEqual("Leefo 1 0:0:0:0", formatter.string(from: time))
        formatter.dateFormat = .short
        XCTAssertEqual("1.1 0:0:0:0", formatter.string(from: time))
        formatter.dateFormat = .none
        XCTAssertEqual("0:0:0:0", formatter.string(from: time))
    }

}
