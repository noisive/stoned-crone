//
//  WingItUITests.swift
//  WingItUITests
//
//  Created by William Warren on 10/6/17.
//  Copyright © 2017 Noisive. All rights reserved.
//

import XCTest
import Foundation //env variables

extension XCUIApplication {
    var isDisplayingDay: Bool {
        return otherElements["Monday"].exists
    }
}

class WingItUITests: XCTestCase {

    var app: XCUIApplication! = XCUIApplication()


    var eVisionUsername: String = ""
    var eVisionPassword: String = ""

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        guard let eVisionUsername = ProcessInfo.processInfo.environment["EVISIONUSER"] else {
            let eVisionUsername = ""
            return
        }

        guard let eVisionPassword = ProcessInfo.processInfo.environment["EVISIONPW"] else {
            let eVisionPassword = ""
            return
        }
        self.eVisionUsername = eVisionUsername
        self.eVisionPassword = eVisionPassword
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
        app.launch()

        let dayviewElement = app/*@START_MENU_TOKEN@*/.otherElements["dayView"]/*[[".otherElements[\"day\"]",".otherElements[\"dayView\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        dayviewElement/*@START_MENU_TOKEN@*/.press(forDuration: 0.7);/*[[".tap()",".press(forDuration: 0.7);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        dayviewElement.tap()
        dayviewElement.tap()
        dayviewElement.swipeRight()
        dayviewElement.tap()
        
        let thursdayNavigationBar = app.navigationBars["Thursday"]
        thursdayNavigationBar.tap()
        
        let staticText = thursdayNavigationBar.staticTexts["05/10"]
        staticText.tap()
        staticText.tap()
        staticText.tap()
        dayviewElement.swipeLeft()
        thursdayNavigationBar.tap()
        
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
    
    func testLoginFresh(){
        app.launchArguments.append("--resetdata")
        app.launch()
        
        
        let usernameTextField = app.textFields["Username"]
        usernameTextField.tap()
        usernameTextField.typeText(eVisionUsername)
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(eVisionPassword)
        app.typeText("\r")
        XCUIApplication().navigationBars["Log in to eVision"].buttons["Cancel"].tap()
        
        XCTAssertTrue(app.isDisplayingDay)
        
    }
    
    func testLoginUpdate(){
        testLoginFresh()
        app.launch()
        app.navigationBars["Friday"].children(matching: .button).element.tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Update / Log in"]/*[[".cells.staticTexts[\"Update \/ Log in\"]",".staticTexts[\"Update \/ Log in\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let usernameTextField = app.textFields["Username"]
        usernameTextField.tap()
        usernameTextField.typeText(eVisionUsername)
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(eVisionPassword)
        app.typeText("\r")
        
        XCTAssertTrue(app.isDisplayingDay)
        
    }
    
}
