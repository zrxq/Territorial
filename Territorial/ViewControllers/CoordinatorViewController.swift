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
    
    enum State {
        case needsAuthorization
        case locationRestricted
        case needsConfiguring
        case tracking
    }
    
    fileprivate func state(for locationStatus: CLAuthorizationStatus) -> State {
        switch locationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            if store.geofences?.first != nil {
                return .tracking
            } else {
                return .needsConfiguring
            }
        case .notDetermined:
            return .needsAuthorization
        case .restricted, .denied:
            return .locationRestricted
        }
    }
    
    private func viewController(for state: State) -> UIViewController {
        switch state {

        case .locationRestricted:
            return PromptViewController(with: LocationRestrictedPrompt())

        case .needsAuthorization:
            return PromptViewController(with: LocationAccessPrompt(manager: authManager))
            
        case .needsConfiguring:
            return PromptViewController(with: EmptyStatePrompt(delegate: self))
            
        case .tracking:
            let trackerViewController = TrackingViewController(GeofenceTracker(locationTracker: tracker, wirelessMonitor: wireless))
            trackerViewController.delegate = self
            trackerViewController.geofence = store.geofences?.first
            return trackerViewController
            
        }
    }
    
    private(set) var activeViewController: UIViewController?
    private(set) var state: State!
    private let authManager: AuthorizationManager
    private let store: GeofenceStore
    private let tracker: LocationTracker
    private let wireless: WirelessMonitor

    init(_ authManager: AuthorizationManager, tracker: LocationTracker, wireless: WirelessMonitor, store: GeofenceStore) {
        self.authManager = authManager
        self.store = store
        self.tracker = tracker
        self.wireless = wireless
        super.init(nibName: nil, bundle: nil)
        
        authManager.authorizationDelegate = self
    }
    
    private func actualState() -> State  {
        return state(for: authManager.authorizationStatus)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return activeViewController
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported.")
    }
    
    fileprivate func transition(to state: State) {
        guard state != self.state else { return }
        activeViewController?.willMove(toParent: nil)
        activeViewController?.removeFromParent()
        activeViewController?.view.removeFromSuperview()
        activeViewController = viewController(for: state)
        guard let activeViewController = activeViewController else {
            fatalError("Failed to initialize view controller for \(state) state.")
        }
        addChild(activeViewController)
        view.addSubview(activeViewController.view)
        activeViewController.view.frame = view.frame
        activeViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        activeViewController.didMove(toParent: self)
        self.state = state
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    fileprivate func geofenceEditor(with geofence: Geofence) -> UIViewController {
        let picker = GeofenceEditorViewController(with: geofence)
        picker.delegate = self
        let nav = UINavigationController(rootViewController: picker)
        let bar = nav.navigationBar
        bar.barStyle = .black
        bar.isTranslucent = false
        bar.barTintColor = .background
        return nav
    }
}

extension CoordinatorViewController: AuthorizationManagerDelegate {
    func authorizationManager(_ manager: AuthorizationManager, didChangeStatus newStatus: CLAuthorizationStatus) {
        transition(to: state(for: newStatus))
    }
}

extension CoordinatorViewController: TrackingViewControllerDelegate {
    func geofenceTrackerDidRequestEditor(_ controller: TrackingViewController) {
        guard let all = store.geofences, let first = all.first else {
            assertionFailure("Tracker should not be visible when there are no geofences defined.")
            return
        }
        present(geofenceEditor(with: first), animated: true, completion: nil)
    }
}

extension CoordinatorViewController: GeofenceEditorDelegate {
    func geofenceEditor(_ editor: GeofenceEditorViewController, didEndEditingGeofence geofence: Geofence) {
        editor.dismiss(animated: true, completion: nil)
        store.set(geofence: geofence, forIndex: 0)
        transition(to: actualState())
        if let trackerController = activeViewController as? TrackingViewController {
            trackerController.geofence = geofence
        }
    }
}

extension CoordinatorViewController: EmptyStatePromptDelegate {
    func emptyStatePromptDidRequestGeofenceEditor() {
        let geofence = authManager.defaultGeofence()
        present(geofenceEditor(with: geofence), animated: true, completion: nil)
    }
}
