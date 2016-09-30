//
//  dniDateTimeTests.swift
//  dniDateTimeTests
//
//  Created by Jeff Hitchcock on 2016-09-22.
//  Copyright © 2016 Jeff Hitchcock. All rights reserved.
//

import XCTest
@testable import dniDateTime

class dniDateTimeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEquality() {
        let testDate = Date()
        let one = DniDateTime(withDate: testDate)
        let two = DniDateTime(withDate: testDate)
        XCTAssertEqual(one, two, "Two DniDateTime objects were not equal.")
    }
    
    func testComparability() {
        let earlierDate = DniDateTime(withDate: Date())
        let laterDate = DniDateTime(withDate: Date(timeIntervalSinceNow: 5000))
        XCTAssertGreaterThan(laterDate, earlierDate)
        XCTAssertLessThan(earlierDate, laterDate)
    }
    
    func testNewYears() {
        // All surface times are PST
        // 1998-04-21 02:35:18 == 9654:1:1 00:00:00:00
        let firstSurface = DniDateTime(year: 1998, month: 4, day: 21, hour: 2, minute: 35, second: 18)
        let firstCavern = DniDateTime(newYearsForHahr: 9654)
        XCTAssertEqual(firstSurface, firstCavern, "First new years did not match.")
        
        // 1999-04-21 08:24:03 == 9655:1:1 00:00:00:00
        let secondSurface = DniDateTime(year: 1999, month: 4, day: 21, hour: 8, minute: 24, second: 3)
        let secondCavern = DniDateTime(newYearsForHahr: 9655)
        XCTAssertEqual(secondSurface, secondCavern, "Second new years did not match.")
        
        // 2000-04-20 14:12:48 == 9656:1:1 00:00:00:00
        let thirdSurface = DniDateTime(year: 2000, month: 4, day: 20, hour: 14, minute: 12, second: 48)
        let thirdCavern = DniDateTime(newYearsForHahr: 9656)
        XCTAssertEqual(thirdSurface, thirdCavern, "Third new years did not match.")
        
        // 2001-04-20 20:01:33 == 9657:1:1 00:00:00:00
        let fourthSurface = DniDateTime(year: 2001, month: 4, day: 20, hour: 20, minute: 1, second: 33)
        let fourthCavern = DniDateTime(newYearsForHahr: 9657)
        XCTAssertEqual(fourthSurface, fourthCavern, "Fourth new years did not match.")
        
        // 2002-04-21 01:50:18 == 9658:1:1 00:00:00:00
        let fifthSurface = DniDateTime(year: 2002, month: 4, day: 21, hour: 1, minute: 50, second: 18)
        let fifthCavern = DniDateTime(newYearsForHahr: 9658)
        XCTAssertEqual(fifthSurface, fifthCavern, "Fifth new years did not match.")
        
        // 2003-04-21 07:39:03 == 9659:1:1 00:00:00:00
        let sixthSurface = DniDateTime(year: 2003, month: 4, day: 21, hour: 7, minute: 39, second: 3)
        let sixthCavern = DniDateTime(newYearsForHahr: 9659)
        XCTAssertEqual(sixthSurface, sixthCavern, "Sixth new years did not match.")
    }
    
}
