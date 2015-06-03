
import UIKit
import Parse


class PleaseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var challengeBtn: UIButton!
    @IBOutlet weak var detailsBtn: UIButton!
    
    var mainParseManager:ParseManager = ParseManager()
    var searchActive: Bool = false
    var data: [String] = []
    var filtered:[String] = []
    var SIZE = UIScreen.mainScreen().bounds.width; // sets width
    
    var currentRow: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainParseManager.pullTeams({(success: Bool!, error : NSError!) -> Void in
            if success == true
            {
                self.data = self.mainParseManager.teamNames
                NSLog("This is how many teams we found: \(self.data.count)")
                self.tableView.reloadData()
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
        
        self.tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
        self.tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        self.tableView.reloadData()
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
        if(filtered.count == 0)
        {
            searchActive = false;
        }
        else
        {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("You DE-selected cell number: \(indexPath.row)!")
        self.challengeBtn.hidden = true;
        self.detailsBtn.hidden = true;
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if(!searchActive)
        {
            return data.count
        }
        else
        {
            return filtered.count;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: nil)
        if(!searchActive)
        {
            println("SEARCH IS NOT ACTIVE")
            cell.textLabel?.text = data[indexPath.row]
            //            cell.textLabel?.text = "test"
            var str = String(stringInterpolationSegment: mainParseManager.teamarray[indexPath.row].Object["score"])
            cell.detailTextLabel?.text = str.substringWithRange(Range<String.Index>(start: advance(str.startIndex, 9), end: advance(str.endIndex, -1)))
            return cell
        }
        else
        {
            
            println("SEARCH IS ACTIVE")
            if(indexPath.row < filtered.count)
            {
                // gotta remove "Optional(" and ")"
                cell.textLabel?.text = filtered[indexPath.row]
                var str = String(stringInterpolationSegment: mainParseManager.teamarray[indexPath.row].Object["score"])
                cell.detailTextLabel?.text = str.substringWithRange(Range<String.Index>(start: advance(str.startIndex, 9), end: advance(str.endIndex, -1)))
            }
        }
        
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        NSLog("You selected cell number: \(indexPath.row)!")
        self.challengeBtn.hidden = false;
        self.detailsBtn.hidden = false;
        currentRow = indexPath.row
    }
    @IBAction func challengeBtnClick(sender: AnyObject) {
        //var parentVC = parentViewController!
        var passed = parentViewController as! ContainerViewController
        var teamName: String = data[currentRow]
        var teamQuery: PFQuery = PFQuery(className: "Team")
        teamQuery.whereKey("name", equalTo: teamName)
        var teamList: Array = teamQuery.findObjects()!
        for obj in teamList {
            passed.passedTeam = Team(team: obj as! PFObject)
            break
        }

        passed.performSegueWithIdentifier("goToChallengeTeam", sender: self)
    }
    
    @IBAction func detailsBtnClick(sender: AnyObject) {
        var parentVC = parentViewController!
        parentVC.performSegueWithIdentifier("goToTeamDetails", sender: self)
    }
    
}


