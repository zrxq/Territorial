//
//  DefaultsGeofenceStore.swift
//  Territorial
//
//  Created by Zoreslav Khimich on 12/29/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import Foundation

final class DefaultsGeofenceStore: GeofenceStore {
    private static let geofencesDefaultsKey = "com.zrslv.terri.geofences"
    
    var geofences: [Geofence]? {
        let defaults = UserDefaults.standard
        guard let data = defaults.data(forKey: DefaultsGeofenceStore.geofencesDefaultsKey) else { return nil }
        let decoder = PropertyListDecoder()
        guard let geofences = try? decoder.decode([Geofence].self, from: data) else { return nil }
        return geofences
    }
    
    func set(geofence: Geofence, forIndex index: Int) {
        var geofences = [Geofence](self.geofences ?? [])
        if index == geofences.count {
            geofences.append(geofence)
        } else {
            geofences[index] = geofence
        }
        let encoder = PropertyListEncoder()
        let data = try? encoder.encode(geofences)
        
        // If the serialization fails, it's marginally better
        // to not delete the previously stored geofences by
        // setting the key value to nil.
        if let data = data {
            UserDefaults.standard.set(data, forKey: DefaultsGeofenceStore.geofencesDefaultsKey)
        } else {
            assertionFailure("Geofence list serialization failure.")
        }
    }
}
