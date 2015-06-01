
import UIKit
import Parse


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    //Access to the search bar, table, table cell, entire view, and buttons
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var Cell: UITableViewCell!
    @IBOutlet var totalView: UIView!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var detailButton: UIButton!
    
    //True when the search bar is active, false when not.
    var searchActive : Bool = false
    
    //Array of data used to populate table
    var data = ["Seattle", "New York"]
    
    //Array of data filtered out to populate table given a search term
    var filtered:[String] = []
    var SIZE = UIScreen.mainScreen().bounds.width; // sets width
    
    //Used to call helper methods
    var mainParseManager:ParseManager = ParseManager()

    //Sets the data to list of all team names in the database
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "shuaXin:", name: "refresh", object: nil)
    }
    
    func shuaXin(notification: NSNotification){
        updateUserInfo()
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        mainParseManager.pullTeams({(success: Bool!, error : NSError!) -> Void in
            if success == true
            {
                self.data = self.mainParseManager.teamNames
                
                NSLog("This is how many teams we found: \(self.data.count)")
            }
        })
    
    }
    
    
    @IBAction func detailPressed(sender: UIButton) {
        var passed = parentViewController as! ContainerViewController
        var teamName: String = filtered[currentRow]
        var teamQuery: PFQuery = PFQuery(className: "Team")
        teamQuery.whereKey("name", equalTo: teamName)
        var teamList: Array = teamQuery.findObjects()!
        for obj in teamList {
            passed.passedTeam = obj as! PFObject
            break
        }
        parentViewController!.performSegueWithIdentifier("goToTeamDetails", sender: parentViewController!)
    }
    
        
    
    //Functions that change the search active status based on whether the search bar is active or not
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
    
    //Triggles a change in the table whenever the search bar input changes
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
        searchActive = true;
        self.joinButton.hidden = true;
        self.detailButton.hidden = true;

        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //Constants similar to AViewController for fetching data and putting it in an array for table to display
    var valueDict = Dictionary<String, String>()
    
    let defaultDict: [String: String] = ["team" : "you're not on a team!", "competition" : "you're not in a competition!"]
    
    let keyList: [String] = ["name", "team", "competition", "score"]
    
    let removedString = "Optional("
    
    var currentRow: Int = -1
    
    func objectStringCleaner(input: String) -> String{
        
        if count(input) < count(removedString) + 1{
            return input
        }
        
        let removedRange: Range<String.Index> = input.startIndex...advance(input.startIndex, count(removedString))
        var result = input.stringByReplacingOccurrencesOfString(removedString, withString: "", range: removedRange)
        return result.substringToIndex(result.endIndex.predecessor())
    }
    
    //Updates user information in the array for table to display
    func updateUserInfo(){
        if let userProfileReference = PFUser.currentUser(){
            var userProfile: Player = Player(player: (userProfileReference["profile"] as? PFObject)!)
            for key in keyList {
                if key == "competition"{
                    valueDict.updateValue("", forKey: key)
                    continue
                } else if let value: AnyObject = userProfile.Object[key]{
                    if (value as! NSObject == NSNull()){
                        valueDict.updateValue("", forKey: key)
                    } else {
                        valueDict.updateValue("\(value)", forKey: key)
                    }
                } else {
                    valueDict.updateValue("", forKey: key)
                }
            }
        }
    }
    @IBAction func joinPressed(sender: UIButton) {
        if currentRow == -1{
            return
        }
        var teamName: String = filtered[currentRow]
        var teamQuery: PFQuery = PFQuery(className: "Team")
        teamQuery.whereKey("name", equalTo: teamName)
        var teamList: Array = teamQuery.findObjects()!
        var currentPlayer: Player = Player(player: PFUser.currentUser()!["profile"] as! PFObject)
        
        

        for obj in teamList {
            var teamObj: Team = Team(team: obj as! PFObject)
            currentPlayer.joinTeam(teamObj)
            NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: nil)
            return
        }
    }
    //When search is active, displays the search results, otherwise it displays the default user information
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
    
    //Sets the table cells to the search results
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: nil)
        
        
        if(!searchActive) // checks if team exists
        {
            let rowTitle = keyList[indexPath.row]
            if (valueDict[rowTitle] == nil){
                return cell
            }
            var rowContent: String = objectStringCleaner(valueDict[rowTitle]!)
            if rowContent.isEmpty
            {
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
    
    //If a row is deselected, then it hides the challenge/detail buttons
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("You DE-selected cell number: \(indexPath.row)!")
        currentRow = -1
        self.joinButton.hidden = true;
        self.detailButton.hidden = true;
    }
    
    //If a row is selected, then it shows the challenge/ detail buttons, and if it's the create team row, then it brings up the create team view
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        NSLog("You selected cell number: \(indexPath.row)!")
//        self.performSegueWithIdentifier("yourIdentifier", sender: self)
        var parentVC = parentViewController!
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell?.textLabel?.text == "Create New Team!" {
            parentVC.performSegueWithIdentifier("goToCreateTeam", sender: self)
        } else {
            currentRow = indexPath.row
            self.joinButton.hidden = false;
            self.detailButton.hidden = false;
        }
        
    }
}


