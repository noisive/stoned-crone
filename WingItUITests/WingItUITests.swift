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
        XCUIApplication().navigationBars["Log in to eVision"].buttons["Cancel"].tap()

        XCTAssertTrue(app.isDisplayingDay)

    }

    func testLoginUpdate(){
        testLoginFresh()
        app.launch()
        app.navigationBars["Friday"].children(matching: .button).element.tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Update / Log in"]/*[[".cells.staticTexts[\"Update \/ Log in\"]",".staticTexts[\"Update \/ Log in\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        login()

        XCTAssertTrue(app.isDisplayingDay)

    }

    func login(){

        waitForElement(element: app.textFields["Username"])
        let usernameTextField = app.textFields["Username"]
        usernameTextField.tap()
        usernameTextField.typeText(eVisionUsername)

        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(eVisionPassword)
        app.typeText("\r")
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
        return otherElements["Friday"].exists
    }
}
