//
//  WingItUITestsSuper.swift
//  WingItUITests
//
//  Created by William Warren on 7/23/18.
//  Copyright © 2018 Noisive. All rights reserved.
//

import XCTest

class WingItUITestsSuper: XCTestCase {
    
    /* ------------- TIPS --------------
 To figure out what the label of an element is for you to call a method on it,
 create a breakpoint where it appears and put
    po print(app.debugDescription)
 in the console.
 This will print all accessibility information for the app, so should find
 anything with a correct label.
 ----------------------------------------*/
    
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
    
    func tapLessonCell(index: Int){
        let lessonsQuery = app/*@START_MENU_TOKEN@*/.collectionViews.tables/*[[".otherElements[\"day\"].collectionViews",".cells.tables",".tables",".otherElements[\"dayView\"].collectionViews",".collectionViews"],[[[-1,4,1],[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.cells
        let lessons = lessonsQuery.allElementsBoundByIndex
        let lesson = lessons[index]
//        let lesson = lessons.element(boundBy: index)
        scrollToLessonCell(element: lesson)
        lesson.tap()
    }
    
    func scrollToLessonCell(element: XCUIElement) {
        while !element.visible() {
            app.otherElements["dayView"].swipeUp()
        }
    }
    
    func tapBackButton(){
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }

    func lessonExists(withCode: String, atIndex: Int){
        let timeCell = getCell(at: atIndex)
        return timeCell.staticTexts[withCode].exists
    }
    func lessonExists(withCode: String, atTime: Int){
        return lessonExists(withCode: withCode, atIndex: atTime-8)
    }
    
    
    func testingPlayground(){

    }
}

extension XCUIApplication {
    var isDisplayingTT: Bool {
        return otherElements["dayView"].exists
    }
}

extension XCUIElement {
    func visible() -> Bool {
        guard self.exists && !self.frame.isEmpty else { return false }
        return XCUIApplication().windows.element(boundBy: 0).frame.contains(self.frame)
    }
}
