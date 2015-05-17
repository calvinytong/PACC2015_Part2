
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
    var score : NSInteger
    var ObjectID : String
    var query = PFQuery(className:"Player")
    var Object : PFObject
    var pedometerHelper : PedometerHelper
    
    init(name : String)
    {
        self.pedometerHelper = PedometerHelper()
        self.score = 0
        self.ObjectID = ""
        self.Object = PFObject(className: "Player")
        Object["name"] = name
        Object["team"] = ""
        Object["score"] = self.score
        
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
    }
    
    func pushScore()
    {
        query.getObjectInBackgroundWithId(ObjectID) {
            (playerObject: PFObject?, error: NSError?) -> Void in
            if error != nil {
                println(error)
            } else if let playerObject = playerObject {
                playerObject["score"] = self.score
                playerObject.saveInBackground()
                self.Object = playerObject
            }
            
        }
        
    }
    
    func updateScore()
    {
        self.score = self.pedometerHelper.steps
        pushScore()
    }
    
    func joinTeam(teamName : String)
    {
        query.getObjectInBackgroundWithId(ObjectID) {
            (playerObject: PFObject?, error: NSError?) -> Void in
            if error != nil {
                println(error)
            } else if let playerObject = playerObject {
                playerObject["team"] = teamName
                playerObject.saveInBackground()
                self.Object = playerObject
            }
            
        }
        pedometerHelper.startCollection()
    }
    
}