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
        userQueryer.whereKey("name", containsString: username)
        var resultArray: Array = userQueryer.findObjects()!
        
        /*
        Unforunately, I can only search if the name entry of Player contains a string or not, and not
        if it matches exactly. I could do matches exactly with regex, but that adds the problem of if
        the user tries create a username with a part that could be intepreted as regex, which could result
        in unpredictable results.
        */
        
        println(resultArray)
        for obj in resultArray{
            var nameString: String = obj["name"] as! String
            nameString = objectStringCleaner(nameString)
            
            //Theoretically, if a match contains the username string, and is the same length as
            //the username string, it should be the same string.
            
            if count(nameString) == count(username){
                //team.Object["players"]?.add()
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
        }
        return usernameSuccess
    }
}
