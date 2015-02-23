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
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        idString = dictionary["id_str"] as? String
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        
        if var favorites = dictionary["favorite_count"] as? Int {
            favoritesCount = favorites
        } else {
            favoritesCount = 0
        }
        
        if var retweets = dictionary["retweet_count"] as? Int {
            retweetCount = retweets
        } else {
            retweetCount = 0
        }
        
        if let retweeted = dictionary["retweeted"] as? Int {
            isRetweeted = (retweeted == 1)
        }
        if let favorited = dictionary["favorited"] as? Int {
            isFavorited = (favorited == 1)
        }
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
}
