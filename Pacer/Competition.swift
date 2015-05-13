
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
    
    init(name : String, Team1 : Team, Team2 : Team)
    {
        ObjectID = ""
        let compObject = PFObject(className: "Competition")
        compObject["name"] = name
        compObject["team1"] = Team1
        compObject["team2"] = Team2
        
        compObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success)
            {
                compObject.objectId! = self.ObjectID
                println("Object has been saved.")
            }
            else
            {
                print("we lost boyz")
            }
        }
    }
    
}