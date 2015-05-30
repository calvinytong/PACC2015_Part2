// Calvin Tong & Neil Xu
// 5/27/2015
//
//

import Foundation
import UIKit
import Parse

//View controller for the sign up page that pops up
class signUpViewController : UIViewController {
    //Outlets that lets me get the text from a bunch of entry fields.
    @IBOutlet weak var createUsername: UITextField!
    @IBOutlet weak var createPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var createEmail: UITextField!
    
    //When the background is tapped, it disables the keyboard/editing of entry fields
    @IBAction func backTapped(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
    
    //Creates an user account when the "Done" button is tapped
    @IBAction func donePress(sender: UIButton){
        if createUsername.text.uppercaseString.rangeOfString("JOSEPH") != nil{
            var failAlert: UIAlertView = UIAlertView()
            failAlert.title = "Error Creating Account"
            failAlert.message = "Plz no 322"
            failAlert.addButtonWithTitle("This is a text box do not press.")
            failAlert.show()
        } else {
            createLogin()
        }
    }
    
    //Dismisses the sign up view to go back to the login view
    @IBAction func backToLoginPressed(sender: UIButton){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Creates a user account from the input text fields.
    func createLogin() {
        var user = PFUser()
        user.username = createUsername.text
        user.password = createPassword.text
        user.email = createEmail.text
        let userplayer = Player(name : createUsername.text)
        user["profile"] = userplayer.Object
        
        
        user.signUpInBackgroundWithBlock {
            //Throws error if account creation is unsuccessful
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo?["error"] as! String?
                var failAlert: UIAlertView = UIAlertView()
                failAlert.title = "Error Creating Account"
                failAlert.message = errorString!
                failAlert.addButtonWithTitle("Try Again")
                failAlert.show()
            } else {
                
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
}