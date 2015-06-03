
//  ParseManager.swift
//  Pacer
//
//  Created by Calvin on 5/11/15.
//  Copyright (c) 2015 Joseph Zhong. All rights reserved.
//

import Foundation
import Parse
import Bolts

class ParseManager
{
    //these are global variables because of the block execution sync problem where code executes before the array is populated. These eliminates returns
    var temparray : [PFObject] = [PFObject]()
    var teamarray : [Team] = [Team]()
    var teamNames:[String] = []
    var compArray : [Competition] = [Competition]()

    //swift has weird stuff. Can't just do a static class (wtf apple)
    init()
    {}
    
    /**
     * pulls a player object from the cloud
     * @param id the object id of the PFobject
     * @return the player object
     */
    func pullPlayer(id : String) -> Player
    {
        return Player(player: pullObject(id, type: "Player"))
    }
    
    /**
     * pulls a team objectfrom the cloud
     * @param id the object id of the PFobject
     * @return the team object
    */
    func pullTeam(id : String) -> Team
    {
        return Team(team : pullObject(id, type: "Team"))
    }
    
    /**
    * pulls a competition off of the cloud
    * @param id the object id of the PFobject
    * @return the competition object
    */
    func pullComp(id : String) -> Competition
    {
        return Competition(Competition: pullObject(id, type: "Competition"))
    }
    
    /**
     * pulls all of the teams off of the cloud and stores them in the teamarray
     * @param completionHandler wraps the method in a call back making sure that the networking block methods execute in the correct order
     */
    func pullTeams(completionHandler: (Bool!, NSError!) -> Void)
    {
        self.teamarray = []
        self.teamNames = []
        var completed = false
        pullAllObjects("Team", completionHandler: {
            (success: Bool!, error: NSError!) -> Void in
            if success == true
            {
                for o in self.temparray
                {
                    self.teamarray.append(Team(team: o))
                    self.teamNames.append(o["name"] as! String)
                }
                completionHandler(true, nil)
            }
        })
        
    }
    
    func pullComps(completionHandler: (Bool!, NSError!) -> Void)
    {
        self.teamarray = []
        self.teamNames = []
        var completed = false
        pullAllObjects("Competition", completionHandler: {
            (success: Bool!, error: NSError!) -> Void in
            if success == true
            {
                for o in self.temparray
                {
                    self.compArray.append(Competition(Competition: o))
                }
                completionHandler(true, nil)
            }
        })
        
    }
    
    /**
    * private function to pull a single object off of the cloud
    * @param id the object id of the PFobject
    * @param type the class the object is to be pulled from
    * @return the pfobject
    */
    private func pullObject(id : String, type : String) -> PFObject
    {
        //var tempobj : PFObject = PFObject()
        var query = PFQuery(className: type)
        return query.getObjectWithId(id)!
    }
    
    /**
    * pulls all objects of class type from the cloud and puts them in the temp array
    * @param type the class of objects to be pulled
    * @param completionHandler the wrapper to help methods execute in the correct order
    */
    private func pullAllObjects(type : String, completionHandler: (Bool!, NSError!) -> Void)
    {
        
        var query = PFQuery(className: type)
        //gets first 100 objects
        if(type == "Team")
        {
            query.orderByDescending("score")
        }
         query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) Teams.")
                // Do something with the found objects
                //println(objects)

                if let objectarray : [PFObject] = objects as? [PFObject] {
                    //println(objectarray)
                    self.temparray = objectarray
                    //println(temparray)
                    completionHandler(true, nil)
                }
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
                completionHandler(false, nil)
            }
        }
        //println("I EXITED")
    }
    

    
}