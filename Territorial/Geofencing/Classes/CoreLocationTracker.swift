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
    private let accuracyPolicy: AccuracyPolity
    
    private var latestLocation: CLLocation?
    private var isTracking = false
    
    
    var geofence: Geofence?
    
    init(accuracyPolicy: AccuracyPolity = FairlyGreedyAccuracyPolicy()) {
        self.accuracyPolicy = accuracyPolicy
        super.init()
        locationManager.delegate = self
    }
    
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func defaultGeofence() -> Geofence {
        let loc: CLLocation
        if let lastLoc = latestLocation {
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
        guard let location = locations.last else { return }
        latestLocation = location
        if let geofence = geofence, let latestLocation = latestLocation {
            let (accuracy, distanceFilter) = accuracyPolicy.updateAccuracy(using: geofence, latestLocation: latestLocation)
            locationManager.desiredAccuracy = accuracy
            locationManager.distanceFilter = distanceFilter
        }
        delegate?.locationTracker(self, didUpdateLocation: location)
    }
    
    static let retryInterval = TimeInterval(0.25)
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // TODO: This is, obviously, not a proper way to handle errors. Additional research needed.
        NSLog("Location update failure: \(error)")
        
        manager.stopUpdatingLocation()
        // TODO: exponential backoff, maybe?
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + CoreLocationTracker.retryInterval) {
            if (self.isTracking) {
                manager.startUpdatingLocation()
            } else {
                manager.requestLocation()
            }
        }
    }
}

extension CoreLocationTracker: LocationTracker {
    func startTracking(_ geofence: Geofence) {
        isTracking = true
        self.geofence = geofence
        locationManager.startUpdatingLocation()
    }
    
    func stopTracking() {
        isTracking = false
        geofence = nil
        locationManager.stopUpdatingLocation()
    }
}
