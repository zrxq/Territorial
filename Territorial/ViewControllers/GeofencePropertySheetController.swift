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
    var ssid: String {
        return sheet.ssidField.text ?? ""
    }
    
    private var sheet: GeofencePropertySheet!
    private var initialRadius: CLLocationDistance
    private var initialSSID: String
    
    init(radius: CLLocationDistance, ssid: String) {
        initialRadius = radius
        self.radius = initialRadius
        initialSSID = ssid
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
        sheet.ssidField.text = initialSSID
        sheet.ssidField.delegate = self
        
        let distanceController = DistanceFieldController()
        distanceController.textField = sheet.radiusField
        distanceController.minValue = MinimumGeofenceRadius
        distanceController.value = initialRadius
        distanceController.onChange = { [unowned self] radius in
            if let radius = radius {
                self.update(radius: radius)
            }
        }
        install(distanceController)

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

extension GeofencePropertySheetController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
