//
//  GeofencePropertySheetController.swift
//  Territorial
//
//  Created by Zoreslav Khimich on 12/28/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import UIKit
import CoreLocation

protocol GeofencePropertySheetControllerDelegate: AnyObject {
    func geofenceSheetController(_ controller: GeofencePropertySheetController, didUpdateRadius radius: CLLocationDistance)
}

class GeofencePropertySheetController: UIViewController {
    
    weak var delegate: GeofencePropertySheetControllerDelegate?
    
    var radius: CLLocationDistance
    var ssid: String?
    
    private var sheet: GeofencePropertySheet!
    
    init(radius: CLLocationDistance, ssid: String) {
        self.radius = radius
        self.ssid = ssid
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        sheet = GeofencePropertySheet()
        sheet.translatesAutoresizingMaskIntoConstraints = false 
        view = sheet
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        guard let superView = view.superview else { return }
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: superView.leftAnchor),
            view.topAnchor.constraint(equalTo: superView.topAnchor),
            view.rightAnchor.constraint(equalTo: superView.rightAnchor),
            ])
    }
    
    override func viewDidLoad() {        
        
        let distanceController = DistanceFieldController()
        distanceController.textField = sheet.radiusField
        distanceController.minValue = MinimumGeofenceRadius
        distanceController.value = radius
        distanceController.onChange = { [unowned self] radius in
            if let radius = radius {
                self.update(radius: radius)
            }
        }
        install(distanceController)
        
        let ssidController = SSIDFieldController()
        ssidController.textField = sheet.ssidField
        ssidController.value = ssid
        ssidController.onChange = { [unowned self] ssid in
            self.ssid = ssid
        }
        install(ssidController)

        let cancellingTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        sheet.addGestureRecognizer(cancellingTapRecognizer)
        
    }
    
    @objc private func endEditing() {
        view.endEditing(false)
    }
    
    private func update(radius: CLLocationDistance) {
        self.radius = radius
        delegate?.geofenceSheetController(self, didUpdateRadius: radius)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported.")
    }
}
