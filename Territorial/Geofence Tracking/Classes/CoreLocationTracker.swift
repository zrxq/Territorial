//
//  CoreLocationTracker.swift
//  Territorial
//
//  Created by Zoreslav Khimich on 12/27/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import CoreLocation
import SystemConfiguration.CaptiveNetwork

let MinimumGeofenceRadius = CLLocationDistance(50)

class CoreLocationTracker: NSObject, AuthorizationManager {
    
    weak var authorizationDelegate: AuthorizationManagerDelegate?
    weak var delegate: LocationTrackerDelegate?
    
    var authorizationStatus: CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    private let locationManager = CLLocationManager()
    private var lastLoc: CLLocation?
    
    var geofence: Geofence?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func defaultGeofence() -> Geofence {
        let loc: CLLocation
        if let lastLoc = lastLoc {
            loc = lastLoc
        } else {
            // actual location not yet available, make up one
            loc = CLLocation(latitude: 37.331860673139786, longitude: -122.02959426386774)
        }
        return Geofence(center: loc.coordinate, radius: CLLocationDistance(100), ssid: SystemWirelessMonitor.ssid ?? "My Hotspot")
    }
}

extension CoreLocationTracker: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            // Request a location update as soon as possible to have
            // something cached by the time it's actually needed.
            // see defaultGeofence()
            locationManager.requestLocation()
        }
        authorizationDelegate?.authorizationManager(self, didChangeStatus: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        lastLoc = loc
        delegate?.locationTracker(self, didUpdateLocation: loc)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        fatalError("Error: \(error)")
    }
}

extension CoreLocationTracker: LocationTracker {
    func startTracking(_ geofence: Geofence) {
        locationManager.startUpdatingLocation()
    }
    
    func stopTracking() {
        locationManager.stopUpdatingLocation()
    }
}
