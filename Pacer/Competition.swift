
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
    //the objectid of the object in the cloud
    var ObjectID : String
    
    //the pfobject in the cloud
    var Object : PFObject
    
    //the PFquery for the class
    var query = PFQuery(className: "Competition")
    
    /**
     * the testing init statement
     * @param name the name of the competition
     * @param team1 the first team of the object (the team that creates the challenge)
     * @param team2 the second team of the object
     */
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
    
    /**
     * the init statement using a PFObject
     */
    init(Competition : PFObject)
    {
        self.Object = Competition
        self.Object.save()
        self.ObjectID = Object.objectId!
    }
    
    /**
      * pushes the object to the cloud
     */
    func pushObject(ObjectID: String)
    {
        query.getObjectInBackgroundWithId(ObjectID) {
            (compObject: PFObject?, error: NSError?) -> Void in
            if error != nil {
                println(error)
            } else if let compObject = compObject {
                compObject["name"] = self.Object["name"]
                compObject["team1"] = self.Object["team1"]
                compObject["team2"] = self.Object["team2"]
            }
        }
    }
    
}