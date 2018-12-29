//
//  MockGeofenceStore.swift
//  TerritorialTests
//
//  Created by Zoreslav Khimich on 12/29/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import Foundation

final class MockGeofenceStore: GeofenceStore {
    
    var geofences: [Geofence]? = [Geofence]()
    
    func set(geofence: Geofence, forIndex index: Int) {
        var geofences = self.geofences ?? []
        if index == geofences.count {
            geofences.append(geofence)
        } else {
            geofences[index] = geofence
        }
    }
}
