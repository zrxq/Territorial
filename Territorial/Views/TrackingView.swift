//
//  TrackingView.swift
//  Territorial
//
//  Created by Zoreslav Khimich on 12/30/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import UIKit

class TrackingView: UIView {
    
    enum State {
        case unknown
        case outside
        case inside
    }
    
    var state = State.unknown
    
    private let resultLabel = UILabel()
    let geofenceDescriptionLabel = UILabel()
    let geofenceEditButton = SmallRoundedButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .background
        
        layoutMargins = .margins
        let margins = layoutMarginsGuide
        
        let topSpacer = UILayoutGuide()
        let resultBox = UILayoutGuide()
        let geofenceBox = UILayoutGuide()
        let bottomSpacer = UILayoutGuide()
        
        for aGuide in [topSpacer, resultBox, geofenceBox, bottomSpacer] {
            addLayoutGuide(aGuide)
        }

        NSLayoutConstraint.activate([
            topSpacer.topAnchor.constraint(equalTo: margins.topAnchor),
            topSpacer.leftAnchor.constraint(equalTo: margins.leftAnchor),
            topSpacer.rightAnchor.constraint(equalTo: margins.rightAnchor),
            resultBox.topAnchor.constraint(equalTo: topSpacer.bottomAnchor),
            resultBox.leftAnchor.constraint(equalTo: margins.leftAnchor),
            resultBox.rightAnchor.constraint(equalTo: margins.rightAnchor),
            resultBox.heightAnchor.constraint(equalTo: topSpacer.heightAnchor),
            geofenceBox.topAnchor.constraint(equalTo: resultBox.bottomAnchor),
            geofenceBox.leftAnchor.constraint(equalTo: margins.leftAnchor),
            geofenceBox.rightAnchor.constraint(equalTo: margins.rightAnchor),
            geofenceBox.heightAnchor.constraint(equalTo: topSpacer.heightAnchor),
            bottomSpacer.topAnchor.constraint(equalTo: geofenceBox.bottomAnchor),
            bottomSpacer.leftAnchor.constraint(equalTo: margins.leftAnchor),
            bottomSpacer.rightAnchor.constraint(equalTo: margins.rightAnchor),
            bottomSpacer.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            bottomSpacer.heightAnchor.constraint(equalTo: topSpacer.heightAnchor),
            ])
        
        
        resultLabel.font = .result
        resultLabel.textColor = .text
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(resultLabel)
        NSLayoutConstraint.activate([
            resultLabel.centerXAnchor.constraint(equalTo: resultBox.centerXAnchor),
            resultLabel.centerYAnchor.constraint(equalTo: resultBox.centerYAnchor),
            ])
        
        geofenceDescriptionLabel.numberOfLines = 0
        geofenceDescriptionLabel.font = .emphasizedBody
        geofenceDescriptionLabel.textColor = .text
        geofenceDescriptionLabel.textAlignment = .center
        geofenceDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(geofenceDescriptionLabel)
        NSLayoutConstraint.activate([
            geofenceDescriptionLabel.leadingAnchor.constraint(equalTo: geofenceBox.leadingAnchor),
            geofenceDescriptionLabel.trailingAnchor.constraint(equalTo: geofenceBox.trailingAnchor),
            geofenceDescriptionLabel.centerYAnchor.constraint(equalTo: geofenceBox.centerYAnchor),
            ])
        
        geofenceEditButton.setTitle(NSLocalizedString("Change", comment: "Edit geofence button title for geofence tracking view."), for: .normal)
        geofenceEditButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(geofenceEditButton)
        NSLayoutConstraint.activate([
            geofenceEditButton.centerXAnchor.constraint(equalTo: geofenceBox.centerXAnchor),
            geofenceEditButton.topAnchor.constraint(equalTo: geofenceDescriptionLabel.bottomAnchor, constant: 15)
            ])
    }
    
    func transition(to state: State) {
        switch state {
        case .unknown:
            resultLabel.text = NSLocalizedString("🛰", comment: "Geofence tracking view 'pending' result.")
            backgroundColor = .background
            geofenceEditButton.setTitleColor(.background, for: .normal)

        case .outside:
            resultLabel.text = NSLocalizedString("OUTSIDE", comment: "Geofence tracking view 'outside' result.")
            backgroundColor = .background
            geofenceEditButton.setTitleColor(.background, for: .normal)
            break
            
        case .inside:
            resultLabel.text = NSLocalizedString("INSIDE", comment: "Geofence tracking view 'outside' result.")
            backgroundColor = .trackerBackgroundWhenInside
            geofenceEditButton.setTitleColor(.trackerBackgroundWhenInside, for: .normal)
            break
            
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported.")
    }
}
