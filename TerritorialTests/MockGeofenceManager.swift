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
    var authorizationStatus = CLAuthorizationStatus.notDetermined {
        didSet {
            delegate?.geofenceManager(self, didChangeAuthorizationStatus: authorizationStatus)
        }
    }
    
    var delegate: GeofenceManagerDelegate?
    
    func requestAuthorization() {
    }
    
}
