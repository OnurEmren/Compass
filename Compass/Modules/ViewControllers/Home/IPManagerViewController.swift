//
//  IPManagerViewController.swift
//  Compass
//
//  Created by Onur Emren on 27.02.2024.
//

import UIKit

class IPManagerViewController: UIViewController, Coordinating {
    var coordinator: Coordinator?
    private var ipView = IAPView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        loadingView()
    }
    
    private func loadingView() {
        ipView = IAPView()
        view.addSubview(ipView)
        ipView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
