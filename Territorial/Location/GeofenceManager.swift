//
//  GeofenceManager.swift
//  Territorial
//
//  Created by Zoreslav Khimich on 12/27/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import CoreLocation

protocol GeofenceManagerDelegate: AnyObject {
    func geofenceManager(_ manager: GeofenceManager, didChangeAuthorizationStatus newStatus: CLAuthorizationStatus)
}

protocol GeofenceManager: AnyObject {
    var authorizationStatus: CLAuthorizationStatus { get }
    var delegate: GeofenceManagerDelegate? { get set }
    
    func requestAuthorization()
    func startTracking()
    func stopTracking()
    func defaultGeofence() -> Geofence
}
