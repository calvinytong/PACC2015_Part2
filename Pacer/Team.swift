
//  Team.swift
//  Pacer
//
//  Created by Calvin on 5/11/15.
//  Copyright (c) 2015 Joseph Zhong. All rights reserved.
//

import Foundation
import Parse

class Team
{
    var players : [PFObject]
    var ObjectID : String
    var Object : PFObject
    var query = PFQuery(className: "Team")
    
    init(name : String)
    {
        players = [PFObject]()
        ObjectID = ""
        self.Object = PFObject(className: "Team")
        self.Object["name"] = name
        self.Object["players"] = self.players
        self.Object["score"] = 0
        self.Object.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success)
            {
                self.Object.objectId! = self.ObjectID
                println("Object has been saved.")
            }
            else
            {
                print("team iz bad boyz")
            }
        }
    }
    
    init(team : PFObject)
    {
        
        self.Object = team
        self.ObjectID = self.Object.objectId!
        self.players = [PFObject]()
        var temparray : NSArray = self.Object["players"] as! NSArray
        for p in temparray
        {
            self.players.append(p as! PFObject)
        }
        
    }
    
    
    func pushScore()
    {
       self.Object["score"] = calcScore()
       pushObject()
        
    }
    
    func pushObject()
    {
        query.getObjectInBackgroundWithId(ObjectID) {
            (playerObject: PFObject?, error: NSError?) -> Void in
            if error != nil {
                println(error)
            } else if let playerObject = playerObject {
                playerObject["name"] = self.Object["name"]
                playerObject["players"] = self.Object["players"]
                playerObject["score"] = self.Object["score"]
            }
            
        }

    }
    
    func calcScore() -> Int
    {
        var tempscore : Int = 0
        for p in players
        {
            tempscore = tempscore + (p["score"] as! Int)
        }
        return tempscore
    }
    
}