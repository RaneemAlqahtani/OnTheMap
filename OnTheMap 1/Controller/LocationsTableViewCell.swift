//
//  LocationsTableViewCell.swift
//  OnTheMap 1
//
//  Created by Raneem Alhattlan on 06/09/2020.
//  Copyright © 2020 Raneem Alhattlan. All rights reserved.
//

import UIKit

class LocationsTableViewCell: UITableViewCell{
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var link: UILabel!
    
    
    var studentLocation: StudentLocation? {
        didSet{
            guard let studentLocation = studentLocation else {
                return
            }
            name.text = "\(studentLocation.firstName ?? "") \(studentLocation.lastName ?? "")"
            link.text = studentLocation.mediaURL
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
