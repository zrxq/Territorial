//
//  FairlyGreedyAccuracy.swift
//  Territorial
//
//  Created by Zoreslav Khimich on 12/31/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import CoreLocation

final class FairlyGreedyAccuracyPolicy: AccuracyPolity {
    func updateAccuracy(using geofence: Geofence, latestLocation: CLLocation) -> FairlyGreedyAccuracyPolicy.Accuracy {
        let threshDistance = geofence.distanceFromThreshold(to: latestLocation)
        return (threshDistance, threshDistance / 4)
    }
}
