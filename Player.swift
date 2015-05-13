
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
    
    init(name : String)
    {
        self.score = 0
        self.ObjectID = ""
        let playerObject = PFObject(className: "Player")
        playerObject["name"] = name
        playerObject["team"] = ""
        playerObject["score"] = self.score
        
        playerObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success)
            {
                playerObject.objectId! = self.ObjectID
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
            }
        }
        
    }
    
    func updateScore()
    {
        //to implement get pedometer to push score to student object
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
            }
        }
    }
    
}