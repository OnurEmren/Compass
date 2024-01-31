//
//  ExpenseViewController.swift
//  Compass
//
//  Created by Onur Emren on 17.01.2024.
//

import UIKit
import Charts
import SnapKit
import DGCharts
import CoreData

class ExpenseViewController: UIViewController, Coordinating {
    var coordinator: Coordinator?
    var isGeneralExpense = true
    private var expenseViewModel = ExpenseViewModel()
    private var entityName = "GeneralExpenseEntry"
    private var expenseView = ExpenseView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        entityName = "GeneralExpenseEntry"
        view.backgroundColor = .black
        setupNavigationSettings()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchDataFromCoreData()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]

    }
    
    private func setupNavigationSettings() {
        title = Strings.expenseTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(rightAddButtonTapped)
        )
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil
        )
        
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    private func setupView() {
        view.addSubview(expenseView)
        expenseView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
            
        expenseView.addButton.addTarget(self, action: #selector(goToAddExpense), for: .touchUpInside)
        expenseView.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func rightAddButtonTapped() {
        coordinator?.eventOccured(with: .goToGeneralExpenseVC)
        entityName = "GeneralExpenseEntry"
        isGeneralExpense = true
    }
    
    private func fetchDataFromCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        if entityName == "ExpenseEntry" {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ExpenseEntry")
            
                do {
                    let fetchedData = try context.fetch(fetchRequest) as! [ExpenseEntry]
                    let totalIncome = fetchedData.reduce(0) { (result, entry) in
                        return result + entry.totalExpense
                    }
                    self.expenseView.totalExpenseLabel.text = "Toplam Gider: \(totalIncome)"
                    
                    for entry in fetchedData {
                        let clothesExpense = entry.clothesExpense
                        let electronicExpense = entry.electronicExpense
                        let fuelExpense = entry.fuelExpense
                        let rentExpense = entry.rentExpense
                        let transportExpense = entry.transportExpense
                        let foodExpense = entry.foodExpense
                        let taxExpense = entry.taxExpense
                        let expenseTotal = clothesExpense + electronicExpense + fuelExpense + rentExpense + transportExpense + foodExpense + taxExpense
                        let month = entry.month
                        self.expenseView.totalExpenseLabel.text = "\(expenseTotal)"
                        self.expenseView.monthLabel.text = month
                    }
                    self.setupCombinedChart(expenseData: fetchedData, generalData: [])
                } catch {
                    print("Veri çekme hatası: \(error)")
                }
            
        } else {
            let fetchGeneralData = NSFetchRequest<NSFetchRequestResult>(entityName: "GeneralExpenseEntry")
                do {
                    let fetchedData = try context.fetch(fetchGeneralData) as! [GeneralExpenseEntry]
                    let totalIncome = fetchedData.reduce(0) { (result, entry) in
                        return result + entry.creditCardExpense + entry.rentExpense
                    }
                    self.expenseView.totalExpenseLabel.text = "Toplam Gider: \(totalIncome)"
                    
                    for entry in fetchedData {
                        let rentExpense = entry.rentExpense
                        let creditCardExpense = entry.creditCardExpense
                        let expenseTotal = rentExpense + creditCardExpense
                        
                        self.expenseView.totalExpenseLabel.text = "\(expenseTotal)"
                    }
                    self.setupCombinedChart(expenseData: [], generalData: fetchedData )
                } catch {
                    print("General data çekme hatası \(error)")
                }
            
        }
    }
    
    private func setupCombinedChart(expenseData: [ExpenseEntry], generalData: [GeneralExpenseEntry]) {
        var clothesExpenseEntries: [PieChartDataEntry] = []
        var electronicExpenseEntries: [PieChartDataEntry] = []
        var foodExpenseEntries: [PieChartDataEntry] = []
        var fuelExpenseEntries: [PieChartDataEntry] = []
        var rentExpenseEntries: [PieChartDataEntry] = []
        var taxExpenseEntries: [PieChartDataEntry] = []
        var transportEntries: [PieChartDataEntry] = []
        var generalExpenseEntries: [PieChartDataEntry] = []
        
            for (_, entry) in expenseData.enumerated() {
                let clothesExpenseEntry = PieChartDataEntry(value: entry.clothesExpense, label: "Giyim")
                let electronicExpenseEntry = PieChartDataEntry(value: entry.electronicExpense, label: "Elektronik")
                let foodExpenseEntry = PieChartDataEntry(value: entry.foodExpense, label: "Gıda")
                let fuelExpenseEntry = PieChartDataEntry(value: entry.fuelExpense, label: "Yakıt")
                let rentExpenseEntry = PieChartDataEntry(value: entry.rentExpense, label: "Kira")
                let taxExpenseEntry = PieChartDataEntry(value: entry.taxExpense, label: "Faturalar")
                let transportEntry = PieChartDataEntry(value: entry.transportExpense, label: "Ulaşım")
                
                clothesExpenseEntries.append(clothesExpenseEntry)
                electronicExpenseEntries.append(electronicExpenseEntry)
                foodExpenseEntries.append(foodExpenseEntry)
                fuelExpenseEntries.append(fuelExpenseEntry)
                rentExpenseEntries.append(rentExpenseEntry)
                taxExpenseEntries.append(taxExpenseEntry)
                transportEntries.append(transportEntry)
            }
            
            for (_, entry) in generalData.enumerated() {
                let generalExpenseEntry = PieChartDataEntry(value: entry.creditCardExpense, label: "General \(entry.creditCardExpense)")
                generalExpenseEntries.append(generalExpenseEntry)
                
                let rentExpenseEntry = PieChartDataEntry(value: entry.rentExpense, label: "Kira")
                generalExpenseEntries.append(rentExpenseEntry)
            }
        
        
        let clothesDataSet = PieChartDataSet(entries: clothesExpenseEntries, label: "")
        clothesDataSet.colors = ChartColorTemplates.material()
        
        let electronicDataSet = PieChartDataSet(entries: electronicExpenseEntries, label: "")
        electronicDataSet.colors = ChartColorTemplates.colorful()
        
        let foodDataSet = PieChartDataSet(entries: foodExpenseEntries, label: "")
        foodDataSet.colors = ChartColorTemplates.colorful()
        
        let fuelDataSet = PieChartDataSet(entries: fuelExpenseEntries, label: "")
        fuelDataSet.colors = ChartColorTemplates.colorful()
        
        let rentDataSet = PieChartDataSet(entries: rentExpenseEntries, label: "")
        rentDataSet.colors = ChartColorTemplates.colorful()
        
        let taxDataSet = PieChartDataSet(entries: taxExpenseEntries, label: "")
        taxDataSet.colors = ChartColorTemplates.colorful()
        
        let transportDataSet = PieChartDataSet(entries: transportEntries, label: "")
        transportDataSet.colors = ChartColorTemplates.colorful()
        
        let clothesData = PieChartData(dataSet: clothesDataSet)
        let electronikData = PieChartData(dataSet: electronicDataSet)
        let foodData = PieChartData(dataSet: foodDataSet)
        let fuelData = PieChartData(dataSet: fuelDataSet)
        let rentData = PieChartData(dataSet: rentDataSet)
        let taxData = PieChartData(dataSet: taxDataSet)
        let transportData = PieChartData(dataSet: transportDataSet)
        
        clothesData.setValueTextColor(.white)
        electronikData.setValueTextColor(.white)
        foodData.setValueTextColor(.white)
        fuelData.setValueTextColor(.white)
        rentData.setValueTextColor(.white)
        taxData.setValueTextColor(.white)
        transportData.setValueTextColor(.white)
        
        let generalExpenseDataSet = PieChartDataSet(entries: generalExpenseEntries, label: "")
        generalExpenseDataSet.colors = ChartColorTemplates.colorful()
        
        if self.isGeneralExpense {
            let generalDataSet = PieChartDataSet(
                entries: generalExpenseEntries,
                label: "")
            generalDataSet.colors = [
                .red, .blue]
            
            let generalData = PieChartData(dataSet: generalDataSet)
            generalData.setValueTextColor(.white)
            self.expenseView.expenseChart.data = generalData
            self.expenseView.expenseChart.centerText = "General Expenses"
        } else {
            let combinedDataSet = PieChartDataSet(
                entries: clothesExpenseEntries + electronicExpenseEntries + foodExpenseEntries + fuelExpenseEntries + rentExpenseEntries + taxExpenseEntries,
                label: "")
            combinedDataSet.colors = [
                .red, .blue, .green, .yellow, .orange, .purple, .magenta
            ]
            
            let combinedData = PieChartData(dataSet: combinedDataSet)
            combinedData.setValueTextColor(.white)
            self.expenseView.expenseChart.data = combinedData
            self.expenseView.expenseChart.centerText = "Expenses"
        }
        self.expenseView.expenseChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }

    @objc
    private func goToAddExpense() {
        coordinator?.eventOccured(with: .goToExpenseEntryVC)
        entityName = "ExpenseEntry"
        isGeneralExpense = false
    }
    
    @objc
    func deleteButtonTapped() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ExpenseEntry> = ExpenseEntry.fetchRequest()
        let fetchGeneralRequest: NSFetchRequest<GeneralExpenseEntry> = GeneralExpenseEntry.fetchRequest()
        
        do {
            let result = try context.fetch(fetchRequest)
            
            if result.isEmpty {
                // Önceki veri yoksa
                let alertController = UIAlertController(
                    title: "Silme İptal Edildi",
                    message: "Önce bir veri eklemeniz gerekmektedir.",
                    preferredStyle: .alert
                )
                
                let cancelAction = UIAlertAction(title: "Tamam", style: .cancel) { _ in
                    self.dismiss(animated: true, completion: nil)
                }
                
                alertController.addAction(cancelAction)
                present(alertController, animated: true, completion: nil)
            } else {
                // Önceki veri varsa
                let alertController = UIAlertController(
                    title: "Sil",
                    message: "Bu öğeyi silmek istediğinizden emin misiniz?",
                    preferredStyle: .alert
                )
                
                let cancelAction = UIAlertAction(title: "İptal", style: .cancel) { _ in
                    print("Silme işlemi iptal edildi.")
                }
                
                let deleteAction = UIAlertAction(title: "Sil", style: .destructive) { _ in
                    self.deleteLastIncomeEntry(entityName: self.entityName)
                }
                alertController.addAction(cancelAction)
                alertController.addAction(deleteAction)
                present(alertController, animated: true, completion: nil)
            }
        } catch {
            print("Hata: \(error)")
        }
    }
    
    func deleteLastIncomeEntry(entityName: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        var fetchRequest: NSFetchRequest<NSFetchRequestResult>?
        
        if entityName == "ExpenseEntry" {
            let expenseFetchRequest: NSFetchRequest<ExpenseEntry> = ExpenseEntry.fetchRequest()
            expenseFetchRequest.sortDescriptors = [NSSortDescriptor(key: "transportExpense", ascending: false)]
            expenseFetchRequest.fetchLimit = 1
            fetchRequest = expenseFetchRequest as? NSFetchRequest<NSFetchRequestResult>
        } else if entityName == "GeneralExpenseEntry" {
            let generalFetchRequest: NSFetchRequest<GeneralExpenseEntry> = GeneralExpenseEntry.fetchRequest()
            generalFetchRequest.sortDescriptors = [NSSortDescriptor(key: "rentExpense", ascending: false)]
            generalFetchRequest.fetchLimit = 1
            fetchRequest = generalFetchRequest as? NSFetchRequest<NSFetchRequestResult>
        }
        
        if let fetchRequest = fetchRequest {
            do {
                let result = try context.fetch(fetchRequest)
                
                if let lastIncomeEntry = result.first as? NSManagedObject {
                    context.delete(lastIncomeEntry)
                    try context.save()
                }
            } catch {
                print("Hata: \(error)")
            }
        }
    }

}
