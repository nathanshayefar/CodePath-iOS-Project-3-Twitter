//
//  HomeTimelineViewController.swift
//  3_Twitter
//
//  Created by Nathan Shayefar on 2/18/15.
//  Copyright (c) 2015 Nathan Shayefar. All rights reserved.
//

let homeTimelineCellId = "HomeTimelineCell"

class HomeTimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HomeTimelineCellDelegate, ComposeViewControllerDelegate {
    private let tweetDetailSegueId = "tweetDetailSegue"
    private let composeSegueId = "composeSegue"
    private let profileSegueId = "profileSegue"
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var refreshControl: UIRefreshControl!
    private var tweets: [Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 85
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.backgroundColor = NBSColor.secondaryColor
        
        self.navigationItem.title = "Home"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.barTintColor = NBSColor.primaryColor
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.backgroundColor = NBSColor.primaryColor
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .Plain, target: self, action: "onSignOutButton")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .Plain, target: self, action: "onNewButton")
        
        // Pull to refresh
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.insertSubview(refreshControl, atIndex: 0)
        
        self.getHomeTimelineTweets()
    }
    
    func getHomeTimelineTweets() {
        self.refreshControl?.beginRefreshing()
        
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        })
    }
    
    // MARK: TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = tweets?.count {
            return count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(tweetDetailSegueId, sender: self)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(homeTimelineCellId, forIndexPath: indexPath) as! HomeTimelineCell
        
        cell.delegate = self
        if let tweet = self.tweets?[indexPath.row] {
            cell.setTweet(tweet)
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch segue.identifier! {
        
        case tweetDetailSegueId:
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let vc = segue.destinationViewController as! TweetDetailViewController
                vc.setTweet(self.tweets![indexPath.row])
                self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
            }
            
        case composeSegueId:
            let vc = segue.destinationViewController as! ComposeViewController
            vc.delegate = self
            
        case profileSegueId:
            println(profileSegueId)
            let locationInView = sender!.locationInView(self.tableView)
                println(locationInView)
                if let indexPath = self.tableView.indexPathForRowAtPoint(locationInView) {
                    println(indexPath.row)
                    let vc = segue.destinationViewController as! ProfileViewController
                    vc.setUser(tweets![indexPath.row].user!)
                }
            println("boom shack")
            
        default:
            return
        }
    }
    
    // MARK: NavigationItem
    
    func onSignOutButton() {
        User.currentUser?.logout()
    }
    
    func onNewButton() {
        performSegueWithIdentifier(composeSegueId, sender: self)
    }
    
    // MARK: UIRefreshControl
    
    func onRefresh() {
        self.getHomeTimelineTweets()
    }
    
    // MARK: HomeTimelineCellDelegate
    
    func didReply(homeTimelineCell: HomeTimelineCell) {
        performSegueWithIdentifier(composeSegueId, sender: self)
    }
    
    @IBAction func didTapProfileImage(sender: UITapGestureRecognizer) {
        performSegueWithIdentifier(profileSegueId, sender: sender)
    }
    
    
    // MARK: ComposeViewControllerDelegate
    
    func createdTweet(composeViewController: ComposeViewController) {
        self.getHomeTimelineTweets()
    }
}
