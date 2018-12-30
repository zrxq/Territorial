//
//  LocationAccessPrompt.swift
//  Territorial
//
//  Created by Zoreslav Khimich on 12/29/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import UIKit

struct LocationAccessPrompt: Prompt {
    
    private let manager: AuthorizationManager
    init(manager: AuthorizationManager) {
        self.manager = manager
    }
    
    var picture = UIImage(named: "LocationPromptPicture")!
    
    var message = NSLocalizedString("This app needs to know your location to do its thing. The location data will never leave your device, we promise 🤞", comment: "Location Services authorization prompt message.")
    
    var buttonTitle = NSLocalizedString("Enable Location", comment: "Location Services athorization prompt action button title.")
    
    func handleButton() {
        manager.requestAuthorization()
    }
}
