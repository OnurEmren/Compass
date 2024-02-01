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
    var isGeneralExpense = false
    private var expenseViewModel = ExpenseViewModel()
    var entityName = "ExpenseEntry"
    private var expenseView = ExpenseView()
    
    private let segmentedControl: UISegmentedControl = {
        let items = ["Detay Harcamalar", "Genel Harcamalar"]
        let segmented = UISegmentedControl(items: items)
        segmented.selectedSegmentIndex = 0
        return segmented
    }()

    private var fetchedGeneralData: [GeneralExpenseEntry] = []
    private var fetchedDetailData: [ExpenseEntry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        setupNavigationSettings()
        setupView()
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .allEvents)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if entityName == "GeneralExpenseEntry" {
            segmentedControl.selectedSegmentIndex = 1
            fetchDataFromCoreData()
        } else {
            segmentedControl.selectedSegmentIndex = 0
            fetchDetailData()
        }
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
        view.addSubview(segmentedControl)
        
        expenseView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(90)
        }
        
        segmentedControl.layer.borderWidth = 0.7
        segmentedControl.layer.borderColor = UIColor.white.cgColor
        segmentedControl.backgroundColor = .gray
        segmentedControl.tintColor = .black
        
        expenseView.addButton.addTarget(self, action: #selector(goToAddExpense), for: .touchUpInside)
        expenseView.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            fetchDetailData()
            entityName = "ExpenseEntry"
            setupDetailExpenseChart(expenseData: fetchedDetailData)
            break
        case 1:    
            fetchDataFromCoreData()
            setupCombinedChart(generalData: fetchedGeneralData)
            break
        default:
            break
        }
    }
    
    @objc
    private func rightAddButtonTapped() {
        entityName = "GeneralExpenseEntity"
        coordinator?.eventOccured(with: .goToGeneralExpenseVC)
    }
    
    private func fetchDetailData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ExpenseEntry")
        
        do {
            let fetchedDetailData = try context.fetch(fetchRequest) as! [ExpenseEntry]
            let totalExpense = fetchedDetailData.reduce(0) { (result, entry) in
                return result + entry.totalExpense
            }
            self.expenseView.totalExpenseLabel.text = "Toplam Detay Gider: \(totalExpense)"
            
            for entry in fetchedDetailData {
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
            self.setupDetailExpenseChart(expenseData: fetchedDetailData)
            self.fetchedDetailData = fetchedDetailData
        } catch {
            print("Veri çekme hatası: \(error)")
        }
        
    }
    
    
    private func fetchDataFromCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchGeneralData = NSFetchRequest<NSFetchRequestResult>(entityName: "GeneralExpenseEntry")
        do {
            let fetchedGeneralData = try context.fetch(fetchGeneralData) as! [GeneralExpenseEntry]
            let totalIncome = fetchedGeneralData.reduce(0) { (result, entry) in
                return result + entry.creditCardExpense + entry.rentExpense
            }
            self.expenseView.totalExpenseLabel.text = "Toplam Genel Gider: \(totalIncome)"
            
            for entry in fetchedGeneralData {
                let rentExpense = entry.rentExpense
                let creditCardExpense = entry.creditCardExpense
                let expenseTotal = rentExpense + creditCardExpense
                
                self.expenseView.totalExpenseLabel.text = "\(expenseTotal)"
            }
            self.setupCombinedChart(generalData: fetchedGeneralData)
            self.fetchedGeneralData = fetchedGeneralData
        } catch {
            print("General data çekme hatası \(error)")
        }
        
    }
    
    private func setupDetailExpenseChart(expenseData: [ExpenseEntry]) {
        var clothesExpenseEntries: [PieChartDataEntry] = []
        var electronicExpenseEntries: [PieChartDataEntry] = []
        var foodExpenseEntries: [PieChartDataEntry] = []
        var fuelExpenseEntries: [PieChartDataEntry] = []
        var rentExpenseEntries: [PieChartDataEntry] = []
        var taxExpenseEntries: [PieChartDataEntry] = []
        var transportEntries: [PieChartDataEntry] = []
        
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
        self.expenseView.expenseChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)

        
    }
    
    private func setupCombinedChart(generalData: [GeneralExpenseEntry]) {
        let generalExpenseEntries = expenseViewModel.getGeneralExpenseChartData(generalData: generalData)
        
        let generalExpenseDataSet = PieChartDataSet(entries: generalExpenseEntries, label: "")
        generalExpenseDataSet.colors = ChartColorTemplates.colorful()
        
        let generalDataSet = PieChartDataSet(
            entries: generalExpenseEntries,
            label: "")
        generalDataSet.colors = [.red, .blue]
        
        let generalData = PieChartData(dataSet: generalDataSet)
        generalData.setValueTextColor(.white)
        
        self.expenseView.expenseChart.data = generalData
        self.expenseView.expenseChart.centerText = "General Expenses"
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
