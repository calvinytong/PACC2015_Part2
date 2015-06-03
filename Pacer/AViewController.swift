

import UIKit
import Parse

//Constant for removing part of string that happens when anyobject is casted as string
let removedString = "Optional("

//Cleans the string that is casted from an anyobject
func objectStringCleaner(input: String) -> String{
    
    if count(input) < count(removedString) + 1{
        return input
    }
    let removedRange: Range<String.Index> = input.startIndex...advance(input.startIndex, count(removedString))
    var result = input.stringByReplacingOccurrencesOfString(removedString, withString: "", range: removedRange)
    return result.substringToIndex(result.endIndex.predecessor())
}

class AViewController: UIViewController, UITableViewDataSource{
    
    //Welcome message label
    @IBOutlet weak var welcome: UILabel!
    var SIZE = UIScreen.mainScreen().bounds.width; // sets width
    
    
    //Loads the table with relevant information
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateInfoOnNotify:", name: "refresh", object: nil)
        self.view.frame.size.width = SIZE;
        self.userTable.rowHeight = 60
        self.userTable.frame.size.height = 240
        updateUserInfo()
        userTable.reloadData()
        
        var nib = UINib(nibName: "CustomProfileCell", bundle: nil)
        userTable.registerNib(nib, forCellReuseIdentifier: "profileCell")
        
        
        
    }
    
    func updateInfoOnNotify(notification: NSNotification){
        updateUserInfo()
        userTable.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Dynamically adjust the label size based on string length
    func labelSize(inputLabel: UILabel){
        let maxSize: CGSize  = CGSizeMake(187, CGFloat.max)
        var size: CGSize = inputLabel.sizeThatFits(maxSize)
        var rect: CGRect = inputLabel.frame
        rect.size.height = size.height
        inputLabel.frame = rect
    }
    
    //Logs out the user and segues to the login screen when logout button is pushed
    @IBAction func logoutPressed(sender: UIButton) {
        PFUser.logOutInBackground()
        var parentVC = parentViewController!
        parentVC.performSegueWithIdentifier("goToLogin", sender: parentVC)
    }
    
    //Reloads the table and the label when the view appears
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(true)
        dispatch_async(dispatch_get_main_queue(), {
            self.welcome.text = PFUser.currentUser() == nil ? "" : "Hello \(PFUser.currentUser()!.username!)!"
            self.labelSize(self.welcome)
        })
        updateUserInfo()
        userTable.reloadData()
    }
    
    //Table variable that can be loaded with data
    @IBOutlet weak var userTable: UITableView!
    
    //Dictionary to retrieve strings for table from
    var valueDict = Dictionary<String, String>()
    
    //Default dictionary if string from valueDict is blank
    let defaultDict: [String: String] = ["team" : "you're not on a team!", "competition" : "you're not in a competition!"]
    
    //Keys for the valueDict
    let keyList: [String] = ["name", "team", "competition", "score"]
    
    var mainParseManager: ParseManager = ParseManager()
    
    //Updates the arrays/dict that acts as data source for the table view
    func updateUserInfo(){
        if let userProfileReference = PFUser.currentUser()
        {
            var userProfile: Player = Player(player: (userProfileReference["profile"] as? PFObject)!)
            for key in keyList
            {
                if key == "competition"
                {
                    //This is where the problem is. If you fix parse manager this should work
                    var teamPointer = userProfile.Object["team"] as? PFObject
                    if teamPointer != nil{
                        var teamerino: Team = mainParseManager.pullTeam(teamPointer!.objectId!)
                        var compPointer = teamerino.Object["competition"] as? PFObject
                        if compPointer != nil {
                            var comperino: Competition = mainParseManager.pullComp(compPointer!.objectId!)
                            valueDict.updateValue(comperino.Object["name"] as! String, forKey: key)

                        } else {
                            valueDict.updateValue("", forKey: key)
                        }
                    } else {
                        valueDict.updateValue("", forKey: key)
                    }
                    
                }
                else if let value: AnyObject = userProfile.Object[key]
                {
                    if (value as! NSObject == NSNull())
                    {
                        valueDict.updateValue("", forKey: key)
                    }
                    else
                    {
                        if key == "team" {
                            var valuePF: PFObject = value as! PFObject
                            var query = PFQuery(className: "Team")
                            var teamPF: PFObject = query.getObjectWithId(valuePF.objectId!)!
                            valueDict.updateValue(teamPF["name"] as! String, forKey: key)
                        } else {
                            valueDict.updateValue("\(value)", forKey: key)
                        }
                    }
                }
                else
                {
                    valueDict.updateValue("", forKey: key)
                }
            }
        }
    }
    
    //Returns number of keys as number of rows for table
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keyList.count
    }
    
    //Leave team function that triggers when leave team button is pres
    func leaveTeam(sender: UIButton){
        if let currentUser = PFUser.currentUser(){
        
            var userProfile: Player = Player(player: (currentUser["profile"] as? PFObject)!)
            userProfile.leaveTeam()
            //updateUserInfo()
            //userTable.reloadData()
            
            NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: nil)
        }
    }
    
    //Function that creates the leave button
    func createLeaveButton() -> UIButton{
        var leaveTeamButton: UIButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        leaveTeamButton.frame = CGRectMake(310, 13, 55, 55)
        leaveTeamButton.showsTouchWhenHighlighted = true
        leaveTeamButton.setTitle("leave", forState: UIControlState.Normal)
        leaveTeamButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        leaveTeamButton.addTarget(self, action: "leaveTeam:", forControlEvents: UIControlEvents.TouchUpInside)
        return leaveTeamButton
    }
    
    
    
    //Populates the table row by row
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: nil)
        
        var cell: CustomProfileCellVC = self.userTable.dequeueReusableCellWithIdentifier("profileCell") as! CustomProfileCellVC
        
        let rowTitle = keyList[indexPath.row]
        if valueDict[rowTitle] == nil{

            return cell
        }
        var rowContent: String = ""
        if rowTitle == "team" {
            var leaveTeamButton = createLeaveButton()
            cell.addSubview(leaveTeamButton)
            leaveTeamButton.hidden = false
            if valueDict[rowTitle]! == "" {
                leaveTeamButton.hidden = true
            }
            rowContent = valueDict[rowTitle]!
        } else {
            rowContent = objectStringCleaner(valueDict[rowTitle]!)
        }
        if rowContent.isEmpty{
            rowContent = defaultDict[rowTitle]!
            cell.backgroundColor = UIColor.redColor()
        } else {
            cell.backgroundColor = UIColor.whiteColor()
        }

        cell.cellTitle.text = rowTitle
        cell.cellValue.text = rowContent
        //cell.textLabel?.text = rowTitle
        //cell.detailTextLabel?.text = rowContent
        return cell
    }

}