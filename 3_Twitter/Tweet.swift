//
//  Tweet.swift
//  3_Twitter
//
//  Created by Nathan Shayefar on 2/20/15.
//  Copyright (c) 2015 Nathan Shayefar. All rights reserved.
//

class Tweet {
    var user: User?
    var idString: String?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var favoritesCount: Int
    var retweetCount: Int
    var isRetweeted: Bool?
    var isFavorited: Bool?
    var timeStringSinceCreation: String
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        idString = dictionary["id_str"] as? String
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        
        if let retweeted = dictionary["retweeted"] as? Int {
            isRetweeted = (retweeted == 1)
        }
        if let favorited = dictionary["favorited"] as? Int {
            isFavorited = (favorited == 1)
        }
        
        timeStringSinceCreation = NBSTime.timeStringSinceCreation(createdAt)
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
    
    func toggleFavorite() {
        if let previouslyFavorited = self.isFavorited {
            if previouslyFavorited {
                unfavorite()
            } else {
                favorite()
            }
        }
    }
    
    func toggleRetweet() {
        if let previouslyRetweeted = self.isRetweeted {
            if previouslyRetweeted {
                unretweet()
            } else {
                retweet()
            }
        }
    }
    
    private func favorite() {
        TwitterClient.sharedInstance.favoriteTweet(idString!)
        favoritesCount++
        isFavorited = true
    }
    
    private func unfavorite() {
        TwitterClient.sharedInstance.unfavoriteTweet(idString!)
        favoritesCount--
        isFavorited = false
    }
    
    private func retweet() {
        TwitterClient.sharedInstance.retweet(idString!)
        retweetCount++
        isRetweeted = true
    }
    
    private func unretweet() {
        TwitterClient.sharedInstance.unretweet(idString!)
        retweetCount--
        isRetweeted = false
    }
}
