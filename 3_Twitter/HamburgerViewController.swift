//
//  HamburgerViewController.swift
//  3_Twitter
//
//  Created by Nathan Shayefar on 3/1/15.
//  Copyright (c) 2015 Nathan Shayefar. All rights reserved.
//

class HamburgerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    
    private var originalContainerViewCenter: CGPoint?
    private var containerViewMinRightCenter: CGPoint?
    private var containerViewMaxRightCenter: CGPoint?
    
    private var viewControllers: [UIViewController]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Storyboarding
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileViewController = storyboard.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
        let homeTimelineViewController = storyboard.instantiateViewControllerWithIdentifier("HomeTimelineViewController") as!HomeTimelineViewController
        let mentionsViewController = storyboard.instantiateViewControllerWithIdentifier("TweetDetailViewController") as! TweetDetailViewController
        viewControllers = [profileViewController, homeTimelineViewController, mentionsViewController]
        self.activeViewController = viewControllers?.first
        
        
        
        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.containerViewMinRightCenter = CGPoint(x: -containerView.bounds.width, y: view.center.y)
        self.containerViewMaxRightCenter = CGPoint(x: containerView.bounds.width / 2, y: view.center.y)
        
        self.containerView.center = self.containerViewMinRightCenter!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
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
                self.view.bounds = self.containerView.bounds
                self.view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
                self.containerView.addSubview(newViewController.view)
                newViewController.didMoveToParentViewController(self)
            }
        }
    }

    @IBAction func onPanContainerView(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        switch sender.state {
        case .Began:
            println("began")
            
            originalContainerViewCenter = self.containerView.center
        case .Changed:
            println("changed")
            
            containerView.center = CGPoint(x: self.originalContainerViewCenter!.x + translation.x, y: self.originalContainerViewCenter!.y)
        case .Ended:
            println("ended")
            
            if velocity.x > 0 {
                containerView.center = self.containerViewMaxRightCenter!
            } else {
                containerView.center = self.containerViewMinRightCenter!
            }
        default:
            println("other action")
        }
    }
}
