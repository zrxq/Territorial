//
//  GeofenceTracker.swift
//  Territorial
//
//  Created by Zoreslav Khimich on 12/30/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import Foundation
import CoreLocation

protocol GeofenceTrackerDelegate: AnyObject {
    
    func geofenceTracker(_ tracker: GeofenceTracker, didTransitionFromState oldState: GeofenceTracker.State, toState state: GeofenceTracker.State, withGeofence geofence: Geofence)
    
}

final class GeofenceTracker {

    weak var delegate: GeofenceTrackerDelegate?
    
    private let wireless: WirelessMonitor
    private let locationTracker: LocationTracker
    
    init(locationTracker: LocationTracker, wirelessMonitor: WirelessMonitor) {
        
        self.locationTracker = locationTracker
        wireless = wirelessMonitor
        
        assert(locationTracker.delegate == nil)
        locationTracker.delegate = self
        
        assert(wireless.delegate == nil)
        wireless.delegate = self
        
    }
    
    enum State {
        /// Not yet started.
        case stopped
        
        /// Started, waiting for WiFi SSID data.
        case pendingWireless
        
        /// Started, waiting for geolocation data.
        case pendingLocation
        
        /// Matching wireless interface detected. Considered inside.
        case anchored
        
        /// The device is reported to be inside the geofence area.
        case inside
        
        /// The device is reported to be outside of the geofence area.
        case outside
    }
    
    private(set) var state = State.stopped {
        didSet {
            if oldValue != state {
                delegate?.geofenceTracker(self, didTransitionFromState: oldValue, toState: state, withGeofence: geofence)
            }
        }
    }
    
    private var geofence: Geofence!
    
    func startTracking(_ geofence: Geofence) {
        assert(state == .stopped)
        self.geofence = geofence
        state = .pendingWireless
        wireless.startMonitoring()
    }

    private func update(ssid: String?) {
        
        if ssid == geofence.ssid {
            
            // WiFi SSID matches,
            switch state {
                
            // ...stop location tracking, if started
            case .inside, .outside, .pendingLocation:
                locationTracker.stopTracking()
                fallthrough
                
            // ...and update the state.
            case .pendingWireless:
                state = .anchored
                
            // Do nothing otherwise.
            case .anchored, .stopped:
                break
                
            }
        } else {
            
            // WiFi SSID doesn't match,
            switch state {
                
            // ...start location tracking, if not yet started.
            case .anchored, .pendingWireless:
                state = .pendingLocation
                locationTracker.startTracking(geofence)
            
            // Do nothing otherwise.
            case .inside, .outside, .pendingLocation, .stopped:
                break
                
            }
        }
        
    }
    
    private func update(location: CLLocation) {
        
        switch state {
        
        // If location is being tracked, update the state accordingly to the new location.
        case .inside, .outside, .pendingLocation:
            state = geofence.contains(location) ? .inside : .outside
            
        // ...otherwise, do nothing.
        case .stopped, .pendingWireless, .anchored:
            break
            
        }
        
    }
    
    func stopTracking() {
        locationTracker.stopTracking()
        wireless.stopMonitoring()
        state = .stopped
        geofence = nil
    }
}

extension GeofenceTracker: WirelessMonitorDelegate {
    func wirelessMonitor(_ monitor: WirelessMonitor, didUpdateSSID ssid: String?) {
        assert(monitor === wireless)
        update(ssid: ssid)
    }
}

extension GeofenceTracker: LocationTrackerDelegate {
    func locationTracker(_ tracker: LocationTracker, didUpdateLocation location: CLLocation) {
        assert(tracker === locationTracker)
        update(location: location)
    }
}
