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
    let to = TimeInterval(5)

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitest")
    }

    func testAuthorizationFlow() {
        app.launch()

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

        // granted, empty state
        XCTAssertTrue(app.buttons["Configure Geofence"].exists)
    }
    
    func testGeofenceEditor() {
        app.launch()
        
        app.buttons["Enable Location"].tap()
        let alert = app.alerts.element
        XCTAssertTrue(alert.waitForExistence(timeout: to))
        alert.buttons["Yep"].tap()
        
        app.buttons["Configure Geofence"].tap()

        // test distance input clamping
        let distanceField = app.textFields["300"]
        distanceField.tap()
        app.typeText("10\n")
        XCTAssertEqual(distanceField.value as? String, "50")
        
        app.navigationBars["Geofence Area"].buttons["Done"].tap()

    }

}
