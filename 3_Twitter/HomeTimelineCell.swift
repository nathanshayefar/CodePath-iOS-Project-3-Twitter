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
    
    var tweet: Tweet?
    var delegate: HomeTimelineCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = Color.secondaryColor
        
        self.profileImageView.layer.cornerRadius = 3
        self.profileImageView.clipsToBounds = true
        self.bodyLabel.preferredMaxLayoutWidth = self.bodyLabel.frame.size.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.bodyLabel.preferredMaxLayoutWidth = self.bodyLabel.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setTweet(tweet: Tweet) {
        self.tweet = tweet
        
        let user = tweet.user!
            
        realNameLabel.text = user.name
        screenNameLabel.text = "@\(user.screenName!)"
        profileImageView.setImageWithURL(NSURL(string: user.profileImageUrl!))
            
        timestampLabel.text = tweet.createdAtString
        bodyLabel.text = tweet.text
    }
    
    // MARK: Tweet actions
    
    @IBAction func onReply(sender: AnyObject) {
        self.delegate?.didReply(self)
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        TwitterClient.sharedInstance.retweet(self.tweet!.idString!)
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        TwitterClient.sharedInstance.favoriteTweet(self.tweet!.idString!)
    }
    
}
