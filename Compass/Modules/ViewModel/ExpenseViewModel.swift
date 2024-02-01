//
//  ExpenseViewModel.swift
//  Compass
//
//  Created by Onur Emren on 31.01.2024.
//

import Foundation
import CoreData
import UIKit
import DGCharts

protocol ExpenseViewModelDelegate: AnyObject {
    func didFetchGeneralData(generalData: [GeneralExpenseEntry])
    func didFetchedDetailData(detailExpenseData: [ExpenseEntry])
}

class ExpenseViewModel {
    let entityName = ""
    let expenseView = ExpenseView()
    private let isGeneralExpense = true
    weak var delegate: ExpenseViewModelDelegate?
    
    //MARK: - FetchData
    
    func fetchDetailData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ExpenseEntry")
        
        do {
            let fetchedDetailData = try context.fetch(fetchRequest) as! [ExpenseEntry]
            let totalExpense = fetchedDetailData.reduce(0) { (result, entry) in
                return result + entry.totalExpense
            }
            self.expenseView.totalExpenseLabel.text = "Toplam Detay Gider: \(totalExpense)"
            
            for entry in fetchedDetailData {
                let clothesExpense = entry.clothesExpense
                let electronicExpense = entry.electronicExpense
                let fuelExpense = entry.fuelExpense
                let rentExpense = entry.rentExpense
                let transportExpense = entry.transportExpense
                let foodExpense = entry.foodExpense
                let taxExpense = entry.taxExpense
                let expenseTotal = clothesExpense + electronicExpense + fuelExpense + rentExpense + transportExpense + foodExpense + taxExpense
                let month = entry.month
                self.expenseView.totalExpenseLabel.text = "\(expenseTotal)"
                self.expenseView.monthLabel.text = month
            }
            delegate?.didFetchedDetailData(detailExpenseData: fetchedDetailData)
        } catch {
            print("Veri çekme hatası: \(error)")
        }
    }
    
    func fetchDataFromCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchGeneralData = NSFetchRequest<NSFetchRequestResult>(entityName: "GeneralExpenseEntry")
        do {
            let fetchedGeneralData = try context.fetch(fetchGeneralData) as! [GeneralExpenseEntry]
            let totalIncome = fetchedGeneralData.reduce(0) { (result, entry) in
                return result + entry.creditCardExpense + entry.rentExpense
            }
            self.expenseView.totalExpenseLabel.text = "Toplam Genel Gider: \(totalIncome)"
            
            for entry in fetchedGeneralData {
                let rentExpense = entry.rentExpense
                let creditCardExpense = entry.creditCardExpense
                let expenseTotal = rentExpense + creditCardExpense
                
                self.expenseView.totalExpenseLabel.text = "\(expenseTotal)"
            }
            delegate?.didFetchGeneralData(generalData: fetchedGeneralData)
        } catch {
            print("General data çekme hatası \(error)")
        }
    }
    
    //MARK: - DeleteData
    
    func deleteExpenseData(entityName: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        var fetchRequest: NSFetchRequest<NSFetchRequestResult>?
        
        if entityName == "ExpenseEntry" {
            let expenseFetchRequest: NSFetchRequest<ExpenseEntry> = ExpenseEntry.fetchRequest()
            expenseFetchRequest.sortDescriptors = [NSSortDescriptor(key: "transportExpense", ascending: false)]
            expenseFetchRequest.fetchLimit = 1
            fetchRequest = expenseFetchRequest as? NSFetchRequest<NSFetchRequestResult>
        } else if entityName == "GeneralExpenseEntry" {
            let generalFetchRequest: NSFetchRequest<GeneralExpenseEntry> = GeneralExpenseEntry.fetchRequest()
            generalFetchRequest.sortDescriptors = [NSSortDescriptor(key: "rentExpense", ascending: false)]
            generalFetchRequest.fetchLimit = 1
            fetchRequest = generalFetchRequest as? NSFetchRequest<NSFetchRequestResult>
        }
        
        if let fetchRequest = fetchRequest {
            do {
                let result = try context.fetch(fetchRequest)
                
                if let lastIncomeEntry = result.first as? NSManagedObject {
                    context.delete(lastIncomeEntry)
                    try context.save()
                }
            } catch {
                print("Hata: \(error)")
            }
        }
    }
}
