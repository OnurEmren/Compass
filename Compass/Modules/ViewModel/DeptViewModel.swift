//
//  DeptViewModel.swift
//  Compass
//
//  Created by Onur Emren on 10.02.2024.
//

import Foundation
import CoreData
import UIKit

class DeptViewModel {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func saveDept(deptAmountText: String?,
                          dateTextField: String?,
                          personTextField: String?) {
        
        guard let deptAmountText = Double(deptAmountText ?? ""),
              let personTextField = personTextField,
              let dateTextField = dateTextField
        else {
            print("Geçersiz veri")
            return
        }
        
        do {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            if let deptEntity = NSEntityDescription.insertNewObject(
                forEntityName: "DeptEntry",
                into: context) as? DeptEntry {
                deptEntity.deptAmount  = deptAmountText
                deptEntity.person = personTextField
                deptEntity.date = dateTextField
                
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
