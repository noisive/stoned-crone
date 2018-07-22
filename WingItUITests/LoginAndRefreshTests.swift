//
//  WingItUITests.swift
//  LoginAndRefreshTests
//
//  Created by William Warren on 10/6/17.
//  Copyright © 2017 Noisive. All rights reserved.
//

import XCTest
import Foundation //env variables

class LoginAndRefreshTests: WingItUITestsSuper {
    
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
        self.eVisionUsername = setUserFromEnv()
        self.eVisionPassword = setPassFromEnv()
    }
    
    override func tearDown() {
        super.tearDown()
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
    
    // Special webview window without any coverplate. For debugging webview login.
    func testLoginRaw(){
        // Argument to enter raw
        app.launchArguments.append("-debugLogin")
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
        app.launch()
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
    
    func testLoginUpdate(){
        
        app.launchArguments.append("-fakeData")
        app.launch()
        _ = app.otherElements["dayView"].waitForExistence(timeout: 40)
        app.buttons["Refresh"].tap()
        
        login()
        
        _ = app.otherElements["dayView"].waitForExistence(timeout: 60)
        XCTAssertTrue(app.isDisplayingTT)
        
    }
    
    
    func testDataPersistenceOnRestart(){
        app.launchArguments.append("-fakeData")
        app.launch()
        _ = app.otherElements["dayView"].waitForExistence(timeout: 60)
        XCTAssertTrue(app.isDisplayingTT)
        
    }
    
    func testCancelButtonNotPresentFresh(){
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
    
    func testCancelButtonExistsOnRefresh(){
        app.launchArguments.append("-fakeData")
        app.launch()
        _ = app.otherElements["dayView"].waitForExistence(timeout: 40)
        app.buttons["Refresh"].tap()
        XCTAssertTrue(cancelButtonExists())
    }
    
    func cancelButtonExists()->Bool{
        return app.buttons["cancel"].exists
    }
    
}