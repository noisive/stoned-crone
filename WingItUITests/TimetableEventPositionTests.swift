//
//  TimetableEventPositionTests.swift
//  WingItUITests
//
//  Created by William Warren on 7/23/18.
//  Copyright © 2018 Noisive. All rights reserved.
//

import XCTest

class TimetableEventPositionTests: WingItUITestsSuper {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testClassesAppearEachDay(){
        setUpFakeData()
        let lessons = ["MOND001", "TUES001", "WEDS001", "THURS001", "FRID001"]
//        let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
        for i in 0...4 {
//            XCTAssert(app.otherElements[days[i]].exists)
            // Tests all in 9am slot.
            XCTAssert(lessonExists(withCode: lessons[i], atTime: 9))
            app.otherElements["dayView"].swipeLeft()
        }
    }
    
    func testOutdatedDataStillAppears(){
        app.launchArguments += ["-mockDate", "2018-10-15"]
        setUpFakeData()
        XCTAssert(lessonExists(withCode: "MOND001", atTime: 9))
    }

    func testOpensToCurrentDayFri(){
        app.launchArguments += ["-mockDate", "2018-10-05"]
        setUpFakeData()
        XCTAssertTrue(app.otherElements["Friday"].exists)
        XCTAssertFalse(app.otherElements["Monday"].exists)
    }
    func testOpensToCurrentDayMon(){
        setUpFakeData()
        XCTAssertTrue(app.otherElements["Monday"].exists)
    }
    
    func test8amSlot(){
        setUpFakeData()
        XCTAssertFalse(lessonExists(withCode: "TIME008", atTime: 9),  "Is it in 9am slot by mistake?")
        XCTAssert(lessonExists(withCode: "TIME008", atTime: 8))
    }
    func test6pmSlot(){
        setUpFakeData()
        XCTAssertFalse(lessonExists(withCode: "TIME018", atTime: 17), "Is it in 5pm slot by mistake?")
        XCTAssert(lessonExists(withCode: "TIME018", atTime: 18))
    }

    func test2HourCellAppearsInBoth(){
        setUpFakeData()
        XCTAssert(lessonExists(withCode: "HOUR002", atIndex: 3))
        tapLessonCell(index: 4)
        XCTAssert(app.cells["CodeCell"].staticTexts["HOUR002"].exists, "Is it in the second slot too?")
    }
    
    func testRemainsOnDayAfterDetailview(){
        setUpFakeData()
        app.swipeLeft()
        XCTAssertTrue(app.otherElements["Tuesday"].exists)
        tapLessonCell(index: 1)
        XCTAssert(app.cells["CodeCell"].staticTexts["TUES001"].exists)
        backButton.tap()
        XCTAssertFalse(lessonExists(withCode: "MOND001", atIndex: 1))
        XCTAssert(lessonExists(withCode: "TUES001", atIndex: 1))
//        XCTAssert(app.navigationBars["Monday"].exists)
//        XCTAssertFalse(app.otherElements["Monday"].exists)
//        XCTAssertTrue(app.otherElements["Wednesday"].exists)
//        XCTAssertTrue(app.otherElements["Tuesday"].exists)
    }
    
}
