//
//  CoordinatorTests.swift
//  TerritorialTests
//
//  Created by Zoreslav Khimich on 12/27/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import Foundation

import XCTest
@testable import Territorial

class CoordinatorTests: XCTestCase {
    
    let geofence = MockGeofenceManager()
    let store = MockGeofenceStore()
    lazy var coordinator = CoordinatorViewController(geofence, store: store)

    func `is`<T>(instance: Any, of kind: T.Type) -> Bool{
        return instance is T;
    }
    
    func prompt<T>(is kind: T.Type) -> Bool {
        guard let promptController = coordinator.activeViewController as? PromptViewController else {
            XCTFail("Expected a prompt, got \(String(describing: coordinator.activeViewController))")
            return false
        }
        return promptController.prompt is T
    }
    
    func testLocationAccessStates() {
        // initial state (not yet authorized)

        XCTAssertEqual(coordinator.state, .locationNeedsAuth)
        _ = coordinator.view // force load view
        XCTAssert(prompt(is: LocationAccessPrompt.self))
        
        // authorization denied
        
        geofence.authorizationStatus = .denied
        XCTAssertEqual(coordinator.state, .locationRestricted)
        XCTAssert(prompt(is: LocationRestrictedPrompt.self))
        
        // device/os restrictions
        
        geofence.authorizationStatus = .restricted
        XCTAssertEqual(coordinator.state, .locationRestricted)
        XCTAssert(prompt(is: LocationRestrictedPrompt.self))

        // access granted
        
        geofence.authorizationStatus = .authorizedAlways
        XCTAssertEqual(coordinator.state, .needsConfiguring)
        XCTAssert(prompt(is: EmptyStatePrompt.self))

        geofence.authorizationStatus = .authorizedWhenInUse
        XCTAssertEqual(coordinator.state, .needsConfiguring)
        XCTAssert(prompt(is: EmptyStatePrompt.self))

    }

}
