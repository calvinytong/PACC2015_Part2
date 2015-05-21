
//  Competition.swift
//  Pacer
//
//  Created by Calvin on 5/11/15.
//  Copyright (c) 2015 Joseph Zhong. All rights reserved.
//

import Foundation
import Parse

class Competition
{
    
    var ObjectID : String
    var Object : PFObject
    
    init(name : String, Team1 : Team, Team2 : Team)
    {
        ObjectID = ""
        self.Object = PFObject(className: "Competition")
        self.Object["name"] = name
        self.Object["team1"] = Team1.Object
        self.Object["team2"] = Team2.Object
        
        self.Object.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success)
            {
                self.Object.objectId! = self.ObjectID
                println("Object has been saved.")
            }
            else
            {
                print("we lost boyz")
            }
        }
    }
    
}