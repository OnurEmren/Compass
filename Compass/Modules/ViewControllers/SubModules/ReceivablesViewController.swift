//
//  ReceivablesViewController.swift
//  Compass
//
//  Created by Onur Emren on 3.02.2024.
//

import UIKit

class ReceivablesViewController: UIViewController, Coordinating {
    var coordinator: Coordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        navigationSettings()
        
    }
    
    private func navigationSettings() {
        title = "Yatırımlarım"
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}
