//
//  WingItUITestsSuper.swift
//  WingItUITests
//
//  Created by William Warren on 7/23/18.
//  Copyright © 2018 Noisive. All rights reserved.
//

import XCTest

class WingItUITestsSuper: XCTestCase {
    
    var app: XCUIApplication! = XCUIApplication()
    // Track whether app is launched or not. (Some UI tests don't need restarts.)
    static var launched = false
    
    override func setUp() {
        super.setUp()
        app.launchArguments.append("-testing")
        app.launchArguments.append("-reset")
        app.launchArguments.append("-UITests")
        // In UI tests it is usually best to stop immediately when a failure occurs. (They are time-expensive to ru)
        continueAfterFailure = false
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app.launchArguments.removeAll()
        super.tearDown()
    }
    
    func testingPlayground(){
        app.launchArguments.append("-fakeData")
                                
    }
    
}

extension XCUIApplication {
    var isDisplayingTT: Bool {
        return otherElements["dayView"].exists
    }
}
