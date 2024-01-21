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
    
    private let expenseChart: PieChartView = {
        let chartView = PieChartView()
        chartView.layer.cornerRadius = 20
        chartView.layer.masksToBounds = true
        return chartView
    }()
    
    private let totalExpenseLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "0.0"
        label.font = Fonts.bigNunitoFont
        return label
    }()
    
    private let expenseDistributionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .left
        label.font = Fonts.bigerNunitoFont
        label.text = "Gider Dağılımı:"
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Gider Ekle", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Colors.buttonColor
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.titleLabel?.font = Fonts.bigerNunitoFont
        button.addTarget(self, action: #selector(goToAddExpense), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = UIColor.white
        view.backgroundColor = .red
        
        setupView()
        fetchDataFromCoreData()
    }
    
    
    
    private func setupView() {
        view.addSubview(expenseChart)
        view.addSubview(totalExpenseLabel)
        view.addSubview(addButton)
        
        totalExpenseLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
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
        legend.font = UIFont(name: "Nunito-Bold", size: 12) ?? .systemFont(ofSize: 12)

        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(expenseChart.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(40)
        }
    }
    
    private func fetchDataFromCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ExpenseEntry")
        
        do {
            let fetchedData = try context.fetch(fetchRequest) as! [ExpenseEntry]
            let totalIncome = fetchedData.reduce(0) { (result, entry) in
                return result + entry.totalExpense
            }
            totalExpenseLabel.text = "Toplam Gider: \(totalIncome)"
            
            for entry in fetchedData {
                let clothesExpense = entry.clothesExpense
                let electronicExpense = entry.electronicExpense
                let fuelExpense = entry.fuelExpense
                let rentExpense = entry.rentExpense
                let transportExpense = entry.transportExpense
                let foodExpense = entry.foodExpense
                let taxExpense = entry.taxExpense
                let expenseTotal = clothesExpense + electronicExpense + fuelExpense + rentExpense + transportExpense + foodExpense + taxExpense
                
                totalExpenseLabel.text = "\(expenseTotal)"

            }
            setupExpenseChart(with: fetchedData)
        } catch {
            print("Veri çekme hatası: \(error)")
        }
    }
    
    private func setupExpenseChart(with data: [ExpenseEntry]) {
        var clothesExpenseEntries: [PieChartDataEntry] = []
        var electronicExpenseEntries: [PieChartDataEntry] = []
        var foodExpenseEntries: [PieChartDataEntry] = []
        var fuelExpenseEntries: [PieChartDataEntry] = []
        var rentExpenseEntries: [PieChartDataEntry] = []
        var taxExpenseEntries: [PieChartDataEntry] = []
        
        for (index, entry) in data.enumerated() {
            let clothesExpenseEntry = PieChartDataEntry(value: entry.clothesExpense, label: "Giyim")
            let electronicExpenseEntry = PieChartDataEntry(value: entry.electronicExpense, label: "Elektronik")
            let foodExpenseEntry = PieChartDataEntry(value: entry.foodExpense, label: "Gıda")
            let fuelExpenseEntry = PieChartDataEntry(value: entry.fuelExpense, label: "Yakıt")
            let rentExpenseEntry = PieChartDataEntry(value: entry.rentExpense, label: "Ulaşım")
            let taxExpenseEntry = PieChartDataEntry(value: entry.taxExpense, label: "Faturalar")
            
            clothesExpenseEntries.append(clothesExpenseEntry)
            electronicExpenseEntries.append(electronicExpenseEntry)
            foodExpenseEntries.append(foodExpenseEntry)
            fuelExpenseEntries.append(fuelExpenseEntry)
            rentExpenseEntries.append(rentExpenseEntry)
            taxExpenseEntries.append(taxExpenseEntry)
            
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
        
        let clothesData = PieChartData(dataSet: clothesDataSet)
        let electronikData = PieChartData(dataSet: electronicDataSet)
        let foodData = PieChartData(dataSet: foodDataSet)
        let fuelData = PieChartData(dataSet: fuelDataSet)
        let rentData = PieChartData(dataSet: rentDataSet)
        let taxData = PieChartData(dataSet: taxDataSet)
        
        clothesData.setValueTextColor(.white)
        electronikData.setValueTextColor(.white)
        foodData.setValueTextColor(.white)
        fuelData.setValueTextColor(.white)
        rentData.setValueTextColor(.white)
        taxData.setValueTextColor(.white)
        
        let combinedDataSet = PieChartDataSet(
            entries: clothesExpenseEntries + electronicExpenseEntries + foodExpenseEntries + fuelExpenseEntries + rentExpenseEntries + taxExpenseEntries,
            label: "")
        
        combinedDataSet.colors = [
            .red,
            Colors.piesGreenColor,
            .blue,
            Colors.darkThemeColor,
            .orange,
            .purple,
            .magenta
        ]
        
        let combinedData = PieChartData(dataSet: combinedDataSet)
        combinedData.setValueTextColor(.white)
        
        expenseChart.data = combinedData
        expenseChart.centerText = "Giderler"
        expenseChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }
    
    @objc
    private func goToAddExpense() {
        coordinator?.eventOccured(with: .goToExpenseEntryVC)
    }
}
