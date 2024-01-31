//
//  TryViewController.swift
//  Compass
//
//  Created by Onur Emren on 31.01.2024.
//

import UIKit

class TryViewController: UIViewController,Coordinating {
    var coordinator: Coordinator?
    let financeView = FinanceCardCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTryView()
        view.backgroundColor = .gray
    }
    
    private func setupTryView() {
        view.addSubview(financeView)
        
        financeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
}
