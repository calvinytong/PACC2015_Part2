
import UIKit
import Parse


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var Cell: UITableViewCell!
    @IBOutlet var totalView: UIView!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var detailButton: UIButton!
    
    var searchActive : Bool = false
    var data = ["San Francisco","New York","San Jose","Chicago","Los Angeles","Austin","Seattle"]
    var filtered:[String] = []
    var SIZE = UIScreen.mainScreen().bounds.width; // sets width
    var mainParseManager:ParseManager = ParseManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUserInfo()
        mainParseManager.pullTeams({(success: Bool!, error : NSError!) -> Void in
            if success == true
            {
                self.data = self.mainParseManager.teamNames
                NSLog("This is how many teams we found: \(self.data.count)")
            }
        })
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44.0
        
        self.view.frame.size.width = SIZE;
        tableView.frame.size.width = SIZE;
        
        /* Setup delegates */
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        

        
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if(tableView.hidden == true)
        {
            tableView.hidden = false;
        }
        filtered = data.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        /*
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        */
        searchActive = true;
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //var keyTable:[String] = []
    //var introDict = Dictionary<String, String>()
    var valueDict = Dictionary<String, String>()
    let defaultDict: [String: String] = ["team" : "you're not on a team!", "competition" : "you're not in a competition!"]
    let keyList: [String] = ["name", "team", "competition", "score"]
    
    let removedString = "Optional("
    
    func objectStringCleaner(input: String) -> String{
        
        if count(input) < count(removedString) + 1{
            return input
        }
        
        let removedRange: Range<String.Index> = input.startIndex...advance(input.startIndex, count(removedString))
        var result = input.stringByReplacingOccurrencesOfString(removedString, withString: "", range: removedRange)
        return result.substringToIndex(result.endIndex.predecessor())
    }
    
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
        if(!searchActive)
        {
            return keyList.count
        }
        else if(searchActive)
        {
            return filtered.count + 1 // Create Team as well
        }
        return data.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: nil)
        
        if(!searchActive) // checks if team exists
        {
            let rowTitle = keyList[indexPath.row]
            var rowContent: String = objectStringCleaner(valueDict[rowTitle]!)
            if rowContent.isEmpty{
                rowContent = defaultDict[rowTitle]!
                cell.backgroundColor = UIColor.redColor()
            }
            cell.textLabel?.text = rowTitle
            cell.detailTextLabel?.text = rowContent
            return cell;
        }
        else if(searchActive)
        {
            println(filtered.count)
            if(indexPath.row < filtered.count)
            {
                cell.textLabel?.text = filtered[indexPath.row]
            }
            else if(indexPath.row == (filtered.count))
            {
                cell.textLabel?.text = "Create New Team!" // works
            }
        }
        else
        {
            cell.textLabel?.text = data[indexPath.row]
        }
    
        return cell;
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("You DE-selected cell number: \(indexPath.row)!")
        self.joinButton.hidden = true;
        self.detailButton.hidden = true;
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        NSLog("You selected cell number: \(indexPath.row)!")
//        self.performSegueWithIdentifier("yourIdentifier", sender: self)
        var parentVC = parentViewController!
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell?.textLabel?.text == "Create New Team!" {
            parentVC.performSegueWithIdentifier("goToCreateTeam", sender: self)
        } else {
            self.joinButton.hidden = false;
            self.detailButton.hidden = false;
        }
        
    }
}


