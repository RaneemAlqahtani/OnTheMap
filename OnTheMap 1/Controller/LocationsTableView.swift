//
//  LocationsTableViewController.swift
//  OnTheMap 1
//
//  Created by Raneem Alhattlan on 06/09/2020.
//  Copyright © 2020 Raneem Alhattlan. All rights reserved.
//

import UIKit

class LocationsTableView: SetupButtons {
    
    @IBOutlet weak var locationsTableView: UITableView!
    
    
    
    override var locationsInfo: Locations? {
        
        didSet {
            guard let locationsData = locationsInfo else { return }
            locations = locationsData.results
        }
    }
    
    
    
    var locations: [StudentLocation] = [] {
        didSet {
            DispatchQueue.main.async {
                self.locationsTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension LocationsTableView: UITableViewDelegate, UITableViewDataSource  {
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentLocationCell", for: indexPath) as!
        LocationsTableViewCell
        cell.studentLocation = locations[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let studentLocation = locations[indexPath.row]
        let mediaURL = studentLocation.mediaURL!
        guard let url = URL(string: mediaURL), UIApplication.shared.canOpenURL(url) else{
            self.alert(title: "Error", message: "URL is invalid ")
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
