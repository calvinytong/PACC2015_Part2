
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
    var players : [Player]
    var teamScore : NSInteger
    var ObjectID : String
    var query = PFQuery(className: "Team")
    
    init(name : String)
    {
        players = [Player]()
        ObjectID = ""
        teamScore = 0
        let teamObject = PFObject(className: "Team")
        teamObject["name"] = name
        teamObject["players"] = self.players
        teamObject["score"] = self.teamScore
        teamObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if (success)
            {
                teamObject.objectId! = self.ObjectID
                println("Object has been saved.")
            }
            else
            {
                print("team iz bad boyz")
            }
        }
    }
    
    func addPlayerToTeam(player : Player)
    {
        self.players.append(player)
        query.getObjectInBackgroundWithId(ObjectID) {
            (teamObject: PFObject?, error: NSError?) -> Void in
            if error != nil {
                println(error)
            } else if let teamObject = teamObject {
                teamObject["score"] = self.players
                teamObject.saveInBackground()
            }
        }
    }
    
    func pushScore()
    {
        self.teamScore = calcScore()
        query.getObjectInBackgroundWithId(ObjectID) {
            (teamObject: PFObject?, error: NSError?) -> Void in
            if error != nil {
                println(error)
            } else if let teamObject = teamObject {
                teamObject["score"] = self.teamScore
                teamObject.saveInBackground()
            }
        }
        
        
    }
    
    func calcScore() -> NSInteger
    {
        var tempscore = 0
        for p in players
        {
            tempscore = tempscore + p.score
        }
        return tempscore
    }
    
}