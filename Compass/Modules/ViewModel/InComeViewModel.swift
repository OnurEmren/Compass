//
//  InComeViewModel.swift
//  Compass
//
//  Created by Onur Emren on 1.02.2024.
//

import Foundation
import CoreData
import UIKit
import DGCharts

protocol InComeViewModelDelegate: AnyObject {
    func didFetchedInComeData(inComeData: [InComeEntry])
}

class InComeViewModel {
    private var inComeView = InComeView()
    weak var delegate: InComeViewModelDelegate?
    
    func fetchDataFromCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "InComeEntry")
        
        do {
            let fetchedData = try context.fetch(fetchRequest) as! [InComeEntry]
            var totalWage = 0.0
            var totalSideIncome = 0.0

            for entry in fetchedData {
                let salary = entry.wage
                let sideInCome = entry.sideInCome

                totalWage += salary
                totalSideIncome += sideInCome
            }

            delegate?.didFetchedInComeData(inComeData: fetchedData)
        } catch {
            print("Veri çekme hatası: \(error)")
        }
    }
    
    func deleteLastIncomeEntry() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<InComeEntry> = InComeEntry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "wage", ascending: false)]
        fetchRequest.fetchLimit = 1
        
        do {
            let result = try context.fetch(fetchRequest)
            
            if let lastIncomeEntry = result.first {
                context.delete(lastIncomeEntry)
                
                try context.save()
            }
        } catch {
            print("Hata: \(error)")
        }
    }
    
    func getInComeChartData(generalData: [InComeEntry]) -> [PieChartDataEntry] {
        var InComeEntries: [PieChartDataEntry] = []
        
        for (_, entry) in generalData.enumerated() {
            let wageEntry = PieChartDataEntry(value: entry.wage, label: "Genel Maaş \(entry.wage)")
            InComeEntries.append(wageEntry)
            
            let sideInCome = PieChartDataEntry(value: entry.sideInCome, label: "Yan Gelir")
            InComeEntries.append(sideInCome)
        }
        
        return InComeEntries
    }
}

