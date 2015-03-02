//
//  TwitterNavigationController.swift
//  3_Twitter
//
//  Created by Nathan Shayefar on 3/2/15.
//  Copyright (c) 2015 Nathan Shayefar. All rights reserved.
//

import UIKit

class TwitterNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Home"
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationBar.barTintColor = NBSColor.primaryColor
        self.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationBar.backgroundColor = NBSColor.primaryColor
    }
}
