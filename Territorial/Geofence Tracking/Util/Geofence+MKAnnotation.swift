//
//  Geofence+MKAnnotation.swift
//  Territorial
//
//  Created by Zoreslav Khimich on 12/28/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import MapKit

class GeofenceAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
        didSet {
            onAreaChanged?(self)
        }
    }
    
    var radius: CLLocationDistance {
        didSet {
            onAreaChanged?(self)
        }
    }
    
    var ssid: String
    
    var title: String? {
        return ssid
    }
    
    typealias AreaChangeHandler = (GeofenceAnnotation) -> ()
    var onAreaChanged: AreaChangeHandler?
    
    init(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, ssid: String) {
        self.coordinate = coordinate
        self.radius = radius
        self.ssid = ssid
    }
    
    func geofence() -> Geofence {
        return Geofence(center: coordinate, radius: radius, ssid: ssid)
    }
}

extension Geofence  {
    func annotation() -> GeofenceAnnotation {
        return GeofenceAnnotation(coordinate: center, radius: radius, ssid: ssid)
    }
}
