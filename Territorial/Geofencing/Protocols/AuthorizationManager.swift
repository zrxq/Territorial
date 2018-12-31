//
//  AuthorizationManager.swift
//  Territorial
//
//  Created by Zoreslav Khimich on 12/27/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import CoreLocation

protocol AuthorizationManagerDelegate: AnyObject {
    func authorizationManager(_ manager: AuthorizationManager, didChangeStatus newStatus: CLAuthorizationStatus)
}

protocol AuthorizationManager: AnyObject {
    var authorizationStatus: CLAuthorizationStatus { get }
    var authorizationDelegate: AuthorizationManagerDelegate? { get set }
    
    func requestAuthorization()
    func defaultGeofence() -> Geofence
}
