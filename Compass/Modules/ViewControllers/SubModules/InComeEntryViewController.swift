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
        
        if var incomeEntity = NSEntityDescription.insertNewObject(forEntityName: "InComeEntry", into: context) as? InComeEntry {
            incomeEntity.wage = income
            incomeEntity.sideInCome = sideIncome
          
            do {
                try context.save()
                showToast(message: "Kayıt Başarılı!")
                print("Veri başarıyla kaydedildi.")
            } catch {
                print("Veri kaydedilemedi. Hata: \(error)")
            }
        }
    }
}

extension IncomeEntryViewController {
    func showToast(message: String) {
        let toastLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 35))
        toastLabel.center = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 2)
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 12)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { (isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
