//
//  Colors.swift
//  Compass
//
//  Created by Onur Emren on 17.01.2024.
//

import Foundation
import UIKit

enum Colors{
    static let lightRed: CGFloat = 251.0 / 255.0
    static let lightGreen: CGFloat = 249.0 / 255.0
    static let lightBlue: CGFloat = 241.0 / 255.0
    
    static let darkRed: CGFloat = 146.0 / 255.0
    static let darkGreen: CGFloat = 199.0 / 255.0
    static let darkBlue: CGFloat = 207.0 / 255.0
    
    static let beigeRed: CGFloat = 229.0 / 255.0
    static let beigeGreen: CGFloat = 225.0 / 255.0
    static let beigeBlue: CGFloat = 218.0 / 255.0
    
    static let lightThemeColor = UIColor(red: lightRed, green:lightGreen, blue: lightBlue, alpha: 1)
    static let darkThemeColor = UIColor (red: darkRed, green: darkGreen, blue: darkBlue, alpha: 1)
    static let beigeColor = UIColor(red: beigeRed, green: beigeGreen, blue: beigeBlue, alpha: 1)
}
