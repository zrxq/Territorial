//
//  TrackingViewController.swift
//  Territorial
//
//  Created by Zoreslav Khimich on 12/27/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import UIKit
import CoreLocation

protocol TrackingViewControllerDelegate: AnyObject {
    func geofenceTrackerDidRequestEditor(_ controller:TrackingViewController)
}

final class TrackingViewController: UIViewController {
    
    weak var delegate: TrackingViewControllerDelegate?
    
    private(set) var trackView = TrackingView(frame: .zero)
    
    var geofence: Geofence? {
        didSet {
            if geofence != oldValue {
                tracker.stopTracking()
                updateDescription()
                if let geofence = geofence {
                    tracker.startTracking(geofence)
                }
            }
        }
    }
    
    private let tracker: GeofenceTracker
    
    init(_ tracker: GeofenceTracker) {
        self.tracker = tracker
        super.init(nibName: nil, bundle: nil)
        tracker.delegate = self
    }
    
    override func loadView() {
        view = trackView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup "edit geofence" action.
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(editGeofence))
        trackView.geofenceDescriptionLabel.addGestureRecognizer(tapRecognizer)
        trackView.geofenceDescriptionLabel.isUserInteractionEnabled = true
        trackView.geofenceEditButton.addTarget(self, action: #selector(editGeofence), for: .touchUpInside)
        if let geofence = geofence {
            tracker.startTracking(geofence)
        }

    }
    
    
    @objc private func editGeofence() {
        delegate?.geofenceTrackerDidRequestEditor(self)
    }
    
    private let geocoder = CLGeocoder()
    
    func updateDescription() {
        guard let geofence = geofence else {
            trackView.geofenceDescriptionLabel.text = nil
            return
        }
        self.trackView.geofenceDescriptionLabel.text = geofence.description(using: nil)
        geocoder.reverseGeocodeLocation(CLLocation(latitude: geofence.center.latitude, longitude: geofence.center.longitude)) { (placemarks, error) in
            guard let aPlacemark = placemarks?.first else { return }
            self.trackView.geofenceDescriptionLabel.text = geofence.description(using: aPlacemark)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported.")
    }
}

extension TrackingViewController: GeofenceTrackerDelegate {
    func updateView(to state: TrackingView.State) {
        UIView.animate(withDuration: 0.5) {
            self.trackView.transition(to: state)
        }
    }
    
    func geofenceTracker(_ tracker: GeofenceTracker, didTransitionFromState oldState: GeofenceTracker.State, toState state: GeofenceTracker.State, withGeofence geofence: Geofence) {
        switch state {
            
        case .stopped, .pendingLocation, .pendingWireless:
            updateView(to: .unknown)
            
        case .anchored, .inside:
            updateView(to: .inside)
            
        case .outside:
            updateView(to: .outside)
            
        }
    }
}
