//
//  TwitterClient.swift
//  3_Twitter
//
//  Created by Nathan Shayefar on 2/18/15.
//  Copyright (c) 2015 Nathan Shayefar. All rights reserved.
//

class TwitterClient: BDBOAuth1RequestOperationManager {
    private static let consumerKey = ""
    private static let consumerSecret = ""
    private static let apiUrl = NSURL(string: "http://api.twitter.com")
    private static let callbackUrl = NSURL(string: "oauth/request_token")
    private static let authUrlString = "https://api.twitter.com/oauth/authorize?oauth_token="
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient()
        }
        
        return Static.instance
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(baseURL: TwitterClient.apiUrl, consumerKey: TwitterClient.consumerKey, consumerSecret: TwitterClient.consumerSecret);
    }
    
    func requestAccessToken() {
        requestSerializer.removeAccessToken()
        
        fetchRequestTokenWithPath(
            "oauth/request_token",
            method: "GET",
            callbackURL: TwitterClient.callbackUrl,
            scope: nil,
            success: { (requestToken: BDBOAuth1Credential!) -> Void in
                println("Successfully received requestToken")
                
                var authURL = NSURL(string: TwitterClient.authUrlString + requestToken.token)!
                UIApplication.sharedApplication().openURL(authURL)
                
            }) { (error: NSError!) -> Void in
                println("Failed to receive requestToken: \(error.description)")
        }
    }
}
