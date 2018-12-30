//
//  GeofenceStore.swift
//  Territorial
//
//  Created by Zoreslav Khimich on 12/28/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import Foundation

protocol GeofenceStore {
    var geofences: [Geofence]? { get }
    func set(geofence: Geofence, forIndex index: Int)
}
