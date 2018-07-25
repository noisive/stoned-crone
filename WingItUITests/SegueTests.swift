//
//  SegueTests.swift
//  WingItUITests
//
//  Created by William Warren on 7/25/18.
//  Copyright © 2018 Noisive. All rights reserved.
//

import XCTest

class SegueTests: WingItUITestsSuper {
    
    var menuOptions: [XCUIElement]!
    
    override func setUp() {
        super.setUp()
        setUpFakeData()
        let menuOptionsQuery = app.tables.cells
        menuOptions = menuOptionsQuery.allElementsBoundByIndex
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
//    XCUIApplication().navigationBars["Monday"]/*@START_MENU_TOKEN@*/.buttons["Menu Button"]/*[[".buttons[\"Cancel\"]",".buttons[\"Menu Button\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    func testMenuButton(){
        menuButton.tap()
        XCTAssert(app.tables["Menu"].exists)
    }
    
    func testAbout(){
        menuButton.tap()
        app.tables["Menu"].staticTexts["About"].tap()
//        menuOptions[2].tap()
        XCTAssert(app.tables["About View"].exists)
    }
    
    func testLogout(){
        menuButton.tap()
//        menuOptions[1].tap()
        app.tables["Menu"].staticTexts["Log out/change login"].tap()
//        app.scrollViews
        XCTAssert(app.scrollViews["Login View"].exists)
        XCTAssertFalse(app.buttons["Cancel Button"].exists)
    }
}
