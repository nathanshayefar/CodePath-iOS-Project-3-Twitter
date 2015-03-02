//
//  NBSTime.swift
//  3_Twitter
//
//  Created by Nathan Shayefar on 2/23/15.
//  Copyright (c) 2015 Nathan Shayefar. All rights reserved.
//

class NBSTime {
    private static let dateFormatter = NSDateFormatter()
    
    class func timeStringSinceCreation(created: NSDate?) -> String {
        if created == nil {
            return "?m"
        }
        
        let seconds = NSDate().timeIntervalSinceDate(created!)
        
        if seconds < 60 {
            return String(format: "%.0fs", seconds)
        }
        
        let minutes = seconds / 60
        
        if minutes < 60 {
            return String(format: "%.0fm", minutes)
        }
        
        let hours = minutes / 60
        
        if hours < 24 {
            return String(format: "%.0fh", hours)
        }
        
        dateFormatter.dateFormat = "MM/dd/yy"
        return dateFormatter.stringFromDate(created!)
    }
}
