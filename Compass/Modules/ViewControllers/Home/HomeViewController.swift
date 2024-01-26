//
//  ViewController.swift
//  Compass
//
//  Created by Onur Emren on 17.01.2024.
//

import UIKit
import CoreData
import DGCharts

class HomeViewController: UIViewController, Coordinating, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var coordinator: Coordinator?
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(FinanceCardCell.self, forCellWithReuseIdentifier: FinanceCardCell.reuseIdentifier)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    let data = [("Gelir", UIColor.systemGreen), ("Gider", UIColor.red), ("Genel", UIColor.blue)]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        view.backgroundColor = Colors.beigeColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    //MARK: - Private Methods
    
    //Setupview
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.backgroundColor = Colors.piesGreenColor
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func fetchInComeData() -> [InComeEntry] {
        var incomeEntries: [InComeEntry] = []

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<InComeEntry>(entityName: "InComeEntry")

        do {
            incomeEntries = try context.fetch(fetchRequest)
        } catch {
            print("Veri çekme hatası: \(error)")
        }

        return incomeEntries
    }

    func fetchExpenseData() -> [ExpenseEntry] {
          var expenseEntries: [ExpenseEntry] = []

          let appDelegate = UIApplication.shared.delegate as! AppDelegate
          let context = appDelegate.persistentContainer.viewContext
          let fetchExpenseRequest = NSFetchRequest<ExpenseEntry>(entityName: "ExpenseEntry")

          do {
              expenseEntries = try context.fetch(fetchExpenseRequest)
          } catch {
              print("Gider verisi çekme hatası: \(error)")
          }

          return expenseEntries
      }
        
    //MARK: - CollectionView Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FinanceCardCell.reuseIdentifier, for: indexPath) as! FinanceCardCell
        let (title, color) = data[indexPath.item]

        let inComeData = fetchInComeData()
        let expenseData = fetchExpenseData()
        let totalIncome = inComeData.reduce(0) { (result, entry) in
            return result + entry.wage
        }
        
        let totalExpense = expenseData.reduce(0) { (result, entry) in
            let total = entry.clothesExpense + entry.electronicExpense + entry.foodExpense + entry.fuelExpense + entry.rentExpense + entry.taxExpense + entry.transportExpense
            return result + total
        }
        
        if title == "Gelir" {
            cell.configure(with: title, backgroundColor: color, overallStatus: totalIncome)

        } else if title == "Gider" {
            let totalExpense = expenseData.reduce(0) { (result, entry) in
                let total = entry.clothesExpense + entry.electronicExpense + entry.foodExpense + entry.fuelExpense + entry.rentExpense + entry.taxExpense + entry.transportExpense
                return result + total
            }
            
            cell.configure(with: title, backgroundColor: color, overallStatus: totalExpense)

        } else if title == "Genel" {
            
            let overallStatus = totalIncome - totalExpense 
            cell.configure(with: title, backgroundColor: color, overallStatus: overallStatus)
        }        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 40
        let height: CGFloat = 200
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = indexPath.row
        coordinator?.eventOccured(with: .goToDetailVC(for: selectedItem))
    }
}

