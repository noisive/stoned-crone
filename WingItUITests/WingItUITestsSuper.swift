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
    static var firstLaunch = true
    var backButton: XCUIElement!
    var menuButton: XCUIElement!

    override func setUp() {
        super.setUp()
        app.launchArguments.append("-testing")
        app.launchArguments.append("-reset")
        app.launchArguments.append("-UITests")
        // In UI tests it is usually best to stop immediately when a failure occurs. (They are time-expensive to ru)
        continueAfterFailure = false
        if WingItUITestsSuper.firstLaunch {
            clearNotificationAlert()
            WingItUITestsSuper.firstLaunch = false
        }

        backButton = app.navigationBars.buttons.element(boundBy: 0)
        menuButton = app.navigationBars.buttons["Menu Button"]
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app.launchArguments.removeAll()
        // if let failureCount = testRun?.failureCount, failureCount > 0 {
        //     takeScreenshot()
        // }
        app.terminate()
        super.tearDown()
    }
    
    func clearNotificationAlert(){
        // Waits and checks for allow notifications alert.
        addUIInterruptionMonitor(withDescription: "Notifications") { (alert) -> Bool in
            alert.buttons["Allow"].tap()
            return true
        }
        app.launch()
        app.tap() // need to interact with the app for the handler to fire.
        app.swipeUp()
        app.terminate()
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
    
    func setUpFakeData(){
        // app.launchArguments += ["-mockDate", "2018-10-05"]
        // Fakedata should set default mock date (which is monday).
        app.launchArguments.append("-fakeData")
        app.launch()
        _ = app.otherElements["dayView"].waitForExistence(timeout: 10)
    }

    func getCell(at index: Int) -> XCUIElement{
        let lessonsQuery = app.collectionViews.tables.cells
        let lessons = lessonsQuery.allElementsBoundByIndex
        return lessons[index]
    }

    func lessonExists(withCode: String, atIndex: Int) -> Bool{
        let timeCell = getCell(at: atIndex)
        return timeCell.staticTexts[withCode].exists
    }
    func lessonExists(withCode: String, atTime: Int) -> Bool{
        return lessonExists(withCode: withCode, atIndex: atTime-8)
    }

    func takeScreenshot(){
        let screenshot = XCUIScreen.main.screenshot()
        let attach = XCTAttachment(screenshot: screenshot)
        add(attach)
    }

//    func testingPlayground(){
//
//    }
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
    func forceTap() {
        if self.isHittable {
            self.tap()
        } else {
            let coordinate: XCUICoordinate = self.coordinate(withNormalizedOffset: CGVector(dx: 0.0, dy: 0.0))
            coordinate.tap()
        }
    }
}

extension String {
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
}
