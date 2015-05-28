//
//  CreateTeamViewController.swift
//  Pacer
//
//  Created by Joseph Zhong on 5/22/15.
//  Copyright (c) 2015 Joseph Zhong. All rights reserved.
//

import UIKit
import Parse

//Global function for creating an error alert
func initializeErrorAlert() -> UIAlertView{
    var usernameNotFoundAlert: UIAlertView = UIAlertView()
    usernameNotFoundAlert.title = errorTitle
    usernameNotFoundAlert.message = "The following users don't exist: "
    usernameNotFoundAlert.addButtonWithTitle(errorButtonString)
    return usernameNotFoundAlert
}

class CreateTeamViewController: UIViewController {
    
    //Entry fields for team name field and teammate fields.
    @IBOutlet weak var teamNameField: UITextField!
    @IBOutlet weak var teammate1: UITextField!
    @IBOutlet weak var teammate2: UITextField!
    @IBOutlet weak var teammate3: UITextField!
    @IBOutlet weak var teammate4: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //Puts all the entered usernames into an array for easy access
    func getUsernameArray() -> [String]{
        var array = [String]()
        array.append(teammate1.text)
        array.append(teammate2.text)
        array.append(teammate3.text)
        array.append(teammate4.text)
        return array
    }
    
    //Cancel button dismisses the current view
    @IBAction func cancelBtnClick(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Tries to create team and dismisses the current view if successful
    @IBAction func doneBtnClick(sender: UIButton) {
        if createTeam() {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    //Adds an user to a team when given the username
    func addUsertoTeam(username: String, team: Team)-> Bool{
        
        //Checks if username is an empty string
        if username.isEmpty{
            return true
        }
        
        //Queries for the team and player objects that have been inputted
        var userQueryer: PFQuery = PFQuery(className: "Player")
        userQueryer.whereKey("name", equalTo: username)
        var resultArray: Array = userQueryer.findObjects()!
        
        var teamQueryer: PFQuery = PFQuery(className: "Team")
        var teamObject: PFObject = teamQueryer.getObjectWithId(team.Object.objectId!)!
        
        println(resultArray)
        for obj in resultArray{
            var pfobj: PFObject = obj as! PFObject
            var nameString: String = obj["name"] as! String
            println(nameString)
            nameString = objectStringCleaner(nameString)
            
            //If username works, do it.
            
            if nameString == username{
                teamObject.addObject(pfobj, forKey: "players")
                teamObject.saveInBackground()
                pfobj["team"] = teamObject.objectId
                pfobj.saveInBackground()
                
                return true
            }
        }
        return false
    }
    
    //Creates a team and attempts to add the users
    func createTeam() -> Bool{

        var newTeam: Team = Team(name: teamNameField.text)
        var usernameNotFoundAlert = initializeErrorAlert()
        var usernameSuccess = true
        
        //If the user is valid, nothing gets added to the message, else for each user that fails, it adds the name of the failed user to the error message.
        for user in getUsernameArray() {
            if !addUsertoTeam(user, team: newTeam) {
                usernameSuccess = false
                usernameNotFoundAlert.message = usernameNotFoundAlert.message! + user + ","
            }
        }
        
        //If not all the usernames work, an error alert shows.
        if (!usernameSuccess){
            usernameNotFoundAlert.message = usernameNotFoundAlert.message!.substringToIndex(usernameNotFoundAlert.message!.endIndex.predecessor())
            usernameNotFoundAlert.show()
        } else {
        
            
        }
        
        return usernameSuccess
    }
}
