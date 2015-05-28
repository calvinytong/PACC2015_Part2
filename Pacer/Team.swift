
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
    //the PFObjectarray holding the players
    var players : [PFObject]
    
    //the objectID of the object on the cloud
    var ObjectID : String
    
    //the PFobject in the cloud
    var Object : PFObject
    
    //the query for the parse cloud class team
    var query = PFQuery(className: "Team")
    
    /**
    * the init using name (mostly for testing)
    * @param name the name of the player object
    */
    init(name : String)
    {
        players = [PFObject]()
        ObjectID = ""
        self.Object = PFObject(className: "Team")
        self.Object["name"] = name
        self.Object["players"] = self.players
        self.Object["score"] = 0
        self.Object.save()
        self.ObjectID = self.Object.objectId!
        println(self.ObjectID)
    }
    
    /**
    * init using a PFobject. Sets everything up
    * @param team the PFobject to be turned into a local team object
    */
    init(team : PFObject)
    {
        self.players = [PFObject]()
        self.ObjectID = ""
        self.Object = team
        if let temparray : NSArray = self.Object["players"] as? NSArray
        {
            for p in temparray
            {
                self.players.append(p as! PFObject)
            }
        }
        
        Object.save()
        self.ObjectID = Object.objectId!
    }
    
    
    /**
    * pushes the score to the cloud
    */
    func pushScore()
    {
        self.Object["score"] = calcScore()
        pushObject()
    }
    
    /**
    * pushes the current local object to the cloud
    */
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
    
    /**
    * calculates the total score of the team
    * @return tempscore the score of the team
    */
    private func calcScore() -> Int
    {
        var tempscore : Int = 0
        for p in players
        {
            tempscore = tempscore + (p["score"] as! Int)
        }
        return tempscore
    }    
}