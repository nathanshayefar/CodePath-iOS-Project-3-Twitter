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

    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Color.secondaryColor
        
        self.loginButton.backgroundColor = Color.primaryColor
        self.loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.loginButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        self.loginButton.layer.cornerRadius = 3
    }

    @IBAction func onLogin(sender: AnyObject) {
        TwitterClient.sharedInstance.loginWithCompletion() {
            (user: User?, error: NSError?) in
            
            if  user != nil {
                self.performSegueWithIdentifier(self.loginSegueId, sender: self)
            } else {
                println(error)
            }
        }
    }
    
}
