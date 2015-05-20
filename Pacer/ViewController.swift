
import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var Cell: UITableViewCell!
    @IBOutlet var totalView: UIView!
    
    var searchActive : Bool = false
    var data = ["San Francisco","New York","San Jose","Chicago","Los Angeles","Austin","Seattle"]
    var filtered:[String] = []
    var SIZE = UIScreen.mainScreen().bounds.width; // sets width
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame.size.width = SIZE;
        tableView.frame.size.width = SIZE;
        
        /* Setup delegates */
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
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
        
        filtered = data.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return data.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = Cell;
        if(searchActive){
            cell.textLabel?.text = filtered[indexPath.row]
        } else {
            cell.textLabel?.text = data[indexPath.row];
        }
    
        return cell;
    }
}