//
//  StabilityTests.swift
//  WingItUITests
//
//  Created by William Warren on 7/23/18.
//  Copyright © 2018 Noisive. All rights reserved.
//

import XCTest

class StabilityTests: WingItUITestsSuper {
        
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    func testSwipePastEndOfArrayFast(){
        // Ensure we have a timetable to view
        //        testLoginFresh()
        app.launch()
        UIApplication.shared.keyWindow?.layer.speed = 500
        UIView.setAnimationsEnabled(false)
        
        for _ in 1...8 {
            app.otherElements["dayView"].swipeLeft()
        }
        
        XCTAssertTrue(app.isDisplayingTT)
    }
}
