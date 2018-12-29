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
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.showsUserLocation = true
        mapView.region = MKCoordinateRegion(center: geofence.coordinate, latitudinalMeters: geofence.radius * zoom, longitudinalMeters: geofence.radius * zoom)
        mapView.addAnnotation(geofence)
        mapView.addOverlay(radiusOverlay)
        
        self.geofence.onAreaChanged = { [unowned self] _ in
            self.updateOverlayAndPlacemark()
        }
        
        view.addSubview(mapView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Geofence Area", comment: "Geofence editor view controller title.")
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        mapView.register(MKPinAnnotationView.self, forAnnotationViewWithReuseIdentifier: GeofenceEditorViewController.pinViewReuseIdentifier)

        propertyEditor.delegate = self
        install(propertyEditor)
    }
    
    @objc func done() {
        geofence.ssid = propertyEditor.ssid
        delegate?.geofenceEditor(self, didEndEditingGeofence: geofence.geofence())
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
