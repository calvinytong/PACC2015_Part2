//
//  CreateTeamViewController.swift
//  Pacer
//
//  Created by Joseph Zhong on 5/22/15.
//  Copyright (c) 2015 Joseph Zhong. All rights reserved.
//

import UIKit
import Parse


func initializeErrorAlert() -> UIAlertView{
    var usernameNotFoundAlert: UIAlertView = UIAlertView()
    usernameNotFoundAlert.title = errorTitle
    usernameNotFoundAlert.message = "The following users don't exist: "
    usernameNotFoundAlert.addButtonWithTitle(errorButtonString)
    return usernameNotFoundAlert
}

class CreateTeamViewController: UIViewController {

    @IBOutlet weak var teamNameField: UITextField!
    @IBOutlet weak var teammate1: UITextField!
    @IBOutlet weak var teammate2: UITextField!
    @IBOutlet weak var teammate3: UITextField!
    @IBOutlet weak var teammate4: UITextField!
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    func getUsernameArray() -> [String]{
        var array = [String]()
        array.append(teammate1.text)
        array.append(teammate2.text)
        array.append(teammate3.text)
        array.append(teammate4.text)
        return array
    }

    @IBAction func cancelBtnClick(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func doneBtnClick(sender: UIButton) {
        if createTeam() {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func addUsertoTeam(username: String, team: Team)-> Bool{
        
        if username.isEmpty{
            return true
        }
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
    
    func createTeam() -> Bool{
        
        
        
        var newTeam: Team = Team(name: teamNameField.text)
        var usernameNotFoundAlert = initializeErrorAlert()
        var usernameSuccess = true
        
        
        for user in getUsernameArray() {
            if !addUsertoTeam(user, team: newTeam) {
                usernameSuccess = false
                usernameNotFoundAlert.message = usernameNotFoundAlert.message! + user + ","
            }
        }
        if (!usernameSuccess){
            usernameNotFoundAlert.message = usernameNotFoundAlert.message!.substringToIndex(usernameNotFoundAlert.message!.endIndex.predecessor())
            usernameNotFoundAlert.show()
        } else {
        
            
        }
        
        return usernameSuccess
    }
}
