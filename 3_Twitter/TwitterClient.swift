//
//  TwitterClient.swift
//  3_Twitter
//
//  Created by Nathan Shayefar on 2/18/15.
//  Copyright (c) 2015 Nathan Shayefar. All rights reserved.
//

let twitterBaseUrl = NSURL(string: "https://api.twitter.com")
let callbackUrl = NSURL(string: "nstwitter://oauth")
let authUrlString = "https://api.twitter.com/oauth/authorize?oauth_token="

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseUrl, consumerKey: ApiKeys.twitterConsumerKey, consumerSecret: ApiKeys.twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            
            var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(tweets: nil, error: error)
        }
    }
    
    func postTweet(status: String) {
        let params = ["status": status]
        
        POST("1.1/statuses/update.json", parameters: params, success: {(operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("Posted status: \(status)")
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Failed to post status with text:\(status)")
        }
    }
    
    func favoriteTweet(tweetID: String) {
        let params = ["id": tweetID]
        
        POST("1.1/favorites/create.json", parameters: params, success: {(operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("Favorited tweet: \(tweetID)")
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Failed to favorite tweet. \(error)")
        }
    }
    
    func unfavoriteTweet(tweetID: String) {
        let params = ["id": tweetID]
        
        POST("1.1/favorites/destroy.json", parameters: params, success: {(operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("Unavorited tweet: \(tweetID)")
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Failed to unfavorite tweet. \(error)")
        }
    }
    
    func retweet(tweetID: String) {
        let params = ["id": tweetID]
        
        POST("1.1/statuses/retweet/\(tweetID).json", parameters: params, success: {(operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("Retweeted tweet: \(tweetID)")
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Failed to retweet: \(error)")
        }
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // Fetch request token and redirect to authorization page
        requestSerializer.removeAccessToken()
        fetchRequestTokenWithPath(
            "oauth/request_token",
            method: "GET",
            callbackURL: callbackUrl,
            scope: nil,
            success: { (requestToken: BDBOAuth1Credential!) -> Void in
                println("Successfully received requestToken.")
                
                var authURL = NSURL(string: authUrlString + requestToken.token)!
                UIApplication.sharedApplication().openURL(authURL)
                
            }) { (error: NSError!) -> Void in
                println("Failed to receive requestToken. \(error.description)")
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func openUrl(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) ->
            Void in
            println("Successfully received accessToken.")
            
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                
                var user = User(dictionary: response as! NSDictionary)
                println("user: \(user.name)")
                User.currentUser = user
                
                self.loginCompletion?(user: user, error: nil)
                }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    println("Error getting user.")
                    self.loginCompletion?(user: nil, error: error)
            }
            
            }) { (error: NSError!) -> Void in
                println("Failed to receive accessToken.")
                self.loginCompletion?(user: nil, error: error)
        }
    }
}
