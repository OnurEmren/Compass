//
//  ExpenseEntryViewController.swift
//  Compass
//
//  Created by Onur Emren on 21.01.2024.
//

import UIKit
import CoreData

class ExpenseEntryViewController: UIViewController, Coordinating, ExpenseEntryViewDelegate {

    var coordinator: Coordinator?
    var expenseEntryView = ExpenseEntryView()
    var isGeneralExpense = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Giderlerinizi Girin"
        view.backgroundColor = .black
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let saveButton = UIBarButtonItem(
            title: "Kaydet",
            style: .done,
            target: self,
            action: #selector(saveButtonTapped)
        )
        navigationItem.rightBarButtonItem = saveButton

        setupView()

    }
    
    private func setupView() {
        view.addSubview(expenseEntryView)
        
        expenseEntryView.saveDelegate = self
        expenseEntryView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func didTapSaveButton(clothesExpenseText: String?, 
                          fuelExpenseText: String?,
                          foodExpenseText: String?,
                          rentExpenseText: String?,
                          taxExpenseText: String?,
                          month: String?
    ) {
        guard let clothesExpense = Double(clothesExpenseText ?? ""),
              let fuelExpense = Double(fuelExpenseText ?? ""),
              let foodExpense = Double(foodExpenseText ?? ""),
              let rentExpense = Double(rentExpenseText ?? ""),
              let taxExpense = Double(taxExpenseText ?? ""),
              let month = month
        else {
            print("Geçersiz veri")
            return
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        if let expenseEntity = NSEntityDescription.insertNewObject(forEntityName: "ExpenseEntry", into: context) as? ExpenseEntry {
            expenseEntity.clothesExpense = clothesExpense
            expenseEntity.foodExpense = foodExpense
            expenseEntity.fuelExpense = fuelExpense
            expenseEntity.rentExpense = rentExpense
            expenseEntity.taxExpense = taxExpense
            expenseEntity.month = month
            do {
                try context.save()
                showToastExpenseEntry(message: "Giderler kaydedildi.")
                print("Veri başarıyla kaydedildi.")
            } catch {
                print("Veri kaydedilemedi. Hata: \(error)")
            }
        }
    }
    
    @objc
    private func saveButtonTapped() {
        expenseEntryView.saveButtonTapped()
    }
}

extension ExpenseEntryViewController {
    func showToastExpenseEntry(message: String) {
        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 150, y: view.frame.size.height-100, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.boldSystemFont(ofSize: 15)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds  =  true
        view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 1.5, delay: 0.2, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
}
