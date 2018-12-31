//
//  AccuracyPolicy.swift
//  Territorial
//
//  Created by Zoreslav Khimich on 12/31/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import CoreLocation

protocol AccuracyPolity {
    
    typealias Accuracy = (accuracy: CLLocationAccuracy, distanceFilter: CLLocationDistance)
    
    func updateAccuracy(using geofence: Geofence, latestLocation: CLLocation) -> Accuracy
    
}
