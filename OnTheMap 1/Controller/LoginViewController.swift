//
//  LoginViewController.swift
//  OnTheMap 1
//
//  Created by Raneem Alhattlan on 05/09/2020.
//  Copyright © 2020 Raneem Alhattlan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailField: UITextField!
    
    
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func LoginButton(_ sender: Any) {
        TheAPI.postTheSession(username:  emailField.text!,
                              password: passwordField.text!)
        { (errorMessage) in
            guard errorMessage == nil else {
                self.alert(title: "login faild", message: errorMessage!)
                return
            }
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "login", sender: nil)
            }
        }
    }
    
    
    @IBAction func signupButton(_ sender: Any) {
        
        if let signUpURL = URL(string: "https://www.udacity.com/account/auth#!/signup"),
            UIApplication.shared.canOpenURL(signUpURL) {
            UIApplication.shared.open(signUpURL, options: [:], completionHandler: nil)
        }
    }
}


