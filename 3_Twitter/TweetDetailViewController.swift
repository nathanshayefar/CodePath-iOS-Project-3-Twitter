//
//  TweetDetailViewController.swift
//  3_Twitter
//
//  Created by Nathan Shayefar on 2/18/15.
//  Copyright (c) 2015 Nathan Shayefar. All rights reserved.
//

class TweetDetailViewController: UIViewController {
    private let detailToComposeSegueID = "detailToComposeSegue"
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var realNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var tweet: Tweet?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reply", style: .Plain, target: self, action: "onReply")
        
        self.view.backgroundColor = Color.secondaryColor
        self.bodyLabel.preferredMaxLayoutWidth = self.bodyLabel.frame.size.width
        
        // Set up buttons
        self.retweetButton.setImage(UIImage(named: "retweet_default") as UIImage?, forState: .Normal)
        self.retweetButton.setImage(UIImage(named: "retweet_enabled") as UIImage?, forState: .Selected)
        self.favoriteButton.setImage(UIImage(named: "favorite_default") as UIImage?, forState: .Normal)
        self.favoriteButton.setImage(UIImage(named: "favorite_enabled") as UIImage?, forState: .Selected)
        
        relayout()
    }
    
    private func relayout() {
        if tweet != nil {
            let user = tweet!.user!
            
            realNameLabel.text = user.name
            screenNameLabel.text = "@\(user.screenName!)"
            profileImageView.setImageWithURL(NSURL(string: user.profileImageUrl!))
            
            timestampLabel.text = tweet!.createdAtString
            bodyLabel.text = tweet!.text
            retweetLabel.text = String(tweet!.retweetCount)
            favoriteLabel.text = String(tweet!.favoritesCount)
            
            retweetButton.selected = tweet!.isRetweeted!
            favoriteButton.selected = tweet!.isFavorited!
        }
    }
    
    func setTweet(tweet: Tweet) {
        self.tweet = tweet
        relayout()
    }
    
    // MARK: NavigationItem
    
    func onReply() {
        self.onReply(self)
    }
    
    // MARK: Tweet actions
    
    @IBAction func onReply(sender: AnyObject) {
        performSegueWithIdentifier(detailToComposeSegueID, sender: self)
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        self.tweet?.toggleRetweet()
        relayout()
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        self.tweet?.toggleFavorite()
        relayout()
    }
}
