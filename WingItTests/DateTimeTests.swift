//
//  DateMockTests.swift
//  WingItTests
//
//  Created by William Warren on 7/20/18.
//  Copyright © 2018 Noisive. All rights reserved.
//

import XCTest
@testable import WingIt

class DateTimeTests: XCTestCase {
    

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
        XCTAssert(getDayOfWeek() == 1)
        mockDateTime(mockStrO: "2018-10-5")
        XCTAssert(getDayOfWeek() == 5)
        mockDateTime(mockStrO: "2018-10-6")
        XCTAssert(getDayOfWeek() == 6)
        mockDateTime(mockStrO: "2018-10-7")
        XCTAssert(getDayOfWeek() == 7)
    }
    
    func testRecentMondayIsCorrect(){
        var testMonday: Date
        let formatter = DateFormatter()
        let formatStr = "yyyy-MM-dd+HH:mm zzz" // ISO datetime format.
        formatter.dateFormat = formatStr
        let actualMonday = formatter.date(from: "2018-10-01+00:00 UTC")!
        mockDateTime(mockStrO: "2018-10-01") // A monday.
        testMonday = getMondaysDate()
        XCTAssert(testMonday == actualMonday)
        mockDateTime(mockStrO: "2018-10-05") // Friday
        testMonday = getMondaysDate()
        XCTAssert(testMonday == actualMonday)
        mockDateTime(mockStrO: "2018-10-07") // Sunday
        testMonday = getMondaysDate()
        XCTAssert(testMonday == actualMonday)
    }
    
    func testNotification8AM(){
        UIApplication.shared.cancelAllLocalNotifications()
        mockDateTime(mockStrO: "2018-10-01+01:00")
        let app = UIApplication.shared
        setNotificationFromFakeLesson(dateStr: "2018-10-01", time24H: 8)
        let scheduledNotifs = app.scheduledLocalNotifications ?? []
        XCTAssert(scheduledNotifs[0].fireDate == getDateFromISOString(str: "2018-9-30+18:45"))
    }
    
    func testStaleEventDoesNotCreateNotification(){
        UIApplication.shared.cancelAllLocalNotifications()
        mockDateTime(mockStrO: "2018-10-01+09:00")
        let app = UIApplication.shared
        setNotificationFromFakeLesson(dateStr: "2018-10-1", time24H: 8)
        let scheduledNotifs = app.scheduledLocalNotifications ?? []
        XCTAssert(scheduledNotifs.count == 0)
    }
    
    func setNotificationFromFakeLesson(dateStr: String, time24H: Int){
        let date = dateFromISOString(str: dateStr)!
        let day = getDayOfWeek(date: date)
        let lesson = Lesson(uid: 1, classID: "NOTI0\(time24H)", start: time24H, duration: 1, colour: "#FFFFFF", code: "NOTI008", type: "Lecture", roomShort: "T", roomFull: "T", building: "T", paperName: "T", day: day, eventDate: date, latitude: -45, longitude: 175)
        setNotification(event: lesson)
    }
}
