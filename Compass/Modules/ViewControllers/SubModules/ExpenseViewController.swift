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
    private let expenseChart: PieChartView = {
        let chartView = PieChartView()
        chartView.layer.cornerRadius = 20
        chartView.layer.masksToBounds = true
        return chartView
    }()
    
    private let totalExpenseLabel = UIExtensions.createLabel(
        text: "0.0",
        fontSize: Fonts.generalFont!.pointSize,
        alignment: .center)
    private let expenseDistributionLabel = UIExtensions.createLabel(
        text: "Gider Dağılımı:",
        fontSize: 18,
        alignment: .left)
    private let monthLabel = UIExtensions.createLabel(
        text: "Ay:",
        fontSize: 18,
        alignment: .left)
    private let addButton = UIExtensions.createButton(
        title: "Detaylı Gider Ekle",
        backgroundColor: Colors.buttonColor,
        cornerRadius: 10,
        target: self,
        action: #selector(goToAddExpense),
        font: Fonts.generalFont!)
    private let deleteButton = UIExtensions.createButton(
        title: "Sil",
        backgroundColor: .red,
        cornerRadius: 10,
        target: nil,
        action: #selector(deleteButtonTapped),
        font: Fonts.generalFont!)
    private var entityName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.piesGreenColor
        setupNavigationSettings()
        setupView()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(rightAddButtonTapped)
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if entityName == "ExpenseEntry" {
            fetchDataFromCoreData(entityName: "ExpenseEntry")
        } else {
            fetchGeneralExpenseCoreData()
        }
    }
    
    private func setupNavigationSettings() {
        title = Strings.expenseTitle
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    private func setupView() {
        view.addSubview(expenseChart)
        view.addSubview(totalExpenseLabel)
        view.addSubview(monthLabel)
        view.addSubview(addButton)
        view.addSubview(deleteButton)
        
        monthLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        monthLabel.textColor = Colors.lightThemeColor
        
        totalExpenseLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(monthLabel).offset(30)
        }
        totalExpenseLabel.textColor = Colors.lightThemeColor
        
        expenseChart.snp.makeConstraints { make in
            make.top.equalTo(totalExpenseLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(300)
        }
        expenseChart.backgroundColor = .white
        let legend = expenseChart.legend
        legend.verticalAlignment = .bottom
        legend.horizontalAlignment = .center
        legend.orientation = .horizontal
        legend.formSize = 10
        legend.font = UIFont(name: "Tahoma", size: 12) ?? .systemFont(ofSize: 12)
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(expenseChart.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(40)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(addButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func rightAddButtonTapped() {
        coordinator?.eventOccured(with: .goToGeneralExpenseVC)
        entityName = "GeneralExpenseEntry"
        isGeneralExpense = true
    }
    
    private func fetchDataFromCoreData(entityName: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
      
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            DispatchQueue.main.async {
                do {
                    let fetchedData = try context.fetch(fetchRequest) as! [ExpenseEntry]
                    let totalIncome = fetchedData.reduce(0) { (result, entry) in
                        return result + entry.totalExpense
                    }
                    self.totalExpenseLabel.text = "Toplam Gider: \(totalIncome)"
                    
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
                        self.totalExpenseLabel.text = "\(expenseTotal)"
                        self.monthLabel.text = month
                    }
                    self.setupCombinedChart(expenseData: fetchedData, generalData: [])
                } catch {
                    print("Veri çekme hatası: \(error)")
            }
        }
    }
    
    private func fetchGeneralExpenseCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchGeneralData = NSFetchRequest<NSFetchRequestResult>(entityName: "GeneralExpenseEntry")
        
        DispatchQueue.main.async {
            do {
                let fetchedData = try context.fetch(fetchGeneralData) as! [GeneralExpenseEntry]
                let totalIncome = fetchedData.reduce(0) { (result, entry) in
                    return result + entry.creditCardExpense + entry.rentExpense
                }
                self.totalExpenseLabel.text = "Toplam Gider: \(totalIncome)"
                
                for entry in fetchedData {
                    let rentExpense = entry.rentExpense
                    let creditCardExpense = entry.creditCardExpense
                    let expenseTotal = rentExpense + creditCardExpense
                    
                    self.totalExpenseLabel.text = "\(expenseTotal)"
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
    
        if isGeneralExpense {
            let generalDataSet = PieChartDataSet(
                entries: generalExpenseEntries,
                label: "")
            generalDataSet.colors = [
                .red, .blue]

            let generalData = PieChartData(dataSet: generalDataSet)
            generalData.setValueTextColor(.white)
            expenseChart.data = generalData
            expenseChart.centerText = "General Expenses"
        } else {
            let combinedDataSet = PieChartDataSet(
                entries: clothesExpenseEntries + electronicExpenseEntries + foodExpenseEntries + fuelExpenseEntries + rentExpenseEntries + taxExpenseEntries,
                label: "")
            combinedDataSet.colors = [
                .red, .blue, .green, .yellow, .orange, .purple, .magenta
            ]

            let combinedData = PieChartData(dataSet: combinedDataSet)
            combinedData.setValueTextColor(.white)
            expenseChart.data = combinedData
            expenseChart.centerText = "Expenses"
        }
        expenseChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
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
                    self.deleteLastIncomeEntry()
                }
                alertController.addAction(cancelAction)
                alertController.addAction(deleteAction)
                present(alertController, animated: true, completion: nil)
            }
        } catch {
            print("Hata: \(error)")
        }
    }
    
    func deleteLastIncomeEntry() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<ExpenseEntry> = ExpenseEntry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "transportExpense", ascending: false)]
        fetchRequest.fetchLimit = 1
        
        do {
            let result = try context.fetch(fetchRequest)
            
            if let lastIncomeEntry = result.first {
                context.delete(lastIncomeEntry)
                try context.save()
            }
        } catch {
            print("Hata: \(error)")
        }
    }
}
