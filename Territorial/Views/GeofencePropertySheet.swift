//
//  GeofencePropertySheet.swift
//  Territorial
//
//  Created by Zoreslav Khimich on 12/28/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import UIKit

class GeofencePropertySheet: UIView {
    
    let radiusLabel = UILabel()
    let radiusField = InputField()
    let radiusUnitLabel = UILabel()
    let ssidLabel = UILabel()
    let ssidField = InputField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .background
        layoutMargins = .panelMargins
        
        let margins = self.layoutMarginsGuide
        
        radiusLabel.text = NSLocalizedString("Radius ", comment: "Geofence editor radius field label.")
        radiusLabel.textColor = .fieldLabel
        radiusLabel.font = .formLabel
        radiusLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(radiusLabel)
        NSLayoutConstraint.activate([
            radiusLabel.topAnchor.constraint(equalTo: margins.topAnchor),
            radiusLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            ])
        
        radiusField.placeholder = NSLocalizedString("300", comment: "Geofence editor radius field placeholder.")
        radiusField.textAlignment = .right
        radiusField.keyboardType = .numbersAndPunctuation
        radiusField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(radiusField)
        
        radiusUnitLabel.text = NSLocalizedString("m", comment: "Geofence editor radius field unit (metres) label.")
        radiusUnitLabel.textColor = .fieldLabel
        radiusUnitLabel.font = .formLabel
        radiusUnitLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(radiusUnitLabel)
        
        ssidLabel.text = NSLocalizedString("Wi-Fi ", comment: "Geofence editor Wi-Fi SSID field label.")
        ssidLabel.textColor = .fieldLabel
        ssidLabel.font = .formLabel
        ssidLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ssidLabel)

        ssidField.placeholder = NSLocalizedString("Wi-Fi SSID", comment: "Geofence editor Wi-Fi SSID field placeholder.")
        ssidField.enablesReturnKeyAutomatically = true
        ssidField.translatesAutoresizingMaskIntoConstraints = false
        ssidField.setContentHuggingPriority(.init(100), for: .horizontal)
        addSubview(ssidField)
        
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[radiusLabel][radiusField(66)][radiusUnitLabel]-16-[ssidLabel][ssidField]-|", options: [.alignAllTop, .alignAllBottom], metrics: nil, views: ["radiusLabel": radiusLabel, "radiusField": radiusField, "radiusUnitLabel" : radiusUnitLabel, "ssidLabel": ssidLabel, "ssidField": ssidField])
        NSLayoutConstraint.activate(constraints)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported.")
    }
}
