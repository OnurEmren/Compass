//
//  InvestmentViewController.swift
//  Compass
//
//  Created by Onur Emren on 17.01.2024.
//

import UIKit

class InvestmentViewController: UIViewController, Coordinating {
    var coordinator: Coordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = UIColor.white

        view.backgroundColor = .blue
    }
}
