//
//  AppCoordinator.swift
//  Compass
//
//  Created by Onur Emren on 17.01.2024.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    func eventOccured(with type: Event) {
        switch type {
        case .goToHomeVC:
            let homeVC = HomeViewController()
            homeVC.coordinator = self
            navigationController?.pushViewController(homeVC, animated: true)
        }
    }
    
    var navigationController: UINavigationController?
    var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        navigationController = UINavigationController()
        let viewController = ManageOnBoardingViewController()
        viewController.coordinator = self
        navigationController?.setViewControllers([viewController], animated: true)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
