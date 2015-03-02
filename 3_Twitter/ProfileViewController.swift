//
//  ProfileViewController.swift
//  3_Twitter
//
//  Created by Nathan Shayefar on 3/1/15.
//  Copyright (c) 2015 Nathan Shayefar. All rights reserved.
//

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HomeTimelineCellDelegate {
    private var user: User?
    private var tweets: [Tweet]?

    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.registerClass(HomeTimelineCell.self, forCellReuseIdentifier: homeTimelineCellId)
        
        self.getUserTimeline()
    }
    
    func setUser(user: User) {
        self.user = user
    }
    
    func getUserTimeline() {
        if let userID = user?.idString {
            TwitterClient.sharedInstance.userTimeline(userID, completion: { (tweets, error) -> () in
            
                self.tweets = tweets
                self.tableView.reloadData()
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
        if let count = self.tweets?.count {
            return count
        } else {
            return 0
        }
    }
    
    // MARK: HomeTimelineCellDelegate
    
    func didReply(homeTimelineCell: HomeTimelineCell) {
        println("replying")
    }
}
