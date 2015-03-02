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

    @IBOutlet weak var tableView: UITableView!
    
    private var tapGestureRecognizer: UITapGestureRecognizer?
    private var panGestureRecognizer: UIPanGestureRecognizer?
    
    private var originalMenuViewCenter: CGPoint?
    private var minX: CGFloat?
    private var maxX: CGFloat?
    
    private var menuActions = ["Profile", "Home", "Mentions"]
    
    private var navigationViewController: UINavigationController?
    private var viewControllers: [UIViewController]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeViewControllers()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.layer.zPosition = 1
        self.tableView.alpha = 0.8
        self.tableView.allowsSelection = true
        self.tableView.userInteractionEnabled = true
        
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "didTapMenu:")
        self.tableView.addGestureRecognizer(self.tapGestureRecognizer!)
        self.tapGestureRecognizer?.delegate = self
        
        self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "didPanView:")
        self.view.addGestureRecognizer(self.panGestureRecognizer!)
        
        self.minX = -tableView.bounds.width / 2
        self.maxX = tableView.bounds.width / 2
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier("HamburgerMenuCell", forIndexPath: indexPath) as! HamburgerMenuCell
        
        cell.menuOptionLabel.text = menuActions[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
    
    // Gesture detector
    
    func didTapMenu(sender: UITapGestureRecognizer) {
        let locationInView = sender.locationInView(self.tableView)
        if let indexPath = self.tableView.indexPathForRowAtPoint(locationInView) {
            hideMenu(false)
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
            
            self.activeViewController = viewControllers?[indexPath.row]
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func didPanView(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        switch sender.state {
        
        case .Began:
            self.originalMenuViewCenter = self.tableView.center
        
        case .Changed:
            self.tableView.center.x = min(self.originalMenuViewCenter!.x + translation.x, self.maxX!)

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
            self.tableView.center.x = self.maxX!
            self.tableView.alpha = 0.8
            
            self.view.layoutIfNeeded()
        })
    }
    
    private func hideMenu(animated: Bool) {
        let timeInterval = animated ? 0.4 : 0
        
        UIView.animateWithDuration(timeInterval, animations: {
            self.tableView.center.x = self.minX!
            self.tableView.alpha = 0
            
            self.view.layoutIfNeeded()
        })
    }
}
