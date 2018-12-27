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
    lazy var coordinator = CoordinatorViewController(geofence)
    
    func testLocationAccessStates() {

        // initial state (not yet authorized)

        XCTAssertEqual(coordinator.state, .locationNeedsAuth)
        _ = coordinator.view // force load view
        XCTAssert(coordinator.activeViewController is LocationAuthorizationRequestViewController)
        
        // authorization denied
        
        geofence.authorizationStatus = .denied
        XCTAssertEqual(coordinator.state, .locationRestricted)
        XCTAssert(coordinator.activeViewController is LocationRestrictedInfoViewController)
        
        // device/os restrictions
        
        geofence.authorizationStatus = .restricted
        XCTAssertEqual(coordinator.state, .locationRestricted)
        XCTAssert(coordinator.activeViewController is LocationRestrictedInfoViewController)
        
        // access granted
        
        geofence.authorizationStatus = .authorizedAlways
        XCTAssertEqual(coordinator.state, .usable)
        XCTAssert(coordinator.activeViewController is TrackGeofenceViewController)
        
        geofence.authorizationStatus = .authorizedWhenInUse
        XCTAssertEqual(coordinator.state, .usable)
        XCTAssert(coordinator.activeViewController is TrackGeofenceViewController)
        
    }

}
