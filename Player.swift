
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
    //the objectID of the PFObject on the cloud
    var ObjectID : String
    
    //the PFobject
    var Object : PFObject
    
    //the pedometer helper that deals with the pedometer module
    var pedometerHelper : PedometerHelper
    
    //the query for the parse class
    var query = PFQuery(className:"Player")
    
    var teamquery = PFQuery(className: "Team")
    
    /**
     *  init statement with name (mostly for testing). Sets up pedometer helper and saves object to the cloud.
     * @param name the name of the player to be implemented
     */
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
        //pushObject()
    }
    
    /**
     * init statement with a PFObject
     * @param player the PFobject to be turned into a player
     */
    init(player : PFObject)
    {
        self.pedometerHelper = PedometerHelper()
        self.ObjectID = player.objectId!
        var userQuery = PFQuery(className: "Player")
        var userPlayer: PFObject = userQuery.getObjectWithId(self.ObjectID)!
        self.Object = userPlayer
    }
    
    
    
    /**
      * updates the score field of the PFobject on the cloud
     */
    func updateScore()
    {
        self.Object["score"] = self.pedometerHelper.steps
        pushObject()
    }
    
    /**
     * pushes the current player object stored locally to the cloud
     */
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
    
    /**
     * joins the player to team t
     * @param t the team object to join
     */
    func joinTeam(t : Team) -> Bool
    {
        self.Object["team"] = t.Object
        if addPlayerToTeam(t)
        {
             pushObject()
             //start collecting when a team is joined
             pedometerHelper.startCollection()
             return true
        }
       else
        {
            return false
        }


    }
    
    /**
    * private helper method that adds a player to team t
    * @param t the team object to join
    */
    private func addPlayerToTeam(t: Team) -> Bool
    {
        var success : Bool = true
        teamquery.getObjectInBackgroundWithId(t.ObjectID) {
            (teamObject: PFObject?, error: NSError?) -> Void in
            if error != nil {
                println(error)
                success = false
                
            } else if let teamObject = teamObject {
                teamObject.addObject(self.Object, forKey: "players")
                teamObject.saveInBackground()
                self.Object["team"] = teamObject
            }
            else
            {
                println("failed for other reasons")
            }
        }
        t.players.append(self.Object)
        return success
    }
    
    func leaveTeam()
    {
        var pf : PFObject = self.Object["team"] as! PFObject
        teamquery.getObjectInBackgroundWithId(pf.objectId!){
            (teamObject: PFObject?, error: NSError?) -> Void in
            if error != nil {
                println(error)
            }
            else if let teamObject = teamObject
            {
                teamObject.removeObject(self.Object, forKey: "players")
            }
            else
            {
                println("failed for other reasons")
            }
            
        }
        self.Object["team"] = ""
        self.pushObject()
        
    }
    
}