//
//  Alert.swift
//  OnTheMap 1
//
//  Created by Raneem Alhattlan on 05/09/2020.
//  Copyright © 2020 Raneem Alhattlan. All rights reserved.
//


import UIKit

extension UIViewController{
    
    func alert(title: String, message: String){
        let alertMessage = UIAlertController(title: title , message: message, preferredStyle: .alert)
        alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertMessage , animated: true , completion: nil)
    }
    
}

    
    
    


