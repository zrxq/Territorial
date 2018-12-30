//
//  MockGeofenceManager.swift
//  TerritorialTests
//
//  Created by Zoreslav Khimich on 12/27/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import CoreLocation
@testable import Territorial

class MockGeofenceManager: NSObject, AuthorizationManager {
    func startTracking() {
    }
    
    func stopTracking() {
    }
    
    func defaultGeofence() -> Geofence {
        return Geofence(center: CLLocationCoordinate2D(latitude: 50.4348, longitude: 30.5168), radius: CLLocationDistance(100), ssid: "=^_^=")
    }
    
    var authorizationStatus = CLAuthorizationStatus.notDetermined {
        didSet {
            authorizationDelegate?.geofenceManager(self, didChangeAuthorizationStatus: authorizationStatus)
        }
    }
    
    var authorizationDelegate: AuthorizationManagerDelegate?
    
    func requestAuthorization() {
    }
    
}
