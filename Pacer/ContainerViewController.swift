//
//  ViewController.swift
//  Pacer
//
//  Created by Joseph Zhong on 5/5/15.
//  Copyright (c) 2015 Joseph Zhong. All rights reserved.
//


import UIKit

class ContainerViewController: UIViewController {
    
    // Outlet used in storyboard
    @IBOutlet var scrollView: UIScrollView?;
    var pages: CGFloat = 3;
    
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(true)
        if (NSUserDefaults.standardUserDefaults().integerForKey("loginstatus") as Int != 1){
            //self.performSegueWithIdentifier("goToLogin", sender: self)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // 1) Create the three views used in the swipe container view
        var AVc :AViewController =  AViewController(nibName: "AViewController", bundle: nil);
//        var ProfileVc :ViewController =  ViewController(nibName: "ViewController", bundle: nil);
        var CVc :CViewController =  CViewController(nibName: "CViewController", bundle: nil);
        
        
        // 2) Add in each view to the container view hierarchy
        //    Add them in opposite order since the view hieracrhy is a stack
        self.addChildViewController(CVc);
        self.scrollView!.addSubview(CVc.view);
        CVc.didMoveToParentViewController(self);
        
  /*
        self.addChildViewController(ProfileVc);
        self.scrollView!.addSubview(ProfileVc.view);
        ProfileVc.didMoveToParentViewController(self);
    */
        
        self.addChildViewController(AVc);
        self.scrollView!.addSubview(AVc.view);
        AVc.didMoveToParentViewController(self);

        
        // 3) Set up the frames of the view controllers to align
        //    with eachother inside the container view
        var adminFrame :CGRect = AVc.view.frame;
        adminFrame.origin.x = adminFrame.width;
        CVc.view.frame = adminFrame;
//        ProfileVc.view.frame = adminFrame;
        
        
        
        // 4) Finally set the size of the scroll view that contains the frames
        var scrollWidth: CGFloat  = pages * self.view.frame.width
        var scrollHeight: CGFloat  = self.view.frame.size.height;
        self.scrollView!.contentSize = CGSizeMake(scrollWidth, scrollHeight);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
}

