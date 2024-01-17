//
//  AppCoordinator.swift
//  Compass
//
//  Created by Onur Emren on 17.01.2024.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController?
    var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func eventOccured(with type: Event) {
        switch type {
        case .goToHomeVC:
            let homeVC = HomeViewController()
            homeVC.coordinator = self
            navigationController?.pushViewController(homeVC, animated: true)
        
        case .goToDetailVC(let selectedIndex):
            showDetailViewController(for: selectedIndex)
        }
    }
  
    
    func start() {
        navigationController = UINavigationController()
        
        if UserDefaults.standard.bool(forKey: "appHasBeenLaunched"){
            showOnBoarding()
        } else {
            showMainScreen()
        }
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    private func showOnBoarding() {
        UserDefaults.standard.string(forKey: "appHasBeenLaunched")
        let viewController = ManageOnBoardingViewController()
        viewController.coordinator = self
        navigationController?.setViewControllers([viewController], animated: true)
    }
    
    private func showMainScreen() {
        let viewController = HomeViewController()
        viewController.coordinator = self
        navigationController?.setViewControllers([viewController], animated: true)
    }
    
    func showDetailViewController(for selectedIndex: Int) {
        switch selectedIndex {
        case 0:
            let inComeVC = InComeViewController()
            inComeVC.coordinator = self
            navigationController?.pushViewController(inComeVC, animated: true)
        case 1:
            let expenseVC = ExpenseViewController()
            expenseVC.coordinator = self
            navigationController?.pushViewController(expenseVC, animated: true)
            
        case 2:
          //  destinationViewController = InvestmentViewController()
            let investmentVC = InvestmentViewController()
            investmentVC.coordinator = self
            navigationController?.pushViewController(investmentVC, animated: true)
        default:
            break
        }
    }
}
