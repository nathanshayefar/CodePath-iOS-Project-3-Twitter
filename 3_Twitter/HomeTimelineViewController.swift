//
//  HomeTimelineViewController.swift
//  3_Twitter
//
//  Created by Nathan Shayefar on 2/18/15.
//  Copyright (c) 2015 Nathan Shayefar. All rights reserved.
//

class HomeTimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let homeTimelineCellId = "HomeTimelineCell"
    private let tweetDetailSegueId = "tweetDetailSegue"
    private let composeSegueId = "composeSegue"
    
    @IBOutlet weak var tableView: UITableView!

    var tweets: [Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 85
        self.tableView.backgroundColor = Color.secondaryColor
        
        self.navigationItem.title = "Home"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.barTintColor = Color.primaryColor
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.backgroundColor = Color.primaryColor
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .Plain, target: self, action: "onSignOutButton")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .Plain, target: self, action: "onNewButton")
        
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
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
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier(tweetDetailSegueId, sender: self)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(homeTimelineCellId, forIndexPath: indexPath) as! HomeTimelineCell
        
        if let tweet = self.tweets?[indexPath.row] {
            cell.setTweet(tweet)
        }
        
        return cell
    }
    
    // MARK: NavigationItem
    
    func onSignOutButton() {
        println("sign out")
        User.currentUser?.logout()
    }
    
    func onNewButton() {
        println("new")
        performSegueWithIdentifier(composeSegueId, sender: self)
    }
}
