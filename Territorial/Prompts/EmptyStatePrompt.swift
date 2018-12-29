//
//  EmptyStatePrompt.swift
//  Territorial
//
//  Created by Zoreslav Khimich on 12/29/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import UIKit

protocol EmptyStatePromptDelegate: AnyObject {
    func emptyStatePromptDidRequestGeofenceEditor()
}
    
struct EmptyStatePrompt: Prompt {
    
    var picture = UIImage(named: "EmptyStatePicture")!
    
    var message = NSLocalizedString("Now you can configure a geofence area. Geofence area is defined as a combination of a location, radius, and a WiFi network name.", comment: "No configured geofences prompt message.")
    
    var buttonTitle = NSLocalizedString("Configure Geofence", comment: "No configured geofences prompt action button title.")
    
    func handleButton() {
        delegate?.emptyStatePromptDidRequestGeofenceEditor()
    }
    
    private weak var delegate: EmptyStatePromptDelegate?
    
    init(delegate: EmptyStatePromptDelegate) {
        self.delegate = delegate
    }
}
