//
//  HomeViewModel.swift
//  Compass
//
//  Created by Onur Emren on 27.01.2024.
//

import Foundation
import CoreData
import UIKit

protocol HomeViewModelDelegate: AnyObject {
    func didCalledData()
}

class HomeViewModel {
    weak var homeViewModelDelegate: HomeViewModelDelegate?
    
    func fetchInComeDataDispatch(completion: @escaping ([InComeEntry]) -> Void) {
            DispatchQueue.global(qos: .background).async {
                var incomeEntries: [InComeEntry] = []
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<InComeEntry>(entityName: "InComeEntry")
                
                do {
                    incomeEntries = try context.fetch(fetchRequest)
                } catch {
                    print("Veri çekme hatası: \(error)")
                }
                
                DispatchQueue.main.async {
                    completion(incomeEntries)
                }
            }
        }
    
    func fetchInComeData() -> [InComeEntry] {
        var incomeEntries: [InComeEntry] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<InComeEntry>(entityName: "InComeEntry")
        
        do {
            incomeEntries = try context.fetch(fetchRequest)
        } catch {
            print("Veri çekme hatası: \(error)")
        }
        
        return incomeEntries
    }
    
    func fetchExpenseData() -> [ExpenseEntry] {
        var expenseEntries: [ExpenseEntry] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchExpenseRequest = NSFetchRequest<ExpenseEntry>(entityName: "ExpenseEntry")
        do {
            expenseEntries = try context.fetch(fetchExpenseRequest)
        } catch {
            print("Gider verisi çekme hatası: \(error)")
        }
        
        return expenseEntries
    }
    
    func fetchGeneralExpenseData() -> [GeneralExpenseEntry] {
        var expenseEntries: [GeneralExpenseEntry] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchExpenseRequest = NSFetchRequest<GeneralExpenseEntry>(entityName: "GeneralExpenseEntry")
        do {
            expenseEntries = try context.fetch(fetchExpenseRequest)
        } catch {
            print("Gider verisi çekme hatası: \(error)")
        }
        
        return expenseEntries
    }
    
    func fetchInvestmentData() -> [InvestmentEntry] {
        var investmentEntries: [InvestmentEntry] = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchInvestmentRequest = NSFetchRequest<InvestmentEntry>(entityName: "InvestmentEntry")
        
        do {
            investmentEntries = try context.fetch(fetchInvestmentRequest)
            
        } catch {
            print("Yatırım verisi çekme hatası: \(error)")
        }
        
        return investmentEntries
    }
    

}
