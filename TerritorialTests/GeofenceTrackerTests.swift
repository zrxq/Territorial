//
//  GeofenceTrackerTests.swift
//  TerritorialTests
//
//  Created by Zoreslav Khimich on 12/30/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import Foundation

import Foundation

import XCTest
import CoreLocation
@testable import Territorial

class GeofenceTrackerTests: XCTestCase {
    let location = MockLocationTracker()
    let wireless = MockWirelessMonitor()
    
    lazy var tracker = GeofenceTracker(locationTracker: location, wirelessMonitor: wireless)
    
    let geofence = Geofence(center: CLLocationCoordinate2D(latitude: 50.440949, longitude: 30.515048), radius: 100, ssid: "Squat Cafe")
    let outsideLoc = CLLocationCoordinate2D(latitude: 50.440397, longitude: 30.510768)
    let insideLoc = CLLocationCoordinate2D(latitude: 50.441346, longitude: 30.515609)
    
    func testWireless() {
        wireless.ssid = "Home"
        location.location = nil
        
        XCTAssertEqual(tracker.state, .stopped)
        XCTAssertFalse(wireless.isMonitoring)
        
        tracker.startTracking(geofence)
        XCTAssertEqual(tracker.state, .pendingLocation)
        XCTAssertTrue(wireless.isMonitoring)
        XCTAssertTrue(location.isTracking)

        wireless.ssid = "Squat Cafe"
        XCTAssertEqual(tracker.state, .anchored)
        XCTAssertTrue(wireless.isMonitoring)
        XCTAssertFalse(location.isTracking)

        wireless.ssid = nil
        XCTAssertEqual(tracker.state, .pendingLocation)
        XCTAssertTrue(wireless.isMonitoring)
        XCTAssertTrue(location.isTracking)

        wireless.ssid = "Park"
        XCTAssertEqual(tracker.state, .pendingLocation)
        XCTAssertTrue(wireless.isMonitoring)
        XCTAssertTrue(location.isTracking)

        tracker.stopTracking()
        XCTAssertEqual(tracker.state, .stopped)
        XCTAssertFalse(wireless.isMonitoring)
        XCTAssertFalse(location.isTracking)
    }
    
    func testLocation() {
        wireless.ssid = nil
        location.location = nil
        
        XCTAssertEqual(tracker.state, .stopped)
        
        tracker.startTracking(geofence)
        
        location.push(outsideLoc)
        XCTAssertEqual(tracker.state, .outside)
        
        location.push(insideLoc)
        XCTAssertEqual(tracker.state, .inside)
        
        tracker.stopTracking()
        XCTAssertEqual(tracker.state, .stopped)
        XCTAssertFalse(wireless.isMonitoring)
        XCTAssertFalse(location.isTracking)
    }
    
    func testWirelessPriorityOverLocation() {
        wireless.ssid = nil
        location.location = nil
        
        XCTAssertEqual(tracker.state, .stopped)
        
        tracker.startTracking(geofence)
        
        location.push(outsideLoc)
        XCTAssertEqual(tracker.state, .outside)

        wireless.ssid = "Squat Cafe"
        XCTAssertEqual(tracker.state, .anchored)
        XCTAssertFalse(location.isTracking)

        location.push(insideLoc)
        XCTAssertEqual(tracker.state, .anchored)
        
        wireless.ssid = "Park"
        XCTAssertEqual(tracker.state, .inside)
        XCTAssertTrue(location.isTracking)

        location.stopTracking()
    }
    
}
