//
//  AppCoordinator.swift
//  Compass
//
//  Created by Onur Emren on 17.01.2024.
//

import Foundation
import UIKit
import CoreData

class AppCoordinator: Coordinator {
    var isGeneralExpense: Bool?
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
            
        case .goToExpenseEntryVC:
            let expenseEntryVC = ExpenseEntryViewController()
            expenseEntryVC.coordinator = self
            navigationController?.pushViewController(expenseEntryVC, animated: true)
            
        case .goToInvestmentEntryVC:
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let viewModel = InvestmentViewModel(context: context)
            let investmentVC = InvestmentViewController(viewModel: viewModel)
            investmentVC.coordinator = self
            navigationController?.pushViewController(investmentVC, animated: true)
            
        case .goToGeneralExpenseVC:
            let generalVC = GeneralExpenseViewController()
            generalVC.coordinator = self
            navigationController?.pushViewController(generalVC, animated: true)
            
        case .goToReceivablesEntryVC:
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let viewModel = ReceivablesViewModel(context:context)
            let receivablesEntryVC = ReceivablesViewController(viewModel: viewModel)
            navigationController?.pushViewController(receivablesEntryVC, animated: true)
            
        case .goToDetpEntryVC:
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let viewModel = DeptViewModel(context: context)
            let deptEntryVC = DeptViewController(viewModel: viewModel)
            deptEntryVC.coordinator = self
            navigationController?.pushViewController(deptEntryVC, animated: true)
            
        case .goToPaymentVC:
            let paymentVC = IPManagerViewController()
            paymentVC.coordinator = self
            navigationController?.pushViewController(paymentVC, animated: true)
            
        case .goToAccountVC:
            let accountVC = AccountViewController()
            accountVC.coordinator = self
            navigationController?.pushViewController(accountVC, animated: true)
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
        let onboardingVC = OnBoardingVC()
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
            expenseVC.entityName = "ExpenseEntry"
            navigationController?.pushViewController(expenseVC, animated: true)
        case 2:
            let investmentVC = InvestmentListViewController()
            investmentVC.coordinator = self
            navigationController?.pushViewController(investmentVC, animated: true)
        case 3:
            let receivablesListVC = ReceiVablesListViewController()
            receivablesListVC.coordinator = self
            navigationController?.pushViewController(receivablesListVC, animated: true)
        case 4:
            let deptVC = DeptListViewController()
            deptVC.coordinator = self
            navigationController?.pushViewController(deptVC, animated: true)
        default:
            break
        }
    }
}
