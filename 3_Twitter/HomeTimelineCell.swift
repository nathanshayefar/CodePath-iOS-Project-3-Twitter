//
//  HomeTimelineCell.swift
//  3_Twitter
//
//  Created by Nathan Shayefar on 2/18/15.
//  Copyright (c) 2015 Nathan Shayefar. All rights reserved.
//

protocol HomeTimelineCellDelegate : class {
    func didReply(homeTimelineCell: HomeTimelineCell)
}

class HomeTimelineCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var realNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var tweet: Tweet?
    weak var delegate: HomeTimelineCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = Color.secondaryColor
        
        // Set up buttons
        self.retweetButton.setImage(UIImage(named: "retweet_default") as UIImage?, forState: .Normal)
        self.retweetButton.setImage(UIImage(named: "retweet_enabled") as UIImage?, forState: .Selected)
        self.favoriteButton.setImage(UIImage(named: "favorite_default") as UIImage?, forState: .Normal)
        self.favoriteButton.setImage(UIImage(named: "favorite_enabled") as UIImage?, forState: .Selected)
        
        // Update views
        self.profileImageView.layer.cornerRadius = 3
        self.profileImageView.clipsToBounds = true
        self.bodyLabel.preferredMaxLayoutWidth = self.bodyLabel.frame.size.width
        
        relayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.bodyLabel.preferredMaxLayoutWidth = self.bodyLabel.frame.size.width
    }
    
    func relayout() {
        if let tweet = self.tweet {
            let user = tweet.user!
            
            realNameLabel.text = user.name
            screenNameLabel.text = "@\(user.screenName!)"
            profileImageView.setImageWithURL(NSURL(string: user.profileImageUrl!))
            
            timestampLabel.text = tweet.timeStringSinceCreation
            bodyLabel.text = tweet.text
            
            retweetButton.selected = tweet.isRetweeted!
            favoriteButton.selected = tweet.isFavorited!
        }
    }
    
    func setTweet(tweet: Tweet) {
        self.tweet = tweet
        relayout()
    }
    
    // MARK: Tweet actions
    
    @IBAction func onReply(sender: AnyObject) {
        self.delegate?.didReply(self)
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
