//
//  signUpViewController.swift
//  Pacer
//
//  Created by Calvin Tong on 5/13/15.
//  Copyright (c) 2015 Joseph Zhong. All rights reserved.
//

import Foundation
import UIKit
import Parse


class signUpViewController : UIViewController {

    @IBOutlet weak var createUsername: UITextField!
    @IBOutlet weak var createPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var createEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func donePress(sender: UIButton)
    {
        createLogin()
    }
    
    @IBAction func backToLoginPressed(sender: UIButton)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func createLogin() {
        var user = PFUser()
        user.username = createUsername.text
        user.password = createPassword.text
        user.email = createEmail.text
        let userplayer = Player(name : createUsername.text)
        user["objectid"] = userplayer.ObjectID
        
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo?["error"] as! String?
                var failAlert: UIAlertView = UIAlertView()
                failAlert.title = "Error Creating Account"
                failAlert.message = errorString!
                failAlert.addButtonWithTitle("Try Again")
                failAlert.show()
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
}