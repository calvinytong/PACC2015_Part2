//
//  ChallengeViewController.swift
//  Pacer
//
//  Created by Joseph Zhong on 5/26/15.
//  Copyright (c) 2015 Joseph Zhong. All rights reserved.
//

import UIKit
import Parse

class ChallengeViewController: UIViewController {

    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var dashChallengeBtn: UIButton!
    @IBOutlet weak var dashLabel: UILabel!
    
    var passedTeam: Team!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dashChallengeBtn.backgroundColor
            = UIColor(red: 1.0, green: 0.7, blue: 0.15, alpha: 1.0)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func dashChallengeBtnClicked(sender: AnyObject) {
        if(dashLabel.hidden == true)
        {
            dashLabel.hidden = false;
            dashLabel.textColor = UIColor(red: 0.45, green: 0.75, blue: 0.94, alpha: 1.0)
            dashChallengeBtn.backgroundColor
                = UIColor(red: 0.45, green: 0.75, blue: 0.94, alpha: 1.0)
        }
        else
        {
            dashLabel.hidden = true;
            dashChallengeBtn.backgroundColor
                = UIColor(red: 1.0, green: 0.7, blue: 0.15, alpha: 1.0)
        }
    }
    @IBAction func cancelBtnClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func confirmBtnClicked(sender: AnyObject) {
        // Create new competition and add
        var name = PFUser.currentUser()!.username
        // get both team names and push competition object
//        var team1 = PFUser.currentUser()["profile"].
//        var team1 = PFUser.currentUser()!.
        self.dismissViewControllerAnimated(true, completion: nil)
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
