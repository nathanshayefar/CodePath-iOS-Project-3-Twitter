//
//  HamburgerViewController.swift
//  3_Twitter
//
//  Created by Nathan Shayefar on 3/1/15.
//  Copyright (c) 2015 Nathan Shayefar. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var menuView: UITableView!
    
    private var originalMenuViewCenter: CGPoint?
    private var minX: CGFloat?
    private var maxX: CGFloat?
    
    private var menuActions = ["Profile", "Home Timeline", "Mentions"]
    
    private var viewControllers: [UIViewController]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeViewControllers()
        
        self.menuView.dataSource = self
        self.menuView.delegate = self
        
        self.minX = -menuView.bounds.width / 2
        self.maxX = menuView.bounds.width / 2
        
        hideMenu(false)
    }
    
    func initializeViewControllers() {
        // Storyboarding
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let profileViewController = storyboard.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
        profileViewController.setUser(User.currentUser!)
        
        let homeTimelineViewController = storyboard.instantiateViewControllerWithIdentifier("HomeTimelineViewController") as!HomeTimelineViewController
        homeTimelineViewController.setTimelineType(TimelineType.Home)
        
        let mentionsViewController = storyboard.instantiateViewControllerWithIdentifier("HomeTimelineViewController") as! HomeTimelineViewController
        mentionsViewController.setTimelineType(TimelineType.Mentions)
        
        viewControllers = [profileViewController, homeTimelineViewController, mentionsViewController]
        self.activeViewController = viewControllers?.first
    }
    
    var activeViewController: UIViewController? {
        didSet(previousViewController) {
            if let oldViewController = previousViewController {
                oldViewController.willMoveToParentViewController(nil)
                oldViewController.view.removeFromSuperview()
                oldViewController.removeFromParentViewController()
            }
            if let newViewController = activeViewController {
                self.addChildViewController(newViewController)
                self.view.frame = self.contentView.bounds
                self.view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
                self.contentView.addSubview(newViewController.view)
                newViewController.didMoveToParentViewController(self)
            }
        }
    }
    
    // TableView
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = menuActions[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.activeViewController = viewControllers?[indexPath.row]
        hideMenu(false)
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    // Gesture detector

    @IBAction func onPanContainerView(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        switch sender.state {
        
        case .Began:
            originalMenuViewCenter = self.menuView.center
        
        case .Changed:
            self.menuView.center.x = min(self.originalMenuViewCenter!.x + translation.x, self.maxX!)

        case .Ended:
            if velocity.x > 0 {
                self.showMenu(true)
            } else {
                self.hideMenu(true)
            }
        
        default:
            println("Unhandled pan gesture.")
        }
    }
    
    private func showMenu(animated: Bool) {
        let timeInterval = animated ? 0.4 : 0
        
        UIView.animateWithDuration(timeInterval, animations: {
            self.menuView.center.x = self.maxX!
            self.menuView.alpha = 1
            
            self.view.layoutIfNeeded()
        })
    }
    
    private func hideMenu(animated: Bool) {
        let timeInterval = animated ? 0.4 : 0
        
        UIView.animateWithDuration(timeInterval, animations: {
            self.menuView.center.x = self.minX!
            self.menuView.alpha = 0
            
            self.view.layoutIfNeeded()
        })
    }
}
