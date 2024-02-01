//
//  GeneralExpenseViewController.swift
//  Compass
//
//  Created by Onur Emren on 28.01.2024.
//

import UIKit
import CoreData

class GeneralExpenseViewController: UIViewController, Coordinating, GeneralExpenseSaveDelegate {
  
    var isGeneralExpense = true
    var coordinator: Coordinator?
    private var generalExpenseView = GeneralExpenseView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        generalExpenseView.generalExpenseDelegate = self
        navigationSettings()
        setupView()
        view.backgroundColor = .black
    }
    
    private func setupView() {
        view.addSubview(generalExpenseView)
        
        generalExpenseView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func navigationSettings() {
        title = "Gider Gir"
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    func didTapGeneralExpenseSave(rentExpenseText: String?, creditCardExpenseText: String?) {
        guard let rentExpenseText = Double(rentExpenseText ?? ""),
              let creditCardExpenseText = Double(creditCardExpenseText ?? "") else {
            return
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        if let expenseEntity = NSEntityDescription.insertNewObject(forEntityName: "GeneralExpenseEntry", into: context) as? GeneralExpenseEntry {
            
            expenseEntity.rentExpense = rentExpenseText
            expenseEntity.creditCardExpense = creditCardExpenseText
            
            do {
                try context.save()
            } catch {
                print("Genel Gider Kaydedilirken bir hata oluştu: \(error)")
            }
        }
    }
}
