//
//  LocationAuthorizationRequestViewController.swift
//  Territorial
//
//  Created by Zoreslav Khimich on 12/27/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import UIKit

class LocationAuthorizationRequestViewController: UIViewController {
    
    let geofence: GeofenceManager
    
    init(_ geofenceManager: GeofenceManager) {
        geofence = geofenceManager
        super.init(nibName: nil, bundle: nil)
    }
    
    @objc func requestAuthorization() {
        geofence.requestAuthorization()
    }
    
    override func loadView() {
        super.loadView()
        let contentView = makePromptView()
        view.addSubview(contentView)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func makePromptView() -> UIView {
        
        let promptView = PromptView(frame: view.frame)

        promptView.picture.image = UIImage(named: "LocationPromptPicture")
        
        promptView.message.text = NSLocalizedString("This app needs to know your location to do its thing. The location data will never leave your device, we promise 🤞", comment: "Location Services authorization prompt message.")
        promptView.button.setTitle(NSLocalizedString("Enable Location", comment: "Location Services athorization prompt action button title."), for: .normal)
        promptView.button.addTarget(self, action: #selector(requestAuthorization), for: .touchUpInside)
        
        return promptView
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported")
    }
    
}
