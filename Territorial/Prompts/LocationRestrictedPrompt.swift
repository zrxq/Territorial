//
//  LocationRestrictedPrompt.swift
//  Territorial
//
//  Created by Zoreslav Khimich on 12/29/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import UIKit

struct LocationRestrictedPrompt: Prompt {
    let picture = UIImage(named: "LocationRestrictedPicture")!
    
    let message = NSLocalizedString("Sadly, this app can't function without Location access. Could you please check Settings and see if it's enabled?", comment: "Location restricted prompt message.")
    
    let buttonTitle = NSLocalizedString("Open Settings", comment: "Location unavailable Open Settings button title.")
    
    func handleButton() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
    }
    
}
