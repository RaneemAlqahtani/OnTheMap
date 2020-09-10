//
//  SubmitLocation.swift
//  OnTheMap 1
//
//  Created by Raneem Alhattlan on 06/09/2020.
//  Copyright © 2020 Raneem Alhattlan. All rights reserved.
//

import UIKit
import MapKit

class SubmitLocation: UIViewController {
    @IBOutlet weak var map: MKMapView!
    
    var location: StudentLocation?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapSetup()
        
    }
    
    @IBAction func submitButton(_ sender: UIButton) {
        TheAPI.postLocation(self.location!) { error  in
            guard error == nil else {
                self.alert(title: "Error", message: error!)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    
    
    private func mapSetup() {
        guard let location = location else { return }
        
        let latit = CLLocationDegrees(location.latitude!)
        let longit = CLLocationDegrees(location.longitude!)
        
        let coordinate = CLLocationCoordinate2D(latitude: latit, longitude: longit)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = location.mapString
        
        map.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        map.setRegion(region, animated: true)
    }
    
    
    
}



extension SubmitLocation: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pin = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pin == nil {
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
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
    
    
}


