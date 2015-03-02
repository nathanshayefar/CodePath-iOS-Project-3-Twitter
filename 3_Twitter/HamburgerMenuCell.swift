//
//  HamburgerMenuCell.swift
//  3_Twitter
//
//  Created by Nathan Shayefar on 3/2/15.
//  Copyright (c) 2015 Nathan Shayefar. All rights reserved.
//

class HamburgerMenuCell: UITableViewCell {
    @IBOutlet weak var menuOptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.userInteractionEnabled = true
    }
}
