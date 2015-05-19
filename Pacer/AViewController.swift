

import UIKit
import Parse

func labelSize(inputLabel: UILabel){
    let maxSize: CGSize  = CGSizeMake(187, CGFloat.max)
    var size: CGSize = inputLabel.sizeThatFits(maxSize)
    var rect: CGRect = inputLabel.frame
    rect.size.height = size.height
    inputLabel.frame = rect
}

class AViewController: UIViewController {
    
    
    @IBOutlet weak var welcome: UILabel!
   
    @IBAction func logoutPressed(sender: UIButton) {
        PFUser.logOutInBackground()
        var parentVC = parentViewController!
        parentVC.performSegueWithIdentifier("goToLogin", sender: parentVC)
    }
    
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(true)
        dispatch_async(dispatch_get_main_queue(), {
            self.welcome.text = PFUser.currentUser() == nil ? "" : "Hello \(PFUser.currentUser()!.username!)"
            labelSize(self.welcome)
        })
    }
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //var user = PFUser.currentUser()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}