// Leaderboard


import UIKit
import Parse


class CViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var detailsBtn: UIButton!
    @IBOutlet weak var challengeBtn: UIButton!
    
    
    var searchActive : Bool = false
    var data:[PFObject]!
    var filtered:[PFObject]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            self.data = results as? [PFObject]
            self.tableView.reloadData()
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.data != nil){
            return self.data.count
        }
        return 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: nil)
        let obj = self.data[indexPath.row]
        cell.textLabel!.text = obj["text"] as? String
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
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        search(searchText: searchText)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        NSLog("You selected cell number: \(indexPath.row)!") // WTF THIS WAS WORKING A SECOND AGO
    }
    
    @IBAction func challengeClick(sender: AnyObject) {
        // check if team exists -> sends challenge
    }

    @IBAction func detailsClick(sender: AnyObject) {
        // check if team exists -> navigates to info page
    }
}
