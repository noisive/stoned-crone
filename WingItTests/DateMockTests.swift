//
//  DateMockTests.swift
//  WingItTests
//
//  Created by William Warren on 7/20/18.
//  Copyright © 2018 Noisive. All rights reserved.
//

import XCTest

class DateMockTests: XCTestCase {
    

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDateMock() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        mockDateTime(mockStrO: "2010-02-27+13:05")
        // Specify date components
        var dateComponents = DateComponents()
        dateComponents.year = 2010
        dateComponents.month = 2
        dateComponents.day = 27
        dateComponents.timeZone = TimeZone(abbreviation: "UTC")
        dateComponents.hour = 13
        dateComponents.minute = 05
        // Create date from components
        var userCalendar = Calendar.current // user calendar
        var someDateTime = userCalendar.date(from: dateComponents)
        var today = todaysDate()
        XCTAssert(today == someDateTime)
        
        mockDateTime(mockStrO: "2029-12-01")
        // Specify date components
        dateComponents = DateComponents()
        dateComponents.year = 2029
        dateComponents.month = 12
        dateComponents.day = 01
        dateComponents.timeZone = TimeZone(abbreviation: "UTC")
        // Set to the default for the function, whatever that is...
        dateComponents.hour = 12
        dateComponents.minute = 00
        // Create date from components
        userCalendar = Calendar.current // user calendar
        someDateTime = userCalendar.date(from: dateComponents)
        today = todaysDate()
        XCTAssert(today == someDateTime)
    }
    
}
