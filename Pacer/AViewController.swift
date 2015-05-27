

import UIKit
import Parse

let removedString = "Optional("

func objectStringCleaner(input: String) -> String{
    
    if count(input) < count(removedString) + 1{
        return input
    }
    
    
    let removedRange: Range<String.Index> = input.startIndex...advance(input.startIndex, count(removedString))
    var result = input.stringByReplacingOccurrencesOfString(removedString, withString: "", range: removedRange)
    return result.substringToIndex(result.endIndex.predecessor())
}

class AViewController: UIViewController, UITableViewDataSource{
    
    @IBOutlet weak var welcome: UILabel!
    var SIZE = UIScreen.mainScreen().bounds.width; // sets width
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a 
        self.view.frame.size.width = SIZE;
        updateUserInfo()
        userTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func labelSize(inputLabel: UILabel){
        
        let maxSize: CGSize  = CGSizeMake(187, CGFloat.max)
        var size: CGSize = inputLabel.sizeThatFits(maxSize)
        var rect: CGRect = inputLabel.frame
        rect.size.height = size.height
        inputLabel.frame = rect
    }
    
    @IBAction func logoutPressed(sender: UIButton) {
        PFUser.logOutInBackground()
        var parentVC = parentViewController!
        parentVC.performSegueWithIdentifier("goToLogin", sender: parentVC)
    }
    
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(true)
        dispatch_async(dispatch_get_main_queue(), {
            self.welcome.text = PFUser.currentUser() == nil ? "" : "Hello \(PFUser.currentUser()!.username!)!"
            self.labelSize(self.welcome)
        })
        updateUserInfo()
        userTable.reloadData()
        
    }
    
    
    //table stuff here
    @IBOutlet weak var userTable: UITableView!
    
    //var keyTable:[String] = []
    //var introDict = Dictionary<String, String>()
    var valueDict = Dictionary<String, String>()
    let defaultDict: [String: String] = ["team" : "you're not on a team!", "competition" : "you're not in a competition!"]
    let keyList: [String] = ["name", "team", "competition", "score"]
    
    
    func updateUserInfo(){
        var userProfileReference = PFUser.currentUser()!["profile"] as? PFObject
        
        if (userProfileReference == nil){
            println("nil userProfile")
        } else {
            //var userID: String = userProfile!.objectId!
            //var userQuery = PFQuery(className: "Player")
            //var userPlayer: PFObject = userQuery.getObjectWithId(userID)!
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keyList.count
    }
    
    func leaveTeam(sender: UIButton){
        var userProfile: Player = Player(player: (PFUser.currentUser()!["profile"] as? PFObject)!)
        userProfile.Object["team"] = ""
        userProfile.pushObject()
        updateUserInfo()
        userTable.reloadData()
    }
    
    func createLeaveButton() -> UIButton{
        var leaveTeamButton: UIButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        leaveTeamButton.frame = CGRectMake(310, -5, 55, 55)
        leaveTeamButton.showsTouchWhenHighlighted = true
        leaveTeamButton.setTitle("leave", forState: UIControlState.Normal)
        leaveTeamButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        leaveTeamButton.addTarget(self, action: "leaveTeam:", forControlEvents: UIControlEvents.TouchUpInside)
        return leaveTeamButton
    }
    
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