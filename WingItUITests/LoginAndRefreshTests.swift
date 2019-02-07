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
    
    func login(realData: Bool = false){
        
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
        if realData {
            usernameTextField.typeText(self.eVisionUsername)
        }else{
            usernameTextField.typeText("WingItDemo")
        }
        passwordSecureTextField.tap()
        if realData {
            passwordSecureTextField.typeText(self.eVisionPassword)
        }else{
            passwordSecureTextField.typeText("Ilikedevs")
        }
        let rememSwitch = app.switches["Remember Login Button"]
        let isOn = (rememSwitch.value as! String).toBool()!
        if !isOn {
            rememSwitch.tap()
        }
            app.buttons["Login"].tap()
        _ = app.otherElements["dayView"].waitForExistence(timeout: 80)
    }
    
    // Test that a fresh login reaches a timetable.
    func testLoginFresh(){
        app.launch()
        login(realData: true)
        XCTAssertTrue(app.isDisplayingTT)
        
    }
    
    func testLoginUpdate(){
        app.launchArguments.append("-fakeLogin")
        app.launch()
        login()
        app.buttons["Refresh"].tap()
        // Should automatically update now
        XCTAssertTrue(app.otherElements["dayView"].waitForExistence(timeout: 20))
        XCTAssertFalse(app.scrollViews["Login View"].exists)
        
    }
    
    func testUpdateNoInternet(){
        app.launchArguments.append("-fakeData")
        app.launchArguments.append("-noReachability")
        app.launch()
        app.buttons["Refresh"].tap()
        let cancelOption = app.alerts["No Internet Connection"].buttons["Cancel"]
        XCTAssertTrue(cancelOption.waitForExistence(timeout: 1))
        cancelOption.tap()
        XCTAssertTrue(app.isDisplayingTT)
        app.buttons["Refresh"].tap()
        let retryButton = app.alerts["No Internet Connection"].buttons["Retry"]
        XCTAssertTrue(retryButton.waitForExistence(timeout: 1))
        retryButton.tap()
        let usernameTextField = app.textFields["Username"]
        XCTAssertFalse(usernameTextField.exists)
        XCTAssertTrue(usernameTextField.waitForExistence(timeout: 30))
    }
    
    func testReturnsToCurrentDayAfterUpdate(){
        app.launchArguments.append("-fakeLogin")
        app.launchArguments += ["-mockDate", "2018-10-05"]
        setUpFakeData()
        app.swipeRight()
        XCTAssertTrue(app.otherElements["Thursday"].exists)
        app.buttons["Refresh"].tap()
        login()
        XCTAssertTrue(app.otherElements["Friday"].exists)
    }
//    
//    func testDataPersistenceOnRestart(){
//        app.launchArguments.append("-fakeData")
//        app.launch()
//        XCTAssertTrue(app.otherElements["dayView"].waitForExistence(timeout: 20))
//        
//    }
    
    func testCancelButtonNotPresentFresh(){
        app.launch()
        XCTAssertFalse(app.buttons["Cancel Button"].exists)
    }
    
    func testCancelButtonExistsOnRefresh(){
        app.launchArguments.append("-fakeData")
        app.launch()
        _ = app.otherElements["dayView"].waitForExistence(timeout: 20)
        app.buttons["Refresh"].tap()
        XCTAssertTrue(app.buttons["Cancel Button"].exists)
        app.buttons["Cancel Button"].tap()
        XCTAssertTrue(app.isDisplayingTT)
    }
    
    
    func testUpdateBannerRefreshesOnTap(){
        app.launchArguments += ["-mockDate", "2018-10-15"]
        setUpFakeData()
        app.otherElements["RMessageView"].tap()
        XCTAssertTrue(app.scrollViews["Login View"].exists)
    }

}
