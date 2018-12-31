//
//  MockLocationTracker.swift
//  Territorial
//
//  Created by Zoreslav Khimich on 12/30/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import Foundation
import CoreLocation

class MockLocationTracker: LocationTracker {
    
    var isTracking = false
    
    var location: CLLocation? {
        didSet {
            if let location = location {
                delegate?.locationTracker(self, didUpdateLocation: location)
            }
        }
    }
    
    func push(_ coordinate: CLLocationCoordinate2D) {
        location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    func startTracking(_ geofence: Geofence) {
        assert(isTracking == false)
        isTracking = true
        if let location = location {
            delegate?.locationTracker(self, didUpdateLocation: location)
        }
    }
    
    func stopTracking() {
        assert(isTracking)
        isTracking = false
    }
    
    var delegate: LocationTrackerDelegate?
}
