//
//  FullTTTests.swift
//  BackendTests
//
//  Created by William Warren on 6/1/18.
//  Copyright © 2018 Noisive. All rights reserved.
//

import XCTest
@testable import WingIt
//@testable import Backend

class BackendTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        do {
            let fileURL = NSURL.fileURL(withPath: "/home/cshome/w/wwarren/stoned-crone/Backend/parserTests/TestInputs/frid17.txt") as URL
            // reading from disk
            let testTTString = try String(contentsOf: fileURL)
            let _ = getDayOfWeek()
            parseEvents(testTTString)
            //            initTimetable()
            
        } catch {
            print("error:", error)
        }
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            print("null")
        }
    }
    
}

