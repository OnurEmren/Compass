//
//  Colors.swift
//  Compass
//
//  Created by Onur Emren on 17.01.2024.
//

import Foundation
import UIKit

enum Colors{
    
    static let colors: [UIColor] = [
        UIColor(red: 0.98, green: 0.96, blue: 0.86, alpha: 1),
        UIColor(red: 0.97, green: 0.82, blue: 0.63, alpha: 1),
        UIColor(red: 0.99, green: 0.90, blue: 0.83, alpha: 1),
        UIColor(red: 0.99, green: 0.94, blue: 0.78, alpha: 1),
        UIColor(red: 0.97, green: 0.89, blue: 0.88, alpha: 1)
    ]
    
    static let lightRed: CGFloat = 251.0 / 255.0
    static let lightGreen: CGFloat = 249.0 / 255.0
    static let lightBlue: CGFloat = 241.0 / 255.0
    
    static let darkRed: CGFloat = 146.0 / 255.0
    static let darkGreen: CGFloat = 199.0 / 255.0
    static let darkBlue: CGFloat = 207.0 / 255.0
    
    static let beigeRed: CGFloat = 229.0 / 255.0
    static let beigeGreen: CGFloat = 225.0 / 255.0
    static let beigeBlue: CGFloat = 218.0 / 255.0
    
    static let pieRed: CGFloat = 9.0 / 255.0
    static let pieGreen: CGFloat = 77.0 / 255.0
    static let pieBlue: CGFloat = 77.0 / 255.0
    
    static let buttonRed: CGFloat = 234.0 / 255.0
    static let buttonGreen: CGFloat = 197.0 / 255.0
    static let buttonBlue: CGFloat = 69.0 / 255.0
    
    
    static let lightThemeColor = UIColor(red: lightRed, green:lightGreen, blue: lightBlue, alpha: 1)
    static let darkThemeColor = UIColor (red: darkRed, green: darkGreen, blue: darkBlue, alpha: 1)
    static let beigeColor = UIColor(red: beigeRed, green: beigeGreen, blue: beigeBlue, alpha: 1)
    static let piesGreenColor = UIColor(red: pieRed, green: pieGreen, blue: pieBlue, alpha: 1)
    static let buttonColor = UIColor(red: buttonRed, green: buttonGreen, blue: buttonBlue, alpha: 1)
}
