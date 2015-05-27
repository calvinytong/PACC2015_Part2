//
//  PedometerHelper.swift
//  PedometerTest4
//
//  Created by Calvin on 5/17/15.
//  Copyright (c) 2015 Calvin. All rights reserved.
//

import Foundation
import CoreMotion

class PedometerHelper
{
    // the CMPedometer Object
    let pedometer : CMPedometer
    
    // the number of steps the user has taken
    var steps : NSInteger
    
    //boolean telling if the pedometer is available on the current phone (iphone 5s and above)
    var available : Bool
    
    //the date that the object started collecting data
    var startdate : NSDate
    
    /**
     * the init statment sets steps to and date to current date
     */
    init()
    {
        self.pedometer = CMPedometer()
        self.steps = 0
        self.available = true
        //returns current date
        self.startdate = NSDate()
    }
    
    /**
     * starts the collection of data collection will continue until end collection is called
     */
    func startCollection()
    {
        self.startdate = NSDate()
        if(CMPedometer.isStepCountingAvailable())
        {
            self.pedometer.startPedometerUpdatesFromDate(NSDate()) { (data: CMPedometerData!, error) -> Void in
                if(error == nil)
                {
                    println("gucci")
                    self.steps = data.numberOfSteps as NSInteger
                    println(self.steps)
                }
            }
        }
        else
        {
            available = false
        }

    }
    
    /**
     * ends the data collection
     */
    func endCollection()
    {
        pedometer.stopPedometerUpdates()
    }
    
}