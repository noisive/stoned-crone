//
//  WingItUITests.swift
//  WingItUITests
//
//  Created by William Warren on 10/6/17.
//  Copyright © 2017 Noisive. All rights reserved.
//

import XCTest

class WingItUITests: XCTestCase {
    
    var app: XCUIApplication! = XCUIApplication()
    
    let eVisionUsername = "warwi639"
    let eVisionPassword = "WingItDemo"
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
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
    
    
    
    func testLoginFresh(){
        // Argument to delete data
        app.launchArguments.append("--uitesting")
        app.launch()
        
 
        let usernameTextField = app.textFields["Username"]
        usernameTextField.tap()
        usernameTextField.typeText(eVisionUsername)
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText(eVisionPassword)
        app.typeText("\r")
        
    }
    
    func testLoginUpdate(){
        // Argument to delete data
        app.launchArguments.append("--uitesting")
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
        
        app.staticTexts["Enter your eVision details"]
        
        
    }
    
}
