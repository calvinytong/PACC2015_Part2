//
//  loginViewController.swift
//  Pacer
//
//  Created by Calvin Tong on 5/11/15.
//  Copyright (c) 2015 Joseph Zhong. All rights reserved.
//

import UIKit
import Foundation

class loginViewController : UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passworldField: UITextField!
    @IBAction func pressLogin(sender: UIButton) {
        if (usernameField.text == "username" && passworldField.text == "password"){
            NSUserDefaults().setInteger(1, forKey: "loginstatus")
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
