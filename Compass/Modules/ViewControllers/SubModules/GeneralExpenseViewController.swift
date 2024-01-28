//
//  GeneralExpenseViewController.swift
//  Compass
//
//  Created by Onur Emren on 28.01.2024.
//

import UIKit

class GeneralExpenseViewController: UIViewController, Coordinating {
    var coordinator: Coordinator?
    private var generalExpenseView = GeneralExpenseView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        view.backgroundColor = .red
    }
    
    private func setupView() {
        view.addSubview(generalExpenseView)
        
        generalExpenseView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
