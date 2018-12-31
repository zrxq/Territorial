//
//  GeofenceEditorViewController.swift
//  Territorial
//
//  Created by Zoreslav Khimich on 12/28/18.
//  Copyright © 2018 Slate. All rights reserved.
//

import UIKit
import MapKit

protocol GeofenceEditorDelegate: AnyObject {
    func geofenceEditor(_ editor: GeofenceEditorViewController, didEndEditingGeofence geofence: Geofence)
}

final class GeofenceEditorViewController: UIViewController {
    
    weak var delegate: GeofenceEditorDelegate?
    
    private static let fenceRadiusToZoomFactor = Double(1.5) * 2
    private static let pinViewReuseIdentifier = "GeofenceEditorViewController.pinViewReuseIdentifier"
    
    private let geofence: GeofenceAnnotation
    
    private let mapView = MKMapView(frame: .zero)
    private lazy var radiusOverlay = MKCircle(center: geofence.coordinate, radius: geofence.radius)
    
    private lazy var propertyEditor: GeofencePropertySheetController = GeofencePropertySheetController(radius: geofence.radius, ssid: geofence.ssid)

    init(with geofence: Geofence) {
        self.geofence = geofence.annotation()
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.loadView()
        
        let zoom = GeofenceEditorViewController.fenceRadiusToZoomFactor
        
        mapView.delegate = self
        mapView.frame = view.frame
        mapView.showsUserLocation = true
        mapView.region = MKCoordinateRegion(center: geofence.coordinate, latitudinalMeters: geofence.radius * zoom, longitudinalMeters: geofence.radius * zoom)
        mapView.addAnnotation(geofence)
        mapView.addOverlay(radiusOverlay)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        self.geofence.onAreaChanged = { [unowned self] _ in
            self.updateOverlayAndPlacemark()
        }
        
        view.addSubview(mapView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Geofence Area", comment: "Geofence editor view controller title.")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(done))

        let trackingButton = MKUserTrackingBarButtonItem(mapView: mapView)
        navigationItem.rightBarButtonItem = trackingButton
        
        mapView.register(MKPinAnnotationView.self, forAnnotationViewWithReuseIdentifier: GeofenceEditorViewController.pinViewReuseIdentifier)

        propertyEditor.delegate = self
        install(propertyEditor)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: propertyEditor.view.bottomAnchor),
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(moveCenter))
        mapView.addGestureRecognizer(longPressRecognizer)
        
    }
    
    @objc func done() {
        geofence.ssid = propertyEditor.ssid ?? ""
        delegate?.geofenceEditor(self, didEndEditingGeofence: geofence.geofence())
    }
    
    @objc func moveCenter(reco: UILongPressGestureRecognizer) {
        let location = reco.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        geofence.coordinate = coordinate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not supported.")
    }
}

extension GeofenceEditorViewController: MKMapViewDelegate {
    
    func updateOverlayAndPlacemark() {
        mapView.removeOverlay(radiusOverlay)
        radiusOverlay = MKCircle(center: geofence.coordinate, radius: geofence.radius)
        mapView.addOverlay(radiusOverlay)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is GeofenceAnnotation else { return nil }
        
        let pin = mapView.dequeueReusableAnnotationView(withIdentifier: GeofenceEditorViewController.pinViewReuseIdentifier, for: annotation) as! MKPinAnnotationView
        pin.isDraggable = true
        pin.pinTintColor = MKPinAnnotationView.purplePinColor()
        pin.canShowCallout = false
        
        return pin
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        switch overlay {
        case let circle as MKCircle:
            let renderer = MKCircleRenderer(circle: circle)
            renderer.lineWidth = 2
            renderer.strokeColor = .active
            renderer.fillColor = UIColor.active.withAlphaComponent(0.1)
            return renderer
            
        default:
            fatalError("Don't know how to render \(overlay)")
        }
    }
}

extension GeofenceEditorViewController: GeofencePropertySheetControllerDelegate {
    func geofenceSheetController(_ controller: GeofencePropertySheetController, didUpdateRadius radius: CLLocationDistance) {
        geofence.radius = radius
    }
}
