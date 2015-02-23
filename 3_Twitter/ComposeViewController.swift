//
//  ComposeViewController.swift
//  3_Twitter
//
//  Created by Nathan Shayefar on 2/18/15.
//  Copyright (c) 2015 Nathan Shayefar. All rights reserved.
//

class ComposeViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var realNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var bodyTextField: UITextField!
    
    var tweet: Tweet?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Color.secondaryColor
        self.bodyTextField.backgroundColor = Color.secondaryColor
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "onCancel")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Tweet", style: .Plain, target: self, action: "onTweet")
        
        self.navigationItem.title = "Compose"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.barTintColor = Color.primaryColor
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.backgroundColor = Color.primaryColor
        
        profileImageView.setImageWithURL(NSURL(string: User.currentUser!.profileImageUrl!))
        realNameLabel.text = User.currentUser!.name
        screenNameLabel.text = User.currentUser!.screenName
    }
    
    // MARK: NavigationItem
    
    func onCancel() {
        println("onCancel")
    }
    
    func onTweet() {
        println("onTweet")
    }
}
