//
//  NIBM_EventsTests.swift
//  NIBM EventsTests
//
//  Created by Pradeep Sanjaya on 2/26/20.
//  Copyright © 2020 Pradeep Sanjaya. All rights reserved.
//

import XCTest
@testable import NIBM_Events

class NIBM_EventsTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testValidator() {
        XCTAssertEqual(Validator.isValidEmail("sanjayangp@gmail.com"), true)
        XCTAssertEqual(Validator.isValidEmail("sanjayangp"), false)
    }

    func testDateutils() {
        let d1 = Date()
        print("date 1: \(d1)")
        let d2 = Calendar.current.date(byAdding: .day, value: 1, to: d1)!
        print("date2: \(d2)")
        print("d2 description: \(d2.description)")
        
        XCTAssertEqual(DateUtils.addDates(to: Date(), days: 1)?.description, d2.description)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
