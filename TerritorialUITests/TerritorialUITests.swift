//
//  TerritorialUITests.swift
//  TerritorialUITests
//
//  Created by Zoreslav Khimich on 12/27/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import XCTest

class TerritorialUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    let alertExpectation = XCTestExpectation(description: "Location Access alert appeared")

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitest")
        app.launch()
    }
    
    func testAuthorizationFlow() {
        let to = TimeInterval(5)
        
        // initial state
        app.buttons["Enable Location"].tap()
        let alert = app.alerts.element
        XCTAssertTrue(alert.waitForExistence(timeout: to))
        alert.buttons["Cancel"].tap()
        
        // denied
        app.buttons["Open Settings"].tap()
        XCTAssertTrue(app.wait(for: .runningBackground, timeout: to))
        app.activate()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: to))

        // granted
        XCTAssertFalse(app.buttons["Open Settings"].exists)
        // TODO

    }

}
