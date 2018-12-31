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
    
    func contains(_ location: CLLocation) -> Bool {
        let centerLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
        return location.distance(from: centerLocation) <= radius
    }
    
    private static let radiusFormatter: LengthFormatter = {
        let f = LengthFormatter()
        f.unitStyle = .long
        return f
    }()

    var debugDescription: String {
        return "Geofence \(center.latitude), \(center.longitude) - \(radius), \"\(ssid)\""
    }
    
    func description(using placemark: CLPlacemark?) -> String {
        let placeDescription: String
        if let placemark = placemark {
            let name = placemark.name
            var subLocality = placemark.subLocality
            if let name = name, let unwrappedSubLocality = subLocality {
                if name.contains(unwrappedSubLocality) {
                    // Avoid repetitions (e.g. 1 Oak street, Oak street, ...)
                    subLocality = nil
                }
            }
            let components = [name, subLocality, placemark.locality, placemark.administrativeArea, placemark.country].compactMap { $0 }
            placeDescription = components.joined(separator: ", ")
        } else {
            placeDescription = String(format: "(%.5f, %.5f)", center.latitude, center.longitude)
        }
        let radiusDescription = Geofence.radiusFormatter.string(fromMeters: radius)
        return String(format: NSLocalizedString("Geofence area is %@ around %@, using reference WiFi \"%@\".", comment: "Geofence description formatting string."), radiusDescription, placeDescription, ssid)
    }

}
