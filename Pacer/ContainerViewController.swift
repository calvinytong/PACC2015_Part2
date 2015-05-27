//
//  ViewController.swift
//  Pacer
//
//  Created by Joseph Zhong on 5/5/15.
//  Copyright (c) 2015 Joseph Zhong. All rights reserved.
//


import UIKit
import Parse

class ContainerViewController: UIViewController {
    
    // Outlet used in storyboard
    @IBOutlet var scrollView: UIScrollView?;
    var pages: CGFloat = 3;
    var WIDTH = UIScreen.mainScreen().bounds.width; // sets width
    var HEIGHT = UIScreen.mainScreen().bounds.height; // sets height
    
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(true)
        if (PFUser.currentUser() == nil){
            self.performSegueWithIdentifier("goToLogin", sender: self)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.view.frame.size.width = WIDTH;
        self.view.frame.size.height = HEIGHT;
        
        // 1) Create the three views used in the swipe container view
        var AVc :AViewController =  AViewController(nibName: "AViewController", bundle: nil);
        var ProfileVc :ViewController =  ViewController(nibName: "ViewController", bundle: nil);
        var CVc :CViewController =  CViewController(nibName: "CViewController", bundle: nil);
        var LeaderboardVc: LeaderboardTableViewController = LeaderboardTableViewController(nibName: "LeaderboardTableViewController", bundle: nil);
        var PleaseVc: PleaseViewController = PleaseViewController(nibName: "PleaseViewController", bundle: nil);
        
        // 2) Add in each view to the container view hierarchy
        //    Add them in opposite order since the view hieracrhy is a stack
/*
        self.addChildViewController(CVc);
        self.scrollView!.addSubview(CVc.view);
        CVc.didMoveToParentViewController(self);

        
        self.addChildViewController(LeaderboardVc);
        self.scrollView!.addSubview(LeaderboardVc.view);
        LeaderboardVc.didMoveToParentViewController(self);
        */
  
        self.addChildViewController(PleaseVc);
        self.scrollView!.addSubview(PleaseVc.view);
        PleaseVc.didMoveToParentViewController(self);
        
        self.addChildViewController(ProfileVc);
        self.scrollView!.addSubview(ProfileVc.view);
        ProfileVc.didMoveToParentViewController(self);

        self.addChildViewController(AVc);
        self.scrollView!.addSubview(AVc.view);
        AVc.didMoveToParentViewController(self);

        pages = CGFloat(childViewControllers.count)
        
        // 3) Set up the frames of the view controllers to align
        //    with eachother inside the container view
        
        AVc.view.frame.origin.x = 0;
        AVc.view.frame.origin.y = 0;

//        ProfileVc.view.frame.origin.x = AVc.view.frame.size.width
        ProfileVc.view.frame.origin.x = WIDTH;
        //ProfileVc.view.frame.origin.x = 320;
//        ProfileVc.view.frame.origin.x = 375;

        //CVc.view.frame.origin.x = 640;
//        CVc.view.frame.origin.x = AVc.view.frame.size.width + ProfileVc.view.frame.size.width
        //CVc.view.frame.origin.x = WIDTH * 2;
        
        //LeaderboardVc.view.frame.origin.x = WIDTH * 2;
        
        PleaseVc.view.frame.origin.x = WIDTH * 2;
        
        // 4) Finally set the size of the scroll view that contains the frames
        
        var scrollWidth: CGFloat  = pages * WIDTH;
        var scrollHeight: CGFloat  = self.view.frame.size.height
        self.scrollView!.contentSize = CGSizeMake(scrollWidth, scrollHeight);
        self.scrollView!.sizeToFit()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
}

