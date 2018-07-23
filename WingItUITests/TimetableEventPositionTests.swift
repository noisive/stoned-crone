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
        app.launchArguments.append("-fakeData")
        app.launch()
        _ = app.otherElements["dayView"].waitForExistence(timeout: 10)
        for _ in 0...5 {
//            XCTAssertTrue(classAppears)
            app.otherElements["dayView"].swipeLeft()
        }
    }
    
    func testOpensToCurrentDayFri(){
        app.launchArguments += ["-mockDate", "2018-10-05"]
        app.launchArguments.append("-fakeData")
        app.launch()
        _ = app.otherElements["Friday"].waitForExistence(timeout: 10)
        XCTAssertTrue(app.otherElements["Friday"].exists)
    }
    func testOpensToCurrentDayMon(){
        // app.launchArguments += ["-mockDate", "2018-10-05"]
        // Fakedata should set default mock date (which is monday).
        app.launchArguments.append("-fakeData")
        app.launch()
        _ = app.otherElements["Monday"].waitForExistence(timeout: 10)
        XCTAssertTrue(app.otherElements["Monday"].exists)
    }
    
    func test8amSlot(){
        app.launchArguments.append("-fakeData")
        app.launch()
        _ = app.otherElements["dayView"].waitForExistence(timeout: 10)
        // XTAssert() // not in 7am slot
        // XTAssert() // in 8am slot
        // XTAssert() // not in 9am slot
    }
    func test6pmSlot(){
        app.launchArguments.append("-fakeData")
        app.launch()
        _ = app.otherElements["dayView"].waitForExistence(timeout: 10)
        // XTAssert() // not in 17 slot
        // XTAssert() // in 18 slot
        // XTAssert() // not in 19 slot
    }
    
}
