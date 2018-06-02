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
    
    func testFullTimetables() {
        do {
            let bundle = Bundle(for: type(of: self))
            //        let inputPath = bundle.path(forResource: "jele17", ofType: "txt")!
            let inputPaths = bundle.paths(forResourcesOfType: "txt", inDirectory: "TestInputs")
            for testFilePath in inputPaths{
                let testFileURL = NSURL.fileURL(withPath: testFilePath) as URL
                let testTTString = try String(contentsOf: testFileURL)
                parseEvents(testTTString)
                initTimetable()
                validateTimetable()
                
                let testFileBase = testFileURL.deletingPathExtension().lastPathComponent
                let testFileDir = try String(contentsOf: testFileURL.deletingLastPathComponent())
                let answerFileString = testFileDir.appending(testFileBase + ".csv")
                let answerFileURL = NSURL.fileURL(withPath: answerFileString) as URL
                let answerString = try String(contentsOf: answerFileURL)
                
                //            XCTAssert(parsedTT == answerString)
            }
        } catch {
            print("error:", error)
        }
    }
    
    
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            print("null")
        }
    }
}


