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

class ExpenseViewModel {
    let entityName = ""
    let expenseView = ExpenseView()
    private let isGeneralExpense = true

    func getData() {
    }
    
    var generalData: [GeneralExpenseEntry] = []
    
    
    func updateGeneralData(newData: [GeneralExpenseEntry]) {
        generalData = newData
    }
    
    func getGeneralExpenseChartData(generalData: [GeneralExpenseEntry]) -> [PieChartDataEntry] {
        var generalExpenseEntries: [PieChartDataEntry] = []
        
        for (_, entry) in generalData.enumerated() {
            let generalExpenseEntry = PieChartDataEntry(value: entry.creditCardExpense, label: "General \(entry.creditCardExpense)")
            generalExpenseEntries.append(generalExpenseEntry)
            
            let rentExpenseEntry = PieChartDataEntry(value: entry.rentExpense, label: "Kira")
            generalExpenseEntries.append(rentExpenseEntry)
        }
        
        return generalExpenseEntries
    }
}
