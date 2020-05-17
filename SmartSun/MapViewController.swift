//
//  MapViewController.swift
//  SmartSun
//
//  Created by Cam Morgan on 12/3/19.
//  Copyright © 2019 SmartSun Inc. All rights reserved.
//

//

import UIKit
import MapKit
import CoreLocation

// Delegate allows data to be sent back to MainViewController
protocol MapViewControllerDelegate : NSObjectProtocol{
    func doSomethingWith(data: Location)
}

// Controls and sets up map view
class MapViewController: UIViewController, UINavigationControllerDelegate {
    
    var locations = Location()
    
    weak var delegate : MapViewControllerDelegate?

    @IBOutlet weak var mapView: MKMapView!
    
    fileprivate let locationManager: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        mapView.addGestureRecognizer(longTapGesture)
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        
        navigationController?.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Loads in previously placed pins
        if locations.latitudes.count > 0 {
            for i in 0...locations.latitudes.count - 1 {
                let coords = CLLocationCoordinate2D(latitude: locations.latitudes[i], longitude: locations.longitudes[i])
                let annotation = MKPointAnnotation()
                annotation.coordinate = coords
                annotation.title = "Location " + String(i + 1)
                annotation.subtitle = ""
                self.mapView.addAnnotation(annotation)
            }
        }
        
    }
    
    // Looks for user long tap
    @objc func longTap(sender: UIGestureRecognizer) {
        if sender.state == .began {
            let locationInView = sender.location(in: mapView)
            let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
            addAnnotation(location: locationOnMap)
        }
    }
    
    // Adds pins at tapped location
    func addAnnotation(location: CLLocationCoordinate2D) {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = "Location " + String(locations.titles.count + 1)
            annotation.subtitle = ""
            
            // Saves pin data to locations object
            locations.latitudes.append(annotation.coordinate.latitude)
            locations.longitudes.append(annotation.coordinate.longitude)
            locations.titles.append(annotation.title!)
        
            if let delegate = delegate{
                delegate.doSomethingWith(data: locations)
            }
        
            self.mapView.addAnnotation(annotation)
    }
    

}

extension MapViewController {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        (viewController as? MainViewController)?.locations = locations // Here you pass the to your original view controller
    }
}

extension MapViewController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { print("no mkpointannotaions"); return nil }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .infoDark)
            pinView!.pinTintColor = UIColor.black
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    

}
