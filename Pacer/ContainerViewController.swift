// Neil Xu & Calvin Tong
// 5/27/2015
//
//
//
//
//


import UIKit
import Parse

//View controller for the scroll view that acts as our Snapchat-esque main page
class ContainerViewController: UIViewController {
    
    //Team object passed to here from subview so it can be put in segues
    var passedTeam: Team!
    
    // Outlet used in storyboard
    @IBOutlet var scrollView: UIScrollView?;
    
    //Number of views/pages in the container view
    var pages: CGFloat = 3;
    
    //Gets the width of the phone screen to be used later
    var WIDTH = UIScreen.mainScreen().bounds.width
    
    //Gets the height of the phone screen to be used later
    var HEIGHT = UIScreen.mainScreen().bounds.height;
    
    //Checks if there is a user logged in on the phone or not. If not, it pulls up the login screen.
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(true)
        if (PFUser.currentUser() == nil){
            self.performSegueWithIdentifier("goToLogin", sender: self)
        }
    }
    
    //Loads the subviews inside the big scroll view
    override func viewDidLoad() {
        super.viewDidLoad();
        
        //Sets frame of scroll view to be the size of the phone screen
        self.view.frame.size.width = WIDTH;
        self.view.frame.size.height = HEIGHT;
        
        //Constructs view controllers for handling the subviews
        var AVc :AViewController =  AViewController(nibName: "AViewController", bundle: nil);
        var ProfileVc :ViewController =  ViewController(nibName: "ViewController", bundle: nil);
        var PleaseVc: PleaseViewController = PleaseViewController(nibName: "PleaseViewController", bundle: nil);
        
        //Adds the subviews and view controllers to this scroll view
        self.addChildViewController(PleaseVc);
        self.scrollView!.addSubview(PleaseVc.view);
        PleaseVc.didMoveToParentViewController(self);
        
        self.addChildViewController(ProfileVc);
        self.scrollView!.addSubview(ProfileVc.view);
        ProfileVc.didMoveToParentViewController(self);

        self.addChildViewController(AVc);
        self.scrollView!.addSubview(AVc.view);
        AVc.didMoveToParentViewController(self);
        
        //Sets pages to number of child view controllers
        pages = CGFloat(childViewControllers.count)
        
        //Sets the starting point for placing the first view frame
        AVc.view.frame.origin.x = 0;
        AVc.view.frame.origin.y = 0;

        ProfileVc.view.frame.origin.x = WIDTH;
        PleaseVc.view.frame.origin.x = WIDTH * 2;
        
        //Sets the container view size to encompass all 3 views
        var scrollWidth: CGFloat  = pages * WIDTH;
        var scrollHeight: CGFloat  = self.view.frame.size.height
        self.scrollView!.contentSize = CGSizeMake(scrollWidth, scrollHeight);
        self.scrollView!.sizeToFit()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToTeamDetails"{
            var passed = segue.destinationViewController as! TeamDetailsViewController
            passed.team = self.passedTeam
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

