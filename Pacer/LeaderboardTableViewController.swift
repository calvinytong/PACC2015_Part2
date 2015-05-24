//
//  LeaderboardTableViewController.swift
//  Pacer
//
//  Created by Joseph Zhong on 5/23/15.
//  Copyright (c) 2015 Joseph Zhong. All rights reserved.
//

import UIKit
import Parse

class LeaderboardTableViewController: UITableViewController,UISearchBarDelegate {
        
    @IBOutlet weak var searchBar: UISearchBar!
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
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.data != nil){
            return self.data.count
        }
        return 0
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
}
