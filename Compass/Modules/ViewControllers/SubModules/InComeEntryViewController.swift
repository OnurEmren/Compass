//
//  InComeEntryViewController.swift
//  Compass
//
//  Created by Onur Emren on 18.01.2024.
//

import UIKit
import SnapKit
import CoreData

class IncomeEntryViewController: UIViewController, IncomeTypePickerViewDelegate, IncomeEntryViewDelegate,InComeUpdateViewDelegate, Coordinating {
    
    var coordinator: Coordinator?
    
    private let incomeEntryView = InComeEntryPickerView()
    private let font = UIFont(name: "Tahoma", size: 18.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.inComeEntryTitle
        view.backgroundColor = Colors.piesGreenColor
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = UIColor.white
        
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: font!, NSAttributedString.Key.foregroundColor: UIColor.white]
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(incomeEntryView)
        
        incomeEntryView.saveDelegate = self
        incomeEntryView.delegate = self
        incomeEntryView.updateDelegate = self
        incomeEntryView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func didTapSaveButton(incomeText: String?, sideIncomeText: String?, inComeType: String?, currency: String?, month: String?) {
        guard let income = Double(incomeText ?? ""),
              let sideIncome = Double(sideIncomeText ?? ""),
              let inComeType = inComeType,
              let currency = currency else {
            print("Geçersiz veri")
            return
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        if let incomeEntity = NSEntityDescription.insertNewObject(forEntityName: "InComeEntry", into: context) as? InComeEntry {
            incomeEntity.wage = income
            incomeEntity.sideInCome = sideIncome
            incomeEntity.inComeType = inComeType
            incomeEntity.currency = currency
            incomeEntity.month = month
            do {
                try context.save()
                showToast(message: "Kayıt Başarılı!")
                print("Veri başarıyla kaydedildi.")
            } catch {
                print("Veri kaydedilemedi. Hata: \(error)")
            }
        }
    }
    
    func didTapUpdateButton(inComeType: String?, newWage: String, newSideInCome: String) {
        guard let inComeType = inComeType,
              let newWage = Double(newWage),
              let newSideInCome = Double(newSideInCome) else {
            print("Geçersiz veri")
            return
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<InComeEntry>(entityName: "InComeEntry")
        fetchRequest.predicate = NSPredicate(format: "inComeType == %@", inComeType)
        
        do {
            let fetchedData = try context.fetch(fetchRequest)
            print("Fetched Data: \(fetchedData)")
            
            if let existingInComeEntry = fetchedData.first {
                existingInComeEntry.wage = newWage
                existingInComeEntry.sideInCome = newSideInCome
                
                do {
                    try context.save()
                    print("Veri Güncellendi: \(existingInComeEntry)")
                } catch {
                    print("Veri güncelleme hatası: \(error)")
                }
            } else {
                print("Güncellenecek veri bulunamadı.")
            }
        } catch {
            print("Veri çekme hatası: \(error)")
        }
    }
    
    func didSelectIncomeType(_ incomeType: String) {
        //
    }
}
