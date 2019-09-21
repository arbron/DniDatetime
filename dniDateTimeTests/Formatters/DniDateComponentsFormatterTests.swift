//
//  DniDateComponentsFormatterTests.swift
//  dniDateTimeTests
//
//  Created by Jeff Hitchcock on 2019-09-20.
//  Copyright © 2019 Jeff Hitchcock. All rights reserved.
//

import XCTest
@testable import dniDateTime

class DniDateComponentFormatterTests: XCTestCase {
    func testGeneralFunctionality() {
        let formatter = DniDateComponentsFormatter()
        formatter.unitsStyle = .positional
        XCTAssertEqual(formatter.string(from: DniDateTimeComponent(convertSeconds: 30, to: .prorahn)), "\\")
        XCTAssertEqual(formatter.string(from: DniDateTimeComponent(convertSeconds: 38, to: .prorahn)), "1:2")
        XCTAssertEqual(formatter.string(from: DniDateTimeComponent(convertSeconds: 1, to: .prorahn )), "1")
        XCTAssertEqual(formatter.string(from: DniDateTimeComponent(convertSeconds: 6, to: .prorahn )), "4")
    }

    func testUnitPruning() {
        let formatter = DniDateComponentsFormatter()
        formatter.maximumUnitCount = 2
        formatter.unitsStyle = .abbreviated

        XCTAssertEqual(formatter.string(from: 19401), "1gt 1pt")
        formatter.allowsFractionalUnits = true
        XCTAssertEqual(formatter.string(from: 19401), "1gt 1.56pt")
    }

    func testZeroFormattingBehavior() {
        let formatter = DniDateComponentsFormatter()
        formatter.allowedUnits = [.prorahn, .gorahn, .tahvo, .pahrtahvo, .gahrtahvo]

        formatter.zeroFormattingBehavior = .default
        formatter.unitsStyle = .full
        XCTAssertEqual(formatter.string(from: 630), "1 Tahvo, 5 Prorahntee")
        formatter.unitsStyle = .positional
        XCTAssertEqual(formatter.string(from: 630), "1:0:5")

        formatter.zeroFormattingBehavior = .dropAll
        formatter.unitsStyle = .abbreviated
        XCTAssertEqual(formatter.string(from: 630), "1t 5p")

        formatter.zeroFormattingBehavior = .dropMiddle
        XCTAssertEqual(formatter.string(from: 630), "0gt 0pt 1t 5p")

        formatter.zeroFormattingBehavior = .dropLeading
        XCTAssertEqual(formatter.string(from: 3175), "1pt 0t 2g 0p")

        formatter.zeroFormattingBehavior = .dropTrailing
        XCTAssertEqual(formatter.string(from: 3175), "0gt 1pt 0t 2g")

        formatter.zeroFormattingBehavior = .pad
        XCTAssertEqual(formatter.string(from: 3175), "0gt 1pt 0t 2g 0p")
    }
}
