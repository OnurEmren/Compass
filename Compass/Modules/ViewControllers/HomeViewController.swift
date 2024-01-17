//
//  ViewController.swift
//  Compass
//
//  Created by Onur Emren on 17.01.2024.
//

import UIKit

class HomeViewController: UIViewController, Coordinating {
    var coordinator: Coordinator?
    private var homeView = HomeView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        homeView.coordinator = coordinator
        view.backgroundColor = Colors.beigeColor
    }

    private func setupView() {
        homeView = HomeView()
        view.addSubview(homeView)
        homeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

