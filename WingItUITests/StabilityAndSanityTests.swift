//
//  StabilityTests.swift
//  WingItUITests
//
//  Created by William Warren on 7/23/18.
//  Copyright © 2018 Noisive. All rights reserved.
//

import XCTest

class StabilityAndSanityTests: WingItUITestsSuper {
        
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
    
    func testTTChecks(){
        app.launch()
        do {
            let bundle = Bundle(for: type(of: self))
            let inputPaths = bundle.paths(forResourcesOfType: "csv", inDirectory: "TestAnswers")
            app.launchArguments += ["-mockDate", "2018-6-15"]
            for testFilePath in inputPaths{
//                let testFileURL = NSURL.fileURL(withPath: testFilePath) as URL
                app.launchArguments += ["-fakeDataAt", testFilePath]
                app.launch()
                _ = app.otherElements["dayView"].waitForExistence(timeout: 20)
                app.terminate()
                // Take the fake data args out
                app.launchArguments.removeLast()
                app.launchArguments.removeLast()
            }
        }
    }
}
