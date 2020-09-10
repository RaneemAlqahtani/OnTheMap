//
//  AddNewLocation.swift
//  OnTheMap 1
//
//  Created by Raneem Alhattlan on 06/09/2020.
//  Copyright © 2020 Raneem Alhattlan. All rights reserved.
//

import UIKit
import CoreLocation

class AddNewLocation: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var mediaLinkField:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCancelButton()
    }
    
    
    @IBAction func findLocationButton(_ sender: UIButton) {
        guard let findLocation = locationField.text,
            let mediaLink = mediaLinkField.text,
            findLocation != "", mediaLink != "" else {
                self.alert(title: "Missing Infromation", message: "fill all the fields")
                return
        }
        let studentLocation = StudentLocation(mapString: findLocation, mediaURL: mediaLink)
        passToNextController(studentLocation)
        
        
        
    }
    
    
    private func passToNextController(_ location: StudentLocation){
        let gcoder = CLGeocoder()
        let start = self.startAnActivityIndicator()
        gcoder.geocodeAddressString(location.mapString!) { (placeMark, _) in
            start.stopAnimating()
            guard let pm  = placeMark else{
                self.alert(title: "Error", message: "Can not gecode your location")
                return
                
            }
            
            var studentLocation = location
            studentLocation.longitude = Double((pm.first?.location!.coordinate.longitude)!)
            studentLocation.latitude = Double((pm.first?.location!.coordinate.latitude)!)
            self.performSegue(withIdentifier: "mapLink", sender: studentLocation)
        }
        
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapLink", let vc = segue.destination as? SubmitLocation{
            vc.location = (sender as! StudentLocation)
        }
    }
    
    
    private func setupCancelButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(self.cancelButton(_:)))
        
        locationField.delegate = self
        mediaLinkField.delegate = self
    }
    
    @objc private func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension UIViewController {
    func startAnActivityIndicator() -> UIActivityIndicatorView {
        let start = UIActivityIndicatorView(style: .medium)
        self.view.addSubview(start)
        self.view.bringSubviewToFront(start)
        start.center = self.view.center
        start.hidesWhenStopped = true
        start.startAnimating()
        return start
    }
}
