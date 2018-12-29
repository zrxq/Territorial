//
//  MockGeofenceManager.swift
//  TerritorialTests
//
//  Created by Zoreslav Khimich on 12/27/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import CoreLocation
@testable import Territorial

class MockGeofenceManager: NSObject, GeofenceManager {
    func startTracking() {
    }
    
    func stopTracking() {
    }
    
    func defaultGeofence() -> Geofence {
        return Geofence(center: CLLocationCoordinate2D(latitude: 50.4348, longitude: 30.5168), radius: CLLocationDistance(100), ssid: "=^_^=")
    }
    
    var authorizationStatus = CLAuthorizationStatus.notDetermined {
        didSet {
            delegate?.geofenceManager(self, didChangeAuthorizationStatus: authorizationStatus)
        }
    }
    
    var delegate: GeofenceManagerDelegate?
    
    func requestAuthorization() {
    }
    
}
