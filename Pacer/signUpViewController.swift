//
//  signUpViewController.swift
//  Pacer
//
//  Created by Calvin Tong on 5/13/15.
//  Copyright (c) 2015 Joseph Zhong. All rights reserved.
//

import Foundation
import UIKit


class signUpViewController : UIViewController {

    @IBOutlet weak var createUsername: UITextField!
    @IBOutlet weak var createPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var createEmail: UITextField!
    @IBAction func donePress(sender: UIButton) {
        if (!isUsernameAvailable() || !isEmailAvailable() || !passwordCheck()){
            var failAlert: UIAlertView = UIAlertView()
            failAlert.title = errorTitle
            failAlert.message = ""
            if (!isUsernameAvailable()){
                failAlert.message = failAlert.message! + "Username has been taken; please select a different username.\n"
            }
            if (!isEmailAvailable()){
                failAlert.message = failAlert.message! + "Email has already been used for another account.\n"
            }
            if (!passwordCheck()){
                failAlert.message = failAlert.message! + "Password does not match."
            }
            failAlert.addButtonWithTitle(errorButtonString)
            failAlert.show()
        } else {
            loginWithUsername(createUsername.text)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    @IBAction func backToLoginPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func isUsernameAvailable() -> Bool{
        //Checks Parse database to see if username is available.
        return true
    }
    
    func isEmailAvailable() -> Bool{
        //Checks Parse database to see if email has been used before.
        return true
    }
    
    func passwordCheck() -> Bool{
        return createPassword.text as String == confirmPassword.text as String
    }
    

}