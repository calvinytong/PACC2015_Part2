//
//  loginViewController.swift
//  Pacer
//
//  Created by Calvin Tong on 5/11/15.
//  Copyright (c) 2015 Joseph Zhong. All rights reserved.
//

import UIKit
import Foundation


let errorTitle = "Error"
let errorButtonString = "Affirmative"

class loginViewController : UIViewController {
    
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passworldField: UITextField!
    @IBAction func pressLogin(sender: UIButton) {
        if (usernameField.text == "" || passworldField.text == ""){
            var failAlert: UIAlertView = UIAlertView()
            failAlert.title = errorTitle
            failAlert.message = "Please enter in your username and password."
            failAlert.addButtonWithTitle(errorButtonString)
            failAlert.show()
        } else if (isUsernamePasswordCombo()){
            loginWithUsername(usernameField.text)
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            var failAlert: UIAlertView = UIAlertView()
            failAlert.title = errorTitle
            failAlert.addButtonWithTitle(errorButtonString)
            failAlert.message = "Invalid username/password combination."
            failAlert.show()
        }
    }
    
    func isUsernamePasswordCombo() -> Bool{
        //Add actual Parse function here.
        return usernameField.text == "username" && passworldField.text == "password"
    }
    
    @IBAction func pressSignUp(sender: UIButton) {
        self.performSegueWithIdentifier("toSignUp", sender: self)
    }
    
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(true)
        if (NSUserDefaults.standardUserDefaults().integerForKey("loginstatus") as Int == 1){
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

func loginWithUsername(username: String){
    NSUserDefaults().setInteger(1, forKey: "loginstatus")
    NSUserDefaults().setObject(username as String, forKey: "username")
}
