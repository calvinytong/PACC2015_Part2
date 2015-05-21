

import UIKit
import Parse


class AViewController: UIViewController, UITableViewDataSource{
    
    @IBOutlet weak var welcome: UILabel!
    var SIZE = UIScreen.mainScreen().bounds.width; // sets width
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a 
        self.view.frame.size.width = SIZE;
        //updateUserInfo()
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
            self.welcome.text = PFUser.currentUser() == nil ? "" : "Hello \(PFUser.currentUser()!.username!)"
            self.labelSize(self.welcome)
        })
        
    }
    
    @IBOutlet weak var userTable: UITableView!
    
    var keyTable:[String] = []
    //var introDict = Dictionary<String, String>()
    var valueDict = Dictionary<String, String>()
    
    func updateUserInfo(){
        var userProfile = PFUser.currentUser()!["profile"] as? PFObject
        
        if (userProfile == nil){
            keyTable.append("what")
            valueDict.updateValue("fucking hell", forKey: "what")
        } else {
            var userPlayer: Player = Player(player: userProfile!)
            for key in userPlayer.queryList {
                keyTable.append(key)
                valueDict.updateValue(userProfile![key]! as! String, forKey: key)
                println(key)
                
            }
            keyTable.append("what2")
            valueDict.updateValue("fucking hell2", forKey: "what2")
            println("Done with keys")
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keyTable.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value2, reuseIdentifier: nil)
        
        let rowTitle = keyTable[indexPath.row]
        let rowContent = valueDict[rowTitle]
        
        cell.textLabel?.text = "\(rowTitle):"
        cell.detailTextLabel?.text = "fuck fuck fuck fuck fuck \(rowContent)"
        return cell
    }
}