//
//  ScriptedGeofenceManager.swift
//  TerritorialUITests
//
//  Created by Zoreslav Khimich on 12/28/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class ScriptedGeofenceManager: AuthorizationManager {
    
    func startTracking() {
    }
    
    func stopTracking() {
    }
    
    func defaultGeofence() -> Geofence {
        return Geofence(center: CLLocationCoordinate2D(latitude: 50.4348, longitude: 30.5168), radius: CLLocationDistance(100), ssid: "=^_^=")
    }
    
    
    var authorizationStatus = CLAuthorizationStatus.notDetermined {
        didSet {
            authorizationDelegate?.authorizationManager(self, didChangeStatus: authorizationStatus)
        }
    }
    
    var authorizationDelegate: AuthorizationManagerDelegate?
    
    var viewController: UIViewController {
        return UIApplication.shared.delegate!.window!!.rootViewController!
    }
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(emulateAccessEnabledThroughSettings), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func emulateAccessEnabledThroughSettings() {
        if authorizationStatus == .denied {
            authorizationStatus = .authorizedWhenInUse
        }
    }
    
    func requestAuthorization() {
        let alert = UIAlertController(title: "Allow the app to access to your location?", message: "This is a mock dialog for UI testing only.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yep", style: .default, handler: { _ in
            self.authorizationStatus = .authorizedWhenInUse
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.authorizationStatus = .denied
        }))
        viewController.present(alert, animated: false, completion: nil)
    }
}
