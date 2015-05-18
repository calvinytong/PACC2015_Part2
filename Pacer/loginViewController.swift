//
//  loginViewController.swift
//  Pacer
//
//  Created by Calvin Tong on 5/11/15.
//  Copyright (c) 2015 Joseph Zhong. All rights reserved.
//

import UIKit
import Foundation
import Parse
import Bolts


let errorTitle = "Error"
let errorButtonString = "Affirmative"

class loginViewController : UIViewController {
    
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passworldField: UITextField!
    
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
    
    @IBAction func pressLogin(sender: UIButton) {
        if (usernameField.text.isEmpty || passworldField.text.isEmpty)
        {
            var failAlert: UIAlertView = UIAlertView()
            failAlert.title = errorTitle
            failAlert.message = "Please enter in your username and password."
            failAlert.addButtonWithTitle(errorButtonString)
            failAlert.show()
        }
        else
        {
            login()
        }
    }
    
    @IBAction func pressSignUp(sender: UIButton) {
        self.performSegueWithIdentifier("toSignUp", sender: self)
    }
    
    func login() -> Bool{
        var loggedIn : Bool = true
        PFUser.logInWithUsernameInBackground(usernameField.text, password: passworldField.text) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                //use PFUser.CurrentUser to Access the current user
                loggedIn = true
                self.dismissViewControllerAnimated(true, completion: nil)
                println(PFUser.currentUser())
            } else {
                var failAlert: UIAlertView = UIAlertView()
                failAlert.title = errorTitle
                failAlert.addButtonWithTitle(errorButtonString)
                failAlert.message = "Invalid username/password combination."
                failAlert.show()
            }
        }
        return loggedIn
    }
    
    

    
}

