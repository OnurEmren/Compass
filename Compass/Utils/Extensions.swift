//
//  Extensions.swift
//  Compass
//
//  Created by Onur Emren on 28.01.2024.
//

import Foundation
import UIKit

class UIExtensions {
    static func createLabel(text: String, fontSize: CGFloat, alignment: NSTextAlignment) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textAlignment = alignment
        label.font = Fonts.generalFont
        label.text = text
        return label
    }

    static func createButton(title: String, backgroundColor: UIColor, cornerRadius: CGFloat, target: Any?, action: Selector, font: UIFont) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = cornerRadius
        button.layer.masksToBounds = true
        button.titleLabel?.font = font
        button.addTarget(target, action: action, for: .touchUpInside)
        return button
    }
}
