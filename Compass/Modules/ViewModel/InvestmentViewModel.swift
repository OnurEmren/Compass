//
//  InvestmentViewModel.swift
//  Compass
//
//  Created by Onur Emren on 26.01.2024.
//

import Foundation
import CoreData
import UIKit

class InvestmentViewModel {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func saveInvestments(invesmentType: String, amount: Double, selectedDate: Date, purchase: Double, piece: Double) {
        let entity = NSEntityDescription.entity(forEntityName: "InvestmentEntry", in: context)!
        let investmentData = NSManagedObject(entity: entity, insertInto: context)
        investmentData.setValue(invesmentType, forKey: "investmentType")
        investmentData.setValue(amount, forKey: "investmentAmount")
        investmentData.setValue(selectedDate, forKey: "date")
        investmentData.setValue(purchase, forKey: "purchase")
        investmentData.setValue(piece, forKey: "piece")
        
        do {
            try context.save()
            print("Kayıt başarılı")
        } catch {
            print("Hata: \(error.localizedDescription)")
        }
    }
}
