//
//  MapController.swift
//  OnTheMap 1
//
//  Created by Raneem Alhattlan on 05/09/2020.
//  Copyright © 2020 Raneem Alhattlan. All rights reserved.
//

import UIKit
import MapKit
import Foundation

class MapController: SetupButtons ,MKMapViewDelegate {
    
    
    @IBOutlet weak var map: MKMapView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    override var locationsInfo: Locations? {
        didSet {
            reloadPins()
        }
    }
    
    
    
    
    
    func reloadPins() {
        
        //data that comes from the API
        guard let locations = locationsInfo?.results else { return }
        
        var notation  = [MKPointAnnotation]()
        
        for location in locations {
            
            //create annotations
            guard let latitude = location.latitude, let longitude = location.longitude else { continue }
            let latit = CLLocationDegrees(latitude)
            let longit = CLLocationDegrees(longitude)
            
            
            let locationCoordinate = CLLocationCoordinate2D(latitude: latit, longitude: longit)
            
            let firstName = location.firstName
            let lastName = location.lastName
            let mediaURL = location.mediaURL
            
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = locationCoordinate
            annotation.title = "\(firstName ?? "") \(lastName ?? "")"
            annotation.subtitle = mediaURL
            
            
            notation .append(annotation)
        }
        
        
        map.removeAnnotations(map.annotations)
        map.addAnnotations(notation )
    }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pin = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pin == nil {
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            //when user tap it will show callout
            pin!.canShowCallout = true
            pin!.pinTintColor = .red
            pin!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pin!.annotation = annotation
        }
        
        return pin
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped callout: UIControl) {
        if callout == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let open = view.annotation?.subtitle!,
                let url = URL(string: open), app.canOpenURL(url) {
                app.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
} //end
