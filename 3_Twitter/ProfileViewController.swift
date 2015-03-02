//
//  ProfileViewController.swift
//  3_Twitter
//
//  Created by Nathan Shayefar on 3/1/15.
//  Copyright (c) 2015 Nathan Shayefar. All rights reserved.
//

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HomeTimelineCellDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var profileBackgroundImageView: UIImageView!
    @IBOutlet private weak var tweetCountLabel: UILabel!
    @IBOutlet private weak var followingCountLabel: UILabel!
    @IBOutlet private weak var followerCountLabel: UILabel!
    
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var screenNameLabel: UILabel!
    
    
    private var refreshControl: UIRefreshControl!
    private var user: User?
    private var tweets: [Tweet]?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 85
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.backgroundColor = NBSColor.secondaryColor
        
        self.navigationItem.title = "Profile"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.barTintColor = NBSColor.primaryColor
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.backgroundColor = NBSColor.primaryColor
        
        // Pull to refresh
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.insertSubview(refreshControl, atIndex: 0)
        
        self.profileImageView.layer.cornerRadius = 3
        self.profileImageView.clipsToBounds = true
        self.profileImageView.layer.zPosition = 1
        
        self.getUserTimeline()
    }
    
    func setUser(user: User) {
        self.user = user
        println(user.backgroundImageUrl)
    }
    
    func relayout() {
        if let user = self.user {
            self.profileBackgroundImageView.setImageWithURL(NSURL(string: user.backgroundImageUrl!)!)
            
            self.tweetCountLabel.text = String(user.tweetCount ?? 0)
            self.followingCountLabel.text = String(user.followingCount ?? 0)
            self.followerCountLabel.text = String(user.followerCount ?? 0)
            
            self.profileImageView.setImageWithURL(NSURL(string: user.profileImageUrl!)!)
            self.nameLabel.text = user.name
            self.screenNameLabel.text = user.screenName
            
            self.profileImageView.layer.zPosition = 1
            self.nameLabel.layer.zPosition = 1
            self.screenNameLabel.layer.zPosition = 1
        }
    }
    
    func getUserTimeline() {
        if let userID = user?.idString {
            self.refreshControl.beginRefreshing()
            
            TwitterClient.sharedInstance.userTimeline(userID, completion: { (tweets, error) -> () in
                self.tweets = tweets
                self.tableView.reloadData()
                self.relayout()
                
                self.refreshControl.endRefreshing()
            })
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(homeTimelineCellId, forIndexPath: indexPath) as! HomeTimelineCell
        
        cell.delegate = self
        if let tweet = self.tweets?[indexPath.row] {
            cell.setTweet(tweet)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets?.count ?? 0
    }
    
    // MARK: UIRefreshControl
    
    func onRefresh() {
        self.getUserTimeline()
    }
    
    // MARK: HomeTimelineCellDelegate
    
    func didReply(homeTimelineCell: HomeTimelineCell) {
        println("replying")
    }
}
