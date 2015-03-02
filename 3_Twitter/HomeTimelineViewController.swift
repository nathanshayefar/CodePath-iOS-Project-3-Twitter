//
//  HomeTimelineViewController.swift
//  3_Twitter
//
//  Created by Nathan Shayefar on 2/18/15.
//  Copyright (c) 2015 Nathan Shayefar. All rights reserved.
//

let homeTimelineCellId = "HomeTimelineCell"
enum TimelineType {
    case Home, Mentions
}

class HomeTimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HomeTimelineCellDelegate, ComposeViewControllerDelegate {
    private let tweetDetailSegueId = "tweetDetailSegue"
    private let composeSegueId = "composeSegue"
    private let profileSegueId = "profileSegue"
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var refreshControl: UIRefreshControl!
    private var tweets: [Tweet]?
    private var timelineType = TimelineType.Home
    
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
        
        self.getTimelineTweets()
    }
    
    func getTimelineTweets() {
        self.refreshControl?.beginRefreshing()
        let completion = {(tweets: [Tweet]?, error: NSError?) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
        
        switch timelineType {
            
        case .Home:
            TwitterClient.sharedInstance.homeTimeline(completion)
            self.navigationItem.title = "Home"
        
        case .Mentions:
            TwitterClient.sharedInstance.mentionsTimeline(completion)
            self.navigationItem.title = "Mentions"
        }
    }
    
    // MARK: TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
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
    
    func setTimelineType(timelineType: TimelineType) {
        self.timelineType = timelineType
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
            let locationInView = sender!.locationInView(self.tableView)
            if let indexPath = self.tableView.indexPathForRowAtPoint(locationInView) {
                let vc = segue.destinationViewController as! ProfileViewController
                vc.setUser(tweets![indexPath.row].user!)
            }
            
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
        self.getTimelineTweets()
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
        self.getTimelineTweets()
    }
}
