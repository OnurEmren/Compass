//
//  InvestmentViewModel.swift
//  Compass
//
//  Created by Onur Emren on 26.01.2024.
//

import Foundation
import CoreData

protocol InvestmentViewModelDelegate: AnyObject {
    func didSaveLesson()
}

class InvestmentViewModel {
    weak var delegate: InvestmentViewModelDelegate?
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func saveLesson(invesmentType: String, amount: Double, selectedDate: Date) {
        let entity = NSEntityDescription.entity(forEntityName: "InvestmentEntry", in: context)!
        let newLesson = NSManagedObject(entity: entity, insertInto: context)
        newLesson.setValue(invesmentType, forKey: "investmentType")
        newLesson.setValue(amount, forKey: "amount")
        newLesson.setValue(selectedDate, forKey: "date")
        
        do {
            try context.save()
            delegate?.didSaveLesson()
            print("Kayıt başarılı")
        } catch {
            print("Hata: \(error.localizedDescription)")
        }
    }
}
