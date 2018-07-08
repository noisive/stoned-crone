//
//  WingItUITests.swift
//  WingItUITests
//
//  Created by William Warren on 10/6/17.
//  Copyright © 2017 Noisive. All rights reserved.
//

import XCTest
import Foundation //env variables

class WingItUITests: XCTestCase {

    var app: XCUIApplication! = XCUIApplication()
    // Track whether app is launched or not. (Some UI tests don't need restarts.)
    static var launched = false


    var eVisionUsername: String = ""
    var eVisionPassword: String = ""
    
    func setUserFromEnv() -> String{
        guard let eVisionUsername = ProcessInfo.processInfo.environment["EVISIONUSER"] else {
            let eVisionUsername = ""
            return eVisionUsername
        }
        return eVisionUsername
    }
    func setPassFromEnv() -> String{
        guard let eVisionPassword = ProcessInfo.processInfo.environment["EVISIONPW"] else {
            let eVisionPassword = ""
            return eVisionPassword
        }
        return eVisionPassword
    }

    override func setUp() {
        super.setUp()
        app.launchArguments.append("testing")
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.eVisionUsername = setUserFromEnv()
        self.eVisionPassword = setPassFromEnv()


        // In UI tests it is usually best to stop immediately when a failure occurs. (They are time-expensive to ru)
        continueAfterFailure = false


        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.\
        // We send a command line argument to our app,
        // to enable it to reset its state
        //app.launchArguments.append("uitesting")

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }


    func testingPlayground(){
        

    }


    // Special webview window without any coverplate. For debugging webview login.
    func testLoginRaw(){
        // Argument to enter raw
        app.launchArguments.append("debugLogin")
        app.launch()
        print("hi")

        let webViewsQuery = app.webViews

        let element2 = webViewsQuery.otherElements["Otago Student Administration - The University of Otago"].children(matching: .other).element(boundBy: 6)
        let textField = element2.children(matching: .textField).element
        // Need to wait
        textField.tap()
        textField.typeText(eVisionUsername)
        element2.children(matching: .secureTextField).element.typeText(eVisionPassword)
        app.typeText("\r")

        //XCTAssertEqual(data.json, )

    }

    // Test that a fresh login reaches a timetable.
    func testLoginFresh(){
        app.launchArguments.append("resetdata")
        app.launch()
        _ = app.launchArguments.popLast()

        // Waits and checks for allow notifications alert.
        addUIInterruptionMonitor(withDescription: "Notifications") { (alert) -> Bool in
            alert.buttons["Allow"].tap()
            return true
        }
//        launchFinished() // wait for app to load and notification to show.
        app.tap() // need to interact with the app for the handler to fire.
        
        login()

        // Wait for a thing to display, then assert it is displaying... Circular? But should work.
        _ = app.otherElements["dayView"].waitForExistence(timeout: 120)
        XCTAssertTrue(app.isDisplayingTT)

    }
    
    func testCancelButtonNotPresentFresh(){
        app.launchArguments.append("resetdata")
        app.launch()
        
        // Waits and checks for allow notifications alert.
        addUIInterruptionMonitor(withDescription: "Notifications") { (alert) -> Bool in
            alert.buttons["Allow"].tap()
            return true
        }
        //        launchFinished() // wait for app to load and notification to show.
        app.tap() // need to interact with the app for the handler to fire.
        
        XCTAssertTrue(!cancelButtonExists())
    }

    func testLoginUpdate(){
        
        // Ensure we have a timetable to view
        testLoginFresh()
//        // Avoid each test having to relaunch the app (unless required).
//        if (!WingItUITests.launched) {
//            app.launch()
//            WingItUITests.launched = true
//        }

        _ = app.otherElements["dayView"].waitForExistence(timeout: 40)
        app.buttons["Refresh"].tap()
        
        login()
        
        _ = app.otherElements["dayView"].waitForExistence(timeout: 60)
        XCTAssertTrue(app.isDisplayingTT)

    }
    
    func testDataPersistenceOnRestart(){
        
        // Ensure we have a timetable to view
        app.launchArguments.append("resetdata")
        app.launch()
        _ = app.launchArguments.popLast()
        app.terminate()
        app.launch()
        createTestData()
        app.terminate()
        app.launch()
        _ = app.otherElements["dayView"].waitForExistence(timeout: 60)
        XCTAssertTrue(app.isDisplayingTT)
        
    }

    func testCancelButtonExistsOnRefresh(){
        // Ensure we have a timetable to view
        testLoginFresh()
        _ = app.otherElements["dayView"].waitForExistence(timeout: 40)
        app.buttons["Refresh"].tap()
        XCTAssertTrue(cancelButtonExists())
    }

    func login(){

        _ = app.textFields["Username"].waitForExistence(timeout: 60)
        let usernameTextField = app.textFields["Username"]
        let passwordSecureTextField = app.secureTextFields["Password"]
        
        // Check if clear button exists (if box is empty, it won't)
        if usernameTextField.buttons["Clear text"].exists {
            // Clear in case login info still saved
            usernameTextField.buttons["Clear text"].tap()
            passwordSecureTextField.buttons["Clear text"].tap()
        }
        
        usernameTextField.tap()
        usernameTextField.typeText(self.eVisionUsername)
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(self.eVisionPassword)
        
        app.buttons["Login"].tap()
    }

    func createTestData(){

        let fileManager = FileManager.default
        let cacheURL = try! fileManager
            .url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let dataPath = cacheURL.appendingPathComponent("data.csv")

        let sampleLine = "464737,1,9,2,#09BBF7,Practical,WINE101,Network Management,-45.8670533441689,170.518171263001,OUSA,OUSA Evison Lounge,OUSA Recreation Centre,2018-07-02"
        // let sampleLine = "464737,1,9,2,#09BBF7,Practical,WINE101,Network Management,-45.8670533441689,170.518171263001,OUSA,OUSA Evison Lounge,OUSA Recreation Centre,2018-07-09\n577162,1,11,1,#D3D3D3,Lecture,EVIS107,Lessons on software design,-45.8664207533545,170.515870883468,CLOCKTOW,Clocktower Offices,Clocktower,2018-07-09\n459568,1,12,1,#D3D3D3,Lecture,SUCK501,Lessons on antagonising students,-45.8636426650169,170.513851671001,BURN1,Burns 1,Arts building,2018-07-09\n478445,1,13,1,#FFD700,Tutorial,STON317,Theory of Computing,-45.8670533441689,170.518171263001,FLAT660,Owheo Room G34 COSC,Owheo Building,2018-07-02\n464992,1,13,1,#09BBF7,Practical,CRON301,Network Management,-45.8670533441689,170.518171263001,LEITH,Owheo Lab G38 COSC,Owheo Building,2018-07-09"
        do{
            try sampleLine.write(to: dataPath, atomically: false, encoding: .utf8)
        }
        catch {
        }
    }

    func waitForElement(element: XCUIElement){
        // Search for element, wait till it appears.
        let predicate = NSPredicate(format: "exists == 1")
        let query = element
        expectation(for: predicate, evaluatedWith: query, handler: nil)
        waitForExpectations(timeout: 30, handler: nil)
    }
    
    func cancelButtonExists()->Bool{
        return app.buttons["cancel"].exists
    }
}

extension XCUIApplication {
    var isDisplayingTT: Bool {
        return otherElements["dayView"].exists
    }
}
