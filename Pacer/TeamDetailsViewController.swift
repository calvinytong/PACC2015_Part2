//
//  TeamDetailsViewController.swift
//  Pacer
//
//  Created by Joseph Zhong on 5/29/15.
//  Copyright (c) 2015 Joseph Zhong. All rights reserved.
//

import UIKit
import Parse

class TeamDetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var challengeBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var teamName: UILabel!
    
    var team: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println(team)
        teamName.text = team["name"] as? String
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func challengeBtnClicked(sender: AnyObject) {
        // goes to challenge page
/*
        var parentVC = parentViewController!
        parentVC.performSegueWithIdentifier("goToChallengeTeam", sender: self)
*/
        self.performSegueWithIdentifier("goToChallengeTeam", sender: self)
    }
    
    @IBAction func cancelBtnClicked(sender: AnyObject) {
        // goes back
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
