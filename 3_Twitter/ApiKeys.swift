//
//  ApiKeys.swift
//  3_Twitter
//
//  Created by Nathan Shayefar on 2/21/15.
//  Copyright (c) 2015 Nathan Shayefar. All rights reserved.
//
class ApiKeys {
    static let twitterConsumerKey = ApiKeys.valueForApiKey("TWITTER_CONSUMER_KEY")
    static let twitterConsumerSecret = ApiKeys.valueForApiKey("TWITTER_CONSUMER_SECRET")
    
    class func valueForApiKey(keyname: String) -> String {
        let filePath = NSBundle.mainBundle().pathForResource("ApiKeys", ofType:"plist")
        let plist = NSDictionary(contentsOfFile:filePath!)
        
        return plist?.objectForKey(keyname) as! String
    }
}