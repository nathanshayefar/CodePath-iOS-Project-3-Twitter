//
//  HomeTimelineCell.swift
//  3_Twitter
//
//  Created by Nathan Shayefar on 2/18/15.
//  Copyright (c) 2015 Nathan Shayefar. All rights reserved.
//

class HomeTimelineCell: UITableViewCell {
    private let TWEET_DETAIL_SEGUE = "TweetDetailSegue"

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setTweet(tweet: Tweet) {
        let user = tweet.user
        
        let a = user?.name
        let c = user?.screenName
        let b = user?.profileImageUrl
        
        let x = tweet.createdAtString
        let y = tweet.text
    }
}
