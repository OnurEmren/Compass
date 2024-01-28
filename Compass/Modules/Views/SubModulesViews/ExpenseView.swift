//
//  ExpenseView.swift
//  Compass
//
//  Created by Onur Emren on 28.01.2024.
//

import Foundation
import UIKit
class ExpenseView: UIView {
    
    var totalExpense = UIExtensions.createLabel(text: "Toplam Giderim", fontSize: Fonts.generalFont!.pointSize, alignment: .center)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
