//
//  CreateTeamViewController.swift
//  Pacer
//
//  Created by Joseph Zhong on 5/22/15.
//  Copyright (c) 2015 Joseph Zhong. All rights reserved.
//

import UIKit
import Parse

class CreateTeamViewController: UIViewController {

    @IBOutlet weak var teamNameField: UITextField!
    @IBOutlet weak var teammate1: UITextField!
    @IBOutlet weak var teammate2: UITextField!
    @IBOutlet weak var teammate3: UITextField!
    @IBOutlet weak var teammate4: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func cancelBtnClick(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func createTeam() {
        /*
        var user = PFUser()
        
        user.username = createUsername.text
        user.password = createPassword.text
        user.email = createEmail.text
        let userplayer = Player(name : createUsername.text)
        user["profile"] = userplayer.Object
        
        
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
        */
        var newteam = PFObject()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
