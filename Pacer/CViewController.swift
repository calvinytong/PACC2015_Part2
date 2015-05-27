// Leaderboard


import UIKit
import Parse


class CViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var detailsBtn: UIButton!
    @IBOutlet weak var challengeBtn: UIButton!
    
    
    var searchActive : Bool = false
    var mainParseManager: ParseManager = ParseManager()
    
    var data:[String]!
    var filtered:[Team]!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        mainParseManager.pullTeams({(success: Bool!, error : NSError!) -> Void in
            if success == true{
                self.data = self.mainParseManager.teamNames
                println(self.data.count)
            }
            
        })
        searchBar.delegate = self
        search()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func search(searchText: String? = nil){
        let query = PFQuery(className: "Team")
        if(searchText != nil)
        {
            query.whereKey("name", containsString: searchText)
        }
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
//            self.data = (results as? [String])!
            self.tableView.reloadData()
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: nil)
        let obj = self.data[indexPath.row]
        cell.textLabel!.text = data[indexPath.row]
        return cell
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
        searchActive = false
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        search(searchText: searchText)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        NSLog("You selected cell number: \(indexPath.row)!")
        if(true)
        {
            NSLog("hello joseph");
        }
    }
}
