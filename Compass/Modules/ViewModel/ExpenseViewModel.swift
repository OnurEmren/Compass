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
    
    func setupCombinedChart(expenseData: [ExpenseEntry], generalData: [GeneralExpenseEntry]) {
        var clothesExpenseEntries: [PieChartDataEntry] = []
        var electronicExpenseEntries: [PieChartDataEntry] = []
        var foodExpenseEntries: [PieChartDataEntry] = []
        var fuelExpenseEntries: [PieChartDataEntry] = []
        var rentExpenseEntries: [PieChartDataEntry] = []
        var taxExpenseEntries: [PieChartDataEntry] = []
        var transportEntries: [PieChartDataEntry] = []
        var generalExpenseEntries: [PieChartDataEntry] = []
        
            for (_, entry) in expenseData.enumerated() {
                let clothesExpenseEntry = PieChartDataEntry(value: entry.clothesExpense, label: "Giyim")
                let electronicExpenseEntry = PieChartDataEntry(value: entry.electronicExpense, label: "Elektronik")
                let foodExpenseEntry = PieChartDataEntry(value: entry.foodExpense, label: "Gıda")
                let fuelExpenseEntry = PieChartDataEntry(value: entry.fuelExpense, label: "Yakıt")
                let rentExpenseEntry = PieChartDataEntry(value: entry.rentExpense, label: "Kira")
                let taxExpenseEntry = PieChartDataEntry(value: entry.taxExpense, label: "Faturalar")
                let transportEntry = PieChartDataEntry(value: entry.transportExpense, label: "Ulaşım")
                
                clothesExpenseEntries.append(clothesExpenseEntry)
                electronicExpenseEntries.append(electronicExpenseEntry)
                foodExpenseEntries.append(foodExpenseEntry)
                fuelExpenseEntries.append(fuelExpenseEntry)
                rentExpenseEntries.append(rentExpenseEntry)
                taxExpenseEntries.append(taxExpenseEntry)
                transportEntries.append(transportEntry)
            }
            
            for (_, entry) in generalData.enumerated() {
                let generalExpenseEntry = PieChartDataEntry(value: entry.creditCardExpense, label: "General \(entry.creditCardExpense)")
                generalExpenseEntries.append(generalExpenseEntry)
                
                let rentExpenseEntry = PieChartDataEntry(value: entry.rentExpense, label: "Kira")
                generalExpenseEntries.append(rentExpenseEntry)
            }
        
        
        let clothesDataSet = PieChartDataSet(entries: clothesExpenseEntries, label: "")
        clothesDataSet.colors = ChartColorTemplates.material()
        
        let electronicDataSet = PieChartDataSet(entries: electronicExpenseEntries, label: "")
        electronicDataSet.colors = ChartColorTemplates.colorful()
        
        let foodDataSet = PieChartDataSet(entries: foodExpenseEntries, label: "")
        foodDataSet.colors = ChartColorTemplates.colorful()
        
        let fuelDataSet = PieChartDataSet(entries: fuelExpenseEntries, label: "")
        fuelDataSet.colors = ChartColorTemplates.colorful()
        
        let rentDataSet = PieChartDataSet(entries: rentExpenseEntries, label: "")
        rentDataSet.colors = ChartColorTemplates.colorful()
        
        let taxDataSet = PieChartDataSet(entries: taxExpenseEntries, label: "")
        taxDataSet.colors = ChartColorTemplates.colorful()
        
        let transportDataSet = PieChartDataSet(entries: transportEntries, label: "")
        transportDataSet.colors = ChartColorTemplates.colorful()
        
        let clothesData = PieChartData(dataSet: clothesDataSet)
        let electronikData = PieChartData(dataSet: electronicDataSet)
        let foodData = PieChartData(dataSet: foodDataSet)
        let fuelData = PieChartData(dataSet: fuelDataSet)
        let rentData = PieChartData(dataSet: rentDataSet)
        let taxData = PieChartData(dataSet: taxDataSet)
        let transportData = PieChartData(dataSet: transportDataSet)
        
        clothesData.setValueTextColor(.white)
        electronikData.setValueTextColor(.white)
        foodData.setValueTextColor(.white)
        fuelData.setValueTextColor(.white)
        rentData.setValueTextColor(.white)
        taxData.setValueTextColor(.white)
        transportData.setValueTextColor(.white)
        
        let generalExpenseDataSet = PieChartDataSet(entries: generalExpenseEntries, label: "")
        generalExpenseDataSet.colors = ChartColorTemplates.colorful()
        
        if self.isGeneralExpense {
            let generalDataSet = PieChartDataSet(
                entries: generalExpenseEntries,
                label: "")
            generalDataSet.colors = [
                .red, .blue]
            
            let generalData = PieChartData(dataSet: generalDataSet)
            generalData.setValueTextColor(.white)
            self.expenseView.expenseChart.data = generalData
            self.expenseView.expenseChart.centerText = "General Expenses"
        } else {
            let combinedDataSet = PieChartDataSet(
                entries: clothesExpenseEntries + electronicExpenseEntries + foodExpenseEntries + fuelExpenseEntries + rentExpenseEntries + taxExpenseEntries,
                label: "")
            combinedDataSet.colors = [
                .red, .blue, .green, .yellow, .orange, .purple, .magenta
            ]
            
            let combinedData = PieChartData(dataSet: combinedDataSet)
            combinedData.setValueTextColor(.white)
            self.expenseView.expenseChart.data = combinedData
            self.expenseView.expenseChart.centerText = "Expenses"
        }
        self.expenseView.expenseChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }
}
