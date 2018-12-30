//
//  Geofence.swift
//  Territorial
//
//  Created by Zoreslav Khimich on 12/28/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import CoreLocation

struct Geofence: Codable, CustomDebugStringConvertible, Equatable {
    let center: CLLocationCoordinate2D
    let radius: CLLocationDistance
    let ssid: String
    
    init(center: CLLocationCoordinate2D, radius: CLLocationDistance, ssid: String) {
        self.center = center
        self.radius = radius
        self.ssid = ssid
    }
    
    var debugDescription: String {
        return "Geofence \(center.latitude), \(center.longitude) - \(radius), \"\(ssid)\""
    }
    
    func contains(_ location: CLLocation) -> Bool {
        let centerLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
        return location.distance(from: centerLocation) <= radius
    }

}
