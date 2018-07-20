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
        var userCalendar = Calendar.current // user calendar
//        userCalendar.timeZone = TimeZone(abbreviation: "NZST")!
        userCalendar.timeZone = TimeZone.current
        mockDateTime(mockStrO: "2010-02-27+13:05")
        // Specify date components
        var dateComponents = DateComponents()
        dateComponents.timeZone = TimeZone(abbreviation: "UTC")
        dateComponents.year = 2010
        dateComponents.month = 2
        dateComponents.day = 27
        dateComponents.hour = 13
        dateComponents.minute = 05
        // Create date from components
        var someDateTime = userCalendar.date(from: dateComponents)
        var today = todaysDate()
        XCTAssert(today == someDateTime)
        
        mockDateTime(mockStrO: "2029-12-01")
        // Specify date components
        dateComponents = DateComponents()
        dateComponents.timeZone = TimeZone(abbreviation: "UTC")
        dateComponents.year = 2029
        dateComponents.month = 12
        dateComponents.day = 01
        // Set to the default for the function, whatever that is...
        dateComponents.hour = 12
        dateComponents.minute = 00
        // Create date from components
        someDateTime = userCalendar.date(from: dateComponents)
        today = todaysDate()
        XCTAssert(today == someDateTime)
    }
    
    func testDayMock(){
        mockDateTime()
        var day = getDayOfWeek()
        XCTAssert(getDayOfWeek() == 1)
        mockDateTime(mockStrO: "2018-10-5")
        day = getDayOfWeek()
        XCTAssert(getDayOfWeek() == 5)
        mockDateTime(mockStrO: "2018-10-7")
        day = getDayOfWeek()
        XCTAssert(getDayOfWeek() == 7)
    }
    
}
