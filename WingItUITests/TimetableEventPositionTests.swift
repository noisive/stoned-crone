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
//            XCTAssertTrue(classAppears)
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
        tapLessonCell(index: 0)
        XCTAssert(app.cells["CodeCell"].staticTexts["TEST008"].exists)
        // XTAssert() // not in 9am slot
    }
    func test6pmSlot(){
        setUpFakeData()
        tapLessonCell(index: 10)
        XCTAssert(app.cells["CodeCell"].staticTexts["TEST018"].exists)
    }

}
