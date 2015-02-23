//
//  HomeTimelineCell.swift
//  3_Twitter
//
//  Created by Nathan Shayefar on 2/18/15.
//  Copyright (c) 2015 Nathan Shayefar. All rights reserved.
//

class HomeTimelineCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var realNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.blackColor()
        
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
        let user = tweet.user!
            
        realNameLabel.text = user.name
        screenNameLabel.text = "@\(user.screenName!)"
        println(user.profileImageUrl)
        profileImageView.setImageWithURL(NSURL(string: user.profileImageUrl!))
            
        timestampLabel.text = tweet.createdAtString
        bodyLabel.text = tweet.text
    }
}
