//
//  ReceivablesViewModel.swift
//  Compass
//
//  Created by Onur Emren on 5.02.2024.
//

import Foundation
import CoreData
import UIKit

class ReceivablesViewModel {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func saveReceiVables(receivablesAmountTextField: String?,
                          dateTextField: String?,
                          personTextField: String?) {
        
        guard let receivablesAmountTextField = Double(receivablesAmountTextField ?? ""),
              let personTextField = personTextField,
              let dateTextField = dateTextField
        else {
            print("Geçersiz veri")
            return
        }
        
        do {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            if let receivablesEntity = NSEntityDescription.insertNewObject(
                forEntityName: "ReceivablesEntry",
                into: context) as? ReceivablesEntry {
                receivablesEntity.receivablesAmount  = receivablesAmountTextField
                receivablesEntity.person = personTextField
                receivablesEntity.date = dateTextField
                
                do {
                    try context.save()
                    print("Veri başarıyla kaydedildi.")
                } catch {
                    print("Veri kaydedilemedi. Hata: \(error)")
                }
            }
        }
    }
}
