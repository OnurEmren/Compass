//
//  ExpenseEntryViewController.swift
//  Compass
//
//  Created by Onur Emren on 21.01.2024.
//

import UIKit
import CoreData

class ExpenseEntryViewController: UIViewController, Coordinating, ExpenseEntryViewDelegate, ExpenseTypePickerViewDelegate {

    var coordinator: Coordinator?
    var expenseEntryView = ExpenseEntryView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Giderlerinizi Girin"
        view.backgroundColor = Colors.piesGreenColor
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        setupView()

    }
    
    private func setupView() {
        view.addSubview(expenseEntryView)
        
        expenseEntryView.saveDelegate = self
        expenseEntryView.delegate = self
       // expenseEntryView.updateDelegate = self
        expenseEntryView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func didTapSaveButton(clothesExpenseText: String?, 
                          electronicExpenseText: String?,
                          fuelExpenseText: String?,
                          foodExpenseText: String?,
                          rentExpenseText: String?,
                          taxExpenseText: String?,
                          transportText: String?,
                          month: String?
    ) {
        guard let clothesExpense = Double(clothesExpenseText ?? ""),
              let electronicExpense = Double(electronicExpenseText ?? ""),
              let fuelExpense = Double(fuelExpenseText ?? ""),
              let foodExpense = Double(foodExpenseText ?? ""),
              let rentExpense = Double(rentExpenseText ?? ""),
              let taxExpense = Double(taxExpenseText ?? ""),
              let transportExpense = Double(transportText ?? ""),
              let month = month
        else {
            print("Geçersiz veri")
            return
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        if var expenseEntity = NSEntityDescription.insertNewObject(forEntityName: "ExpenseEntry", into: context) as? ExpenseEntry {
            expenseEntity.clothesExpense = clothesExpense
            expenseEntity.electronicExpense = electronicExpense
            expenseEntity.foodExpense = foodExpense
            expenseEntity.fuelExpense = fuelExpense
            expenseEntity.rentExpense = rentExpense
            expenseEntity.taxExpense = taxExpense
            expenseEntity.transportExpense = transportExpense
            expenseEntity.month = month
            do {
                try context.save()
                print("Veri başarıyla kaydedildi.")
            } catch {
                print("Veri kaydedilemedi. Hata: \(error)")
            }
        }
    }
    
    func didSelectIncomeType(_ incomeType: String) {
        //
    }

}
