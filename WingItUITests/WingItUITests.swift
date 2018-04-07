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
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.eVisionUsername = setUserFromEnv()
        self.eVisionPassword = setPassFromEnv()


        // In UI tests it is usually best to stop immediately when a failure occurs. (They are time-expensive to ru)
        continueAfterFailure = false


        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.\
        // We send a command line argument to our app,
        // to enable it to reset its state
        //app.launchArguments.append("--uitesting")

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
        app.launchArguments.append("--debugLogin")
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
        app.launchArguments.append("--resetdata")
        app.launch()

        login()

        // Wait for a thing to display, then assert it is displaying... Circular? But should work.
        _ = app/*@START_MENU_TOKEN@*/.otherElements["dayView"]/*[[".otherElements[\"day\"]",".otherElements[\"dayView\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.waitForExistence(timeout: 20)
        XCTAssertTrue(app.isDisplayingTT)

    }

    func testLoginUpdate(){
        
        // Ensure we have a timetable to view
        testLoginFresh()
//        // Avoid each test having to relaunch the app (unless required).
//        if (!WingItUITests.launched) {
//            app.launch()
//            WingItUITests.launched = true
//        }

        login()

        XCTAssertTrue(app.isDisplayingTT)

    }

    func login(){

        _ = app.textFields["Username"].waitForExistence(timeout: 10)
        let usernameTextField = app.textFields["Username"]
        let passwordSecureTextField = app.secureTextFields["Password"]
        
        // Clear in case login info still saved
        usernameTextField.buttons["Clear text"].tap()
        passwordSecureTextField.buttons["Clear text"].tap()
        
        usernameTextField.tap()
        usernameTextField.typeText(self.eVisionUsername)
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(self.eVisionPassword)
        
        app.buttons["Login"].tap()
    }

    func waitForElement(element: XCUIElement){
        // Search for element, wait till it appears.
        let predicate = NSPredicate(format: "exists == 1")
        let query = element
        expectation(for: predicate, evaluatedWith: query, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
    }
}

extension XCUIApplication {
    var isDisplayingTT: Bool {
        return otherElements["dayView"].exists
    }
}
