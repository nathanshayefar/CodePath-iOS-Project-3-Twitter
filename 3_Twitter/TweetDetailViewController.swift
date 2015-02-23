//
//  TweetDetailViewController.swift
//  3_Twitter
//
//  Created by Nathan Shayefar on 2/18/15.
//  Copyright (c) 2015 Nathan Shayefar. All rights reserved.
//

class TweetDetailViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var realNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    
    var tweet: Tweet?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reply", style: .Plain, target: self, action: "onReply")
        
        self.view.backgroundColor = Color.secondaryColor
        self.bodyLabel.preferredMaxLayoutWidth = self.bodyLabel.frame.size.width
        
        if let tweet = self.tweet {
            let user = tweet.user!
            realNameLabel.text = user.name
            screenNameLabel.text = "@\(user.screenName!)"
            profileImageView.setImageWithURL(NSURL(string: user.profileImageUrl!))
            
            timestampLabel.text = tweet.createdAtString
            bodyLabel.text = tweet.text
            
            retweetLabel.text = String(tweet.retweetCount)
            favoriteLabel.text = String(tweet.favoritesCount)
        }
    }
    
    func setTweet(tweet: Tweet) {
        self.tweet = tweet
    }
    
    // MARK: NavigationItem
    
    func onReply() {
        println("onReply")
    }
}
