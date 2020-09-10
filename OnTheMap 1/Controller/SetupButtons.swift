//
//  SetupButtons.swift
//  OnTheMap 1
//
//  Created by Raneem Alhattlan on 06/09/2020.
//  Copyright © 2020 Raneem Alhattlan. All rights reserved.
//

import UIKit

class SetupButtons: UIViewController {
    
    var locationsInfo: Locations?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        downloadData()
        
    }
    
    
    
    
    func setupButtons() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addButton(_:)))
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshButton(_:)))
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.logoutButton(_:)))
        
        navigationItem.rightBarButtonItems = [addButton, refreshButton]
        navigationItem.leftBarButtonItem = logoutButton
    }
    
    
    
    
    
    @objc private func addButton(_ sender: Any) {
        let navController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddNewLocation") as! UINavigationController
        
        present(navController, animated: true, completion: nil)
    }
    
    
    
    
    
    @objc private func refreshButton(_ sender: Any) {
        downloadData()
    }
    
    
    
    
    
    @objc private func logoutButton(_ sender: Any) {
        let alertController = UIAlertController(title: "Logout", message: "Are you sure?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (_) in
            TheAPI.deleteTheSession { (error) in
                guard error == nil  else {
                    self.alert(title: "Error", message: error!)
                    return
                }
                self.dismiss(animated: true, completion: nil)
                
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true , completion: nil)
    }
    
    
    private func downloadData() {
        TheAPI.getStudentLocations { (data) in
            guard let data = data else {
                self.alert(title: "Error", message: "No internet connection found")
                return
            }
            guard data.results.count > 0 else {
                self.alert(title: "Error", message: "No pins found")
                return
            }
            self.locationsInfo = data
        }
    }
    
    
}
