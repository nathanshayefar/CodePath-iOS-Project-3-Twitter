//
//  TwitterClient.swift
//  3_Twitter
//
//  Created by Nathan Shayefar on 2/18/15.
//  Copyright (c) 2015 Nathan Shayefar. All rights reserved.
//

let twitterBaseUrl = NSURL(string: "https://api.twitter.com")
let twiterConsumerKey = ""
let twitterConsumerSecret = ""
let callbackUrl = NSURL(string: "nstwitter://oauth")
let authUrlString = "https://api.twitter.com/oauth/authorize?oauth_token="

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseUrl, consumerKey: twiterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }

    func getRequestToken() {
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
        }
    }
    
    func getAccessToken(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) ->
            Void in
            println("Successfully received accessToken.")
            
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                    println("user: \(response)")
                }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    println("error getting user")
                })
            
            TwitterClient.sharedInstance.GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                println("home_timeline: \(response)")
                }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    println("error getting home timeline")
            })
            
            }) { (error: NSError!) -> Void in
                println("Failed to receive accessToken.")
        }
    }
}
