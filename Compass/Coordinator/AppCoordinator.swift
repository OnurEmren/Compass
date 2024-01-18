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
            
        case .goToInComeEntryVC:
            let inComeEntryVC = IncomeEntryViewController()
            inComeEntryVC.coordinator = self
            navigationController?.pushViewController(inComeEntryVC, animated: true)
        }
    }
  
    func start() {
           navigationController = UINavigationController()
           if UserDefaults.standard.bool(forKey: "onboardingShown") {
               showMainScreen()
           } else {
               showOnboarding()
           }
           window?.rootViewController = navigationController
           window?.makeKeyAndVisible()
       }
    
    func showOnboarding() {
            UserDefaults.standard.set(true, forKey: "onboardingShown")
            let onboardingVC = ManageOnBoardingViewController()
            onboardingVC.coordinator = self
            navigationController?.pushViewController(onboardingVC, animated: false)
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
            let investmentVC = InvestmentViewController()
            investmentVC.coordinator = self
            navigationController?.pushViewController(investmentVC, animated: true)
        default:
            break
        }
    }
}
