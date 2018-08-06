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
            let inputPaths = bundle.paths(forResourcesOfType: "txt", inDirectory: "TestInputs")
            for testFilePath in inputPaths{
                let testFileURL = NSURL.fileURL(withPath: testFilePath) as URL
                let testFileBase = testFileURL.deletingPathExtension().lastPathComponent
                //                let testFileDir = try String(contentsOf: testFileURL.deletingLastPathComponent())
                
                print("Parsing test file " + testFileBase)
                
                let testTTString = try String(contentsOf: testFileURL)
                
                let parsedTTString = parseEvents(data: testTTString)
                
                initTimetable()
                validateTimetable()
                
                let answerPath = bundle.path(forResource: "TestAnswers/" + testFileBase, ofType: "csv")!
                let answerFileURL = NSURL.fileURL(withPath: answerPath) as URL
                //                let answerFileString = testFileDir.appending(testFileBase + ".csv")
                //                let answerFileURL = NSURL.fileURL(withPath: answerFileString) as URL
                let answerString = try String(contentsOf: answerFileURL)
                
                XCTAssert(parsedTTString == answerString, "Parsed result: \n\n \(parsedTTString) \n\n does not equal \n\n \(answerString)")
                clearTimetable()
            }
        } catch {
            print("error:", error)
        }
    }
    
    func testLessonInitFromTestTTs(){
        do {
            let bundle = Bundle(for: type(of: self))
            let inputPaths = bundle.paths(forResourcesOfType: "csv", inDirectory: "TestAnswers")
            for testFilePath in inputPaths{
                print("Loading test file " + testFilePath)
                let VC = TimetableView()
                copyTestData(fakeDataURL: URL(fileURLWithPath: testFilePath))
                VC.hourData = [[(lesson: CLong?, lesson2: CLong?)?]](repeating: [(lesson: CLong?, lesson2: CLong?)?](repeating: nil, count: 14), count: 7)
                loadWeekData(VC: VC)
            }
        }
    }
    
    
    
    
    //    func testPerformanceExample() {
    //        // This is an example of a performance test case.
    //        self.measure {
    //            // Put the code you want to measure the time of here.
    //            print("null")
    //        }
    //    }
}


