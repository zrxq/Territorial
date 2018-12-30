//
//  LocationTracker.swift
//  Territorial
//
//  Created by Zoreslav Khimich on 12/30/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import CoreLocation

protocol LocationTrackerDelegate: AnyObject {
    
    func locationTracker(_ tracker: LocationTracker, didUpdateLocation location: CLLocation)
    
}

protocol LocationTracker: AnyObject {
    
    func startTracking(_ geofence: Geofence)
    
    func stopTracking()
    
    var delegate: LocationTrackerDelegate? { get set }
}
