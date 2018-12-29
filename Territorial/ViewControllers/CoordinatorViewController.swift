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
        case locationNeedsAuth
        case locationRestricted
        case needsConfiguring
        case tracking
    }
    
    fileprivate func state(for locationStatus: CLAuthorizationStatus) -> State {
        switch locationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            if geofenceStore.geofences?.first != nil {
                return .tracking
            } else {
                return .needsConfiguring
            }
        case .notDetermined:
            return .locationNeedsAuth
        case .restricted, .denied:
            return .locationRestricted
        }
    }
    
    private func viewController(for state: State) -> UIViewController {
        switch state {

        case .locationRestricted:
            return PromptViewController(with: LocationRestrictedPrompt())

        case .locationNeedsAuth:
            return PromptViewController(with: LocationAccessPrompt(manager: geofenceManager))
            
        case .needsConfiguring:
            return PromptViewController(with: EmptyStatePrompt(delegate: self))
            
        case .tracking:
            let tracker = GeofenceTrackerViewController(geofenceManager)
            tracker.delegate = self
            return tracker
            
            
        }
    }
    
    private(set) var activeViewController: UIViewController?
    private(set) var state: State!
    private let geofenceManager: GeofenceManager
    private let geofenceStore: GeofenceStore

    init(_ geofenceManager: GeofenceManager, store: GeofenceStore) {
        self.geofenceManager = geofenceManager
        self.geofenceStore = store
        super.init(nibName: nil, bundle: nil)
        
        geofenceManager.delegate = self
        state = actualState()
    }
    
    private func actualState() -> State  {
        return state(for: geofenceManager.authorizationStatus)
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

extension CoordinatorViewController: GeofenceManagerDelegate {
    func geofenceManager(_ manager: GeofenceManager, didChangeAuthorizationStatus newStatus: CLAuthorizationStatus) {
        transition(to: state(for: newStatus))
    }
}

extension CoordinatorViewController: GeofenceTrackerDelegate {
    func geofenceTrackerDidRequestEditor(_ controller: GeofenceTrackerViewController) {
        guard let all = geofenceStore.geofences, let first = all.first else {
            assertionFailure("Tracker should not be visible when there are no geofences defined.")
            return
        }
        present(geofenceEditor(with: first), animated: true, completion: nil)
    }
    
    func geofenceTracker(_ controller: GeofenceTrackerViewController, didRequestEditorForGeofence geofence: Geofence) {
    }
}

extension CoordinatorViewController: GeofenceEditorDelegate {
    func geofenceEditor(_ editor: GeofenceEditorViewController, didEndEditingGeofence geofence: Geofence) {
        editor.dismiss(animated: true, completion: nil)
        geofenceStore.set(geofence: geofence, forIndex: 0)
        transition(to: actualState())
    }
}

extension CoordinatorViewController: EmptyStatePromptDelegate {
    func emptyStatePromptDidRequestGeofenceEditor() {
        let geofence = geofenceManager.defaultGeofence()
        present(geofenceEditor(with: geofence), animated: true, completion: nil)
    }
}
