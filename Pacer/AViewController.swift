

import UIKit
import Parse


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
        
    }
    
    
    //table stuff here
    @IBOutlet weak var userTable: UITableView!
    
    //var keyTable:[String] = []
    //var introDict = Dictionary<String, String>()
    var valueDict = Dictionary<String, String>()
    let defaultDict: [String: String] = ["team" : "you're not on a team!"]
    let keyList: [String] = ["name", "team", "score"]
    
    let removedString = "Optional("
    let blankSpace: String = "\u{2422}"
    
    func objectStringCleaner(input: String) -> String{
        
        let removedRange: Range<String.Index> = input.startIndex...advance(input.startIndex, 8)
        var result = input.stringByReplacingOccurrencesOfString(removedString, withString: "", range: removedRange)
        return result.substringToIndex(result.endIndex.predecessor())
    }
    
    func updateUserInfo(){
        var userProfile = PFUser.currentUser()!["profile"] as? PFObject
        
        if (userProfile == nil){
            println("nil userProfile")
        } else {
            var userID: String = userProfile!.objectId!
            var userQuery = PFQuery(className: "Player")
            var userPlayer: PFObject = userQuery.getObjectWithId(userID)!
            
            for key in keyList {
                valueDict.updateValue("\(userProfile!.objectForKey(key))", forKey: key)
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keyList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCellStyle.Value2, reuseIdentifier: nil)
        
        let rowTitle = keyList[indexPath.row]
        var rowContent: String = valueDict[rowTitle]!
        if rowContent == removedString + ")"{
            rowContent = defaultDict[rowTitle]!
            cell.backgroundColor = UIColor.redColor()
        }
        cell.textLabel?.text = "\(rowTitle):"
        cell.detailTextLabel?.text = objectStringCleaner(rowContent)
        
        return cell
    }
}