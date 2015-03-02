//
//  HamburgerViewController.swift
//  3_Twitter
//
//  Created by Nathan Shayefar on 3/1/15.
//  Copyright (c) 2015 Nathan Shayefar. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var menuView: UITableView!
    
    private let tweetDetailSegueId = "tweetDetailSegue"
    private let composeSegueId = "composeSegue"
    private let profileSegueId = "profileSegue"
    
    private var originalMenuViewCenter: CGPoint?
    private var minX: CGFloat?
    private var maxX: CGFloat?
    
    private var menuActions = ["Profile", "Home", "Mentions"]
    
    private var navigationViewController: UINavigationController?
    private var viewControllers: [UIViewController]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeViewControllers()
        
        self.menuView.dataSource = self
        self.menuView.delegate = self
        self.menuView.layer.zPosition = 1
        self.menuView.userInteractionEnabled = true
        
        self.minX = -menuView.bounds.width / 2
        self.maxX = menuView.bounds.width / 2
        
        hideMenu(false)
    }
    
    func initializeViewControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let profileViewController = storyboard.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
        profileViewController.setUser(User.currentUser!)
        
        let homeTimelineNavigationController = storyboard.instantiateViewControllerWithIdentifier("TimelineNavigationController") as! TwitterNavigationController
        let homeVC = homeTimelineNavigationController.viewControllers[0] as! HomeTimelineViewController
        homeVC.setTimelineType(TimelineType.Home)
        
        let mentionsTimelineNavigationController = storyboard.instantiateViewControllerWithIdentifier("TimelineNavigationController") as! TwitterNavigationController
        let mentionsVC = mentionsTimelineNavigationController.viewControllers[0] as! HomeTimelineViewController
        mentionsVC.setTimelineType(TimelineType.Mentions)
        
        self.viewControllers = [profileViewController, homeTimelineNavigationController, mentionsTimelineNavigationController]
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
                newViewController.view.frame = self.contentView.bounds
                newViewController.view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
                self.contentView.addSubview(newViewController.view)
                newViewController.didMoveToParentViewController(self)
            }
        }
    }
    
    // TableView
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = menuActions[indexPath.row]
        cell.userInteractionEnabled = true
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        hideMenu(false)
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        self.activeViewController = viewControllers?[indexPath.row]
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
            self.menuView.userInteractionEnabled = true
            
            self.view.layoutIfNeeded()
        })
    }
    
    private func hideMenu(animated: Bool) {
        let timeInterval = animated ? 0.4 : 0
        
        UIView.animateWithDuration(timeInterval, animations: {
            self.menuView.center.x = self.minX!
            self.menuView.alpha = 0
            self.menuView.userInteractionEnabled = false
            
            self.view.layoutIfNeeded()
        })
    }
}
