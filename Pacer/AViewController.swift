

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
        self.view.frame.size.width = SIZE;
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
    
    //Updates the arrays/dict that acts as data source for the table view
    func updateUserInfo(){
        var userProfileReference = PFUser.currentUser()!["profile"] as? PFObject
        
        if (userProfileReference == nil){
            println("nil userProfile")
        } else {
            var userProfile: Player = Player(player: userProfileReference!)
            for key in keyList {
                if key == "competition"{
                    valueDict.updateValue("", forKey: key)
                    continue
                }
                
                valueDict.updateValue("\(userProfile.Object.objectForKey(key))", forKey: key)
            }
        }
    }
    
    //Returns number of keys as number of rows for table
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keyList.count
    }
    
    //Leave team function that triggers when leave team button is pres
    func leaveTeam(sender: UIButton){
        var userProfile: Player = Player(player: (PFUser.currentUser()!["profile"] as? PFObject)!)
        userProfile.Object["team"] = ""
        userProfile.pushObject()
        updateUserInfo()
        userTable.reloadData()
    }
    
    //Function that creates the leave button
    func createLeaveButton() -> UIButton{
        var leaveTeamButton: UIButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        leaveTeamButton.frame = CGRectMake(310, -5, 55, 55)
        leaveTeamButton.showsTouchWhenHighlighted = true
        leaveTeamButton.setTitle("leave", forState: UIControlState.Normal)
        leaveTeamButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        leaveTeamButton.addTarget(self, action: "leaveTeam:", forControlEvents: UIControlEvents.TouchUpInside)
        return leaveTeamButton
    }
    
    //Populates the table row by row
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCellStyle.Value2, reuseIdentifier: nil)
        
        let rowTitle = keyList[indexPath.row]
        var rowContent: String = objectStringCleaner(valueDict[rowTitle]!)
        if rowContent.isEmpty{
            rowContent = defaultDict[rowTitle]!
            cell.backgroundColor = UIColor.redColor()
        }
        
        if (rowTitle == "team"){
            var leaveTeamButton = createLeaveButton()
            cell.addSubview(leaveTeamButton)
        }
        cell.textLabel?.text = rowTitle
        cell.detailTextLabel?.text = rowContent
        return cell
    }
}