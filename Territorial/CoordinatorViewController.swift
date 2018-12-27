//
//  CoordinatorViewController.swift
//  Territorial
//
//  Created by Zoreslav Khimich on 12/27/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import UIKit
import CoreLocation

final class CoordinatorViewController: UIViewController {
    
    let geofence: GeofenceManager
    
    enum State {
        case locationNeedsAuth
        case locationRestricted
        case usable
    }
    
    fileprivate static func state(for locationStatus: CLAuthorizationStatus) -> State {
        switch locationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            return .usable
        case .notDetermined:
            return .locationNeedsAuth
        case .restricted, .denied:
            return .locationRestricted
        }
    }
    
    private func viewController(for state: State) -> UIViewController {
        switch state {

        case .locationRestricted:
            return LocationRestrictedInfoViewController()

        case .locationNeedsAuth:
            return LocationAuthorizationRequestViewController(geofence)
            
        case .usable:
            return TrackGeofenceViewController()
            
        }
    }
    
    private(set) var activeViewController: UIViewController?
    private(set) var state: State

    init(_ geofenceManager: GeofenceManager) {
        geofence = geofenceManager
        state = CoordinatorViewController.state(for: geofence.authorizationStatus)
        super.init(nibName: nil, bundle: nil)
        
        geofence.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transition(to: state)
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return activeViewController
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported.")
    }
    
    fileprivate func transition(to state: State) {
        activeViewController?.willMove(toParent: nil)
        activeViewController?.removeFromParent()
        activeViewController?.view.removeFromSuperview()
        activeViewController = viewController(for: state)
        guard let activeViewController = activeViewController else {
            fatalError("Failed to initialize view controller for \(state) state.")
        }
        addChild(activeViewController)
        view.addSubview(activeViewController.view)
        activeViewController.didMove(toParent: self)
        self.state = state
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
}

extension CoordinatorViewController: GeofenceManagerDelegate {
    func geofenceManager(_ manager: GeofenceManager, didChangeAuthorizationStatus newStatus: CLAuthorizationStatus) {
        transition(to: CoordinatorViewController.state(for: newStatus))
    }
}
