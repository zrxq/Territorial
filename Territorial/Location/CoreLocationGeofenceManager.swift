//
//  CoreLocationGeofenceManager.swift
//  Territorial
//
//  Created by Zoreslav Khimich on 12/27/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import CoreLocation

class CoreLocationGeofenceManager: NSObject, GeofenceManager {
    
    weak var delegate: GeofenceManagerDelegate?
    
    var authorizationStatus: CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

}

extension CoreLocationGeofenceManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        delegate?.geofenceManager(self, didChangeAuthorizationStatus: status)
    }
}
