//
//  GeofenceTrackerViewController.swift
//  Territorial
//
//  Created by Zoreslav Khimich on 12/27/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import UIKit

protocol GeofenceTrackerViewControllerDelegate: AnyObject {
    func geofenceTrackerDidRequestEditor(_ controller:GeofenceTrackerViewController)
}

final class GeofenceTrackerViewController: UIViewController {
    
    weak var delegate: GeofenceTrackerViewControllerDelegate?
    
    private var geofence: Geofence?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        let editButton = UIButton(type: .system)
        editButton.setTitle("Edit", for: .normal)
        editButton.frame = CGRect(x: 10, y: 44, width: 66, height: 18)
        editButton.addTarget(self, action: #selector(editGeofence), for: .touchUpInside)
        view.addSubview(editButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @objc private func editGeofence() {
        delegate?.geofenceTrackerDidRequestEditor(self)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported.")
    }
}
