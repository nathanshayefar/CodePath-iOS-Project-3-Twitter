//
//  HomeTimelineViewController.swift
//  3_Twitter
//
//  Created by Nathan Shayefar on 2/18/15.
//  Copyright (c) 2015 Nathan Shayefar. All rights reserved.
//

class HomeTimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let HOME_TIMELINE_CELL = "HomeTimelineCell"
    private let TWEET_DETAIL_SEGUE = "TweetDetailSegue"
    private let COMPOSE_SEGUE = "ComposeSegue"
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .Plain, target: self, action: "onSignOutButton")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .Plain, target: self, action: "onNewButton")
    }
    
    // MARK: TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier(TWEET_DETAIL_SEGUE, sender: self)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(HOME_TIMELINE_CELL, forIndexPath: indexPath) as! HomeTimelineCell
        
        return cell
    }
    
    // MARK: NavigationItem
    
    func onSignOutButton() {
        println("sign out")
    }
    
    func onNewButton() {
        println("new")
        performSegueWithIdentifier(COMPOSE_SEGUE, sender: self)
    }
}
