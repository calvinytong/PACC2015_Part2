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

//Constants for error messages used throughout the program
let errorTitle = "Error"
let errorButtonString = "Affirmative"

//Log in screen view controller
class loginViewController : UIViewController {
    
    //Variables for working with the two entry fields on the login screen
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passworldField: UITextField!
    
    //Disables editing/keyboard when background is tapped
    @IBAction func backgroundTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    //Checks if there is a user, and dismisses the view if a user is logged in
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(true)
        if (PFUser.currentUser() != nil){
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Logs in the user
    @IBAction func pressLogin(sender: UIButton) {
        if (usernameField.text.isEmpty || passworldField.text.isEmpty)
        {
            //Error popup if username and/or password is empty
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
    
    /**
     * the login function using parse
     * @return loggedIn the boolean saying if signin failed or not
     */
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

