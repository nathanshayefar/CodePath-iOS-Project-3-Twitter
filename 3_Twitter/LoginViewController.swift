//
//  LoginViewController.swift
//  3_Twitter
//
//  Created by Nathan Shayefar on 2/19/15.
//  Copyright (c) 2015 Nathan Shayefar. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    private let loginSegueId = "loginSegue"

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onLogin(sender: AnyObject) {
        TwitterClient.sharedInstance.loginWithCompletion() {
            (user: User?, error: NSError?) in
            
            if  user != nil {
                self.performSegueWithIdentifier(self.loginSegueId, sender: self)
                // perform segue
            } else {
                // handle login error
            }
        }
    }
    
}
