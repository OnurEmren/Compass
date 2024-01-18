//
//  InComeEntryViewController.swift
//  Compass
//
//  Created by Onur Emren on 18.01.2024.
//

import UIKit
import SnapKit
import CoreData

class IncomeEntryViewController: UIViewController, IncomeEntryViewDelegate,Coordinating {
    var coordinator: Coordinator?
    
    private let incomeEntryView = IncomeEntryView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(incomeEntryView)
        
        incomeEntryView.delegate = self
        
        incomeEntryView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func didTapSaveButton(incomeText: String?, sideIncomeText: String?) {
        guard let income = Double(incomeText ?? ""), let sideIncome = Double(sideIncomeText ?? "") else {
            print("Geçersiz veri")
            return
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        if var incomeEntity = NSEntityDescription.insertNewObject(forEntityName: "Income", into: context) as? InComeEntry {
            incomeEntity.wage = income
            incomeEntity.sideInCome = sideIncome
          
            do {
                try context.save()
                print("Veri başarıyla kaydedildi.")
            } catch {
                print("Veri kaydedilemedi. Hata: \(error)")
            }
        }
    }
}
