//
//  LoginViewController.swift
//  3_Twitter
//
//  Created by Nathan Shayefar on 2/19/15.
//  Copyright (c) 2015 Nathan Shayefar. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onLogin(sender: AnyObject) {
        TwitterClient.sharedInstance.getRequestToken()
    }
    
}
