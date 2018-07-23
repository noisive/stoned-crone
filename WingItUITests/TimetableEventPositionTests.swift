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
    
    func setUpFakeData(){
        // app.launchArguments += ["-mockDate", "2018-10-05"]
        // Fakedata should set default mock date (which is monday).
        app.launchArguments.append("-fakeData")
        app.launch()
        _ = app.otherElements["dayView"].waitForExistence(timeout: 10)
    }
    
    func testClassesAppearEachDay(){
        setUpFakeData()
        for _ in 0...5 {
            tapLessonCell(index: 1)
            XCTAssert(app.cells["CodeCell"].staticTexts["TEST001"].exists)
            app.otherElements["dayView"].swipeLeft()
        }
    }
    
    func testOpensToCurrentDayFri(){
        app.launchArguments += ["-mockDate", "2018-10-05"]
        setUpFakeData()
        XCTAssertTrue(app.otherElements["Friday"].exists)
    }
    func testOpensToCurrentDayMon(){
        setUpFakeData()
        XCTAssertTrue(app.otherElements["Monday"].exists)
    }
    
    func test8amSlot(){
        setUpFakeData()
        tapLessonCell(index: 1)
        XCTAssertFalse(app.cells["CodeCell"].staticTexts["TIME008"].exists, "Not in 5pm slot by mistake")
        if app.cells["CodeCell"].exists {
            tapBackButton()
        }
        tapLessonCell(index: 0)
        XCTAssert(app.cells["CodeCell"].staticTexts["TIME008"].exists)
    }
    func test6pmSlot(){
        setUpFakeData()
        tapLessonCell(index: 9)
        XCTAssertFalse(app.cells["CodeCell"].staticTexts["TIME018"].exists, "Not in 5pm slot by mistake")
        if app.cells["CodeCell"].exists {
            tapBackButton()
        }
        tapLessonCell(index: 10)
        XCTAssert(app.cells["CodeCell"].staticTexts["TIME018"].exists)
    }
    func test2HourCellAppearsInBoth(){
        setUpFakeData()
        tapLessonCell(index: 3)
        XCTAssert(app.cells["CodeCell"].staticTexts["HOUR002"].exists)
        tapBackButton()
        tapLessonCell(index: 4)
        XCTAssert(app.cells["CodeCell"].staticTexts["HOUR002"].exists)
    }

}
