//
//  TeamDetailsViewController.swift
//  Pacer
//
//  Created by Joseph Zhong on 5/29/15.
//  Copyright (c) 2015 Joseph Zhong. All rights reserved.
//

import UIKit
import Parse

class TeamDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var challengeBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var teamName: UILabel!
    
    var team: Team!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        teamName.text = team.Object["name"] as? String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToChallengeTeam"{
            var passed = segue.destinationViewController as! ChallengeViewController
            passed.passedTeam = team
    
        }
    }

    @IBAction func challengeBtnClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("goToChallengeTeam", sender: self)
    }
    
    @IBAction func cancelBtnClicked(sender: AnyObject) {
        // goes back
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("what up boys \(team.players.count)")
        return team.players.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: nil)
        var player = Player(player: team.players[indexPath.row])
        cell.textLabel?.text = player.Object["name"] as! String
        var playerScore: Int = player.Object["score"] as! Int
        cell.detailTextLabel?.text = "\(playerScore)"
        return cell
        
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
