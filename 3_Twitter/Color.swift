//
//  Color.swift
//  3_Twitter
//
//  Created by Nathan Shayefar on 2/21/15.
//  Copyright (c) 2015 Nathan Shayefar. All rights reserved.
//

class Color {
    static let primaryColor = Color.argb(1.0, red: 85, green: 172, blue: 238)
    static let secondaryColor = Color.argb(1.0, red: 41, green: 47, blue: 51)
    
    class func argb(alpha: Float, red: Int, green: Int, blue: Int) -> UIColor {
        return UIColor(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}
