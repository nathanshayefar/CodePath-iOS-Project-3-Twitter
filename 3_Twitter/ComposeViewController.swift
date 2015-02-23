//
//  ComposeViewController.swift
//  3_Twitter
//
//  Created by Nathan Shayefar on 2/18/15.
//  Copyright (c) 2015 Nathan Shayefar. All rights reserved.
//

protocol ComposeViewControllerDelegate : class {
    func createdTweet(composeViewController: ComposeViewController)
}

class ComposeViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var realNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var bodyTextField: UITextField!
    
    weak var delegate: ComposeViewControllerDelegate?
    private var tweet: Tweet?
    private var remainingCharactersButton: UIBarButtonItem?
    private let maximumCharacters = 140

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Color.secondaryColor
        self.bodyTextField.backgroundColor = Color.secondaryColor
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "onCancel")
        
        remainingCharactersButton = UIBarButtonItem(title: String(maximumCharacters), style: .Plain, target: self, action: nil)
        remainingCharactersButton?.enabled = false
        
        var tweetButton = UIBarButtonItem(title: "Tweet", style: .Plain, target: self, action: "onTweet")
        self.navigationItem.setRightBarButtonItems([tweetButton, remainingCharactersButton!], animated: false)
        
        self.navigationItem.title = "Compose"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.barTintColor = Color.primaryColor
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.backgroundColor = Color.primaryColor
        
        profileImageView.setImageWithURL(NSURL(string: User.currentUser!.profileImageUrl!))
        realNameLabel.text = User.currentUser!.name
        screenNameLabel.text = "@\(User.currentUser!.screenName!)"
    }
    
    // MARK: NavigationItem
    
    func onCancel() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func onTweet() {
        TwitterClient.sharedInstance.postTweet(bodyTextField.text)
        println("Posted status: \(bodyTextField.text)")
        
        self.delegate?.createdTweet(self)
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func onBodyTextFieldEditingChanged(sender: AnyObject) {
        remainingCharactersButton?.title = remainingCharactersString()
    }
    
    private func remainingCharactersString() -> String {
        let usedCharacters = count(bodyTextField.text)
        let remainingCharacters = max(0, maximumCharacters - usedCharacters)
        
        return String(remainingCharacters)
    }
}
