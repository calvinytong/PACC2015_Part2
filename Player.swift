
//  Player.swift
//  ParseTest
//
//  Created by Calvin on 5/11/15.
//  Copyright (c) 2015 Calvin. All rights reserved.
//

import Foundation
import Parse

class Player
{
    var ObjectID : String
    var Object : PFObject
    var pedometerHelper : PedometerHelper
    var query = PFQuery(className:"Player")
    let queryList: [String] = ["name", "team", "score"]
    
    init(name : String)
    {
        self.pedometerHelper = PedometerHelper()
        self.ObjectID = ""
        self.Object = PFObject(className: "Player")
        Object["name"] = name
        Object["team"] = ""
        Object["score"] = 0
        
        Object.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
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
        pushObject()
    }
    
    init(player : PFObject)
    {
        self.pedometerHelper = PedometerHelper()
        self.ObjectID = player.objectId!
        var userQuery = PFQuery(className: "Player")
        var userPlayer: PFObject = userQuery.getObjectWithId(self.ObjectID)!
        self.Object = userPlayer
    }
    
    
    
    
    func updateScore()
    {
        self.Object["score"] = self.pedometerHelper.steps
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
                playerObject["team"] = self.Object["team"]
                playerObject["score"] = self.Object["score"]
            }
            
        }
    }
    
    func joinTeam(teamID : String)
    {
        self.Object["team"] = teamID
        addPlayerToTeam(teamID)
        pushObject()
        pedometerHelper.startCollection()
    }
    
    func addPlayerToTeam(id : String)
    {
        var query = PFQuery(className:"Team")
        query.getObjectInBackgroundWithId(id) {
            (teamObject: PFObject?, error: NSError?) -> Void in
            if error != nil {
                println(error)
            } else if let teamObject = teamObject {
                teamObject.addObject(self.Object, forKey: "players")
                teamObject.saveInBackground()
            }
            else
            {
                println("failed for other reasons")
            }
        }
    }
    
}