//
//  ExpenseView.swift
//  Compass
//
//  Created by Onur Emren on 28.01.2024.
//

import Foundation
import UIKit
import DGCharts

class ExpenseView: UIView {
    let expenseChart: PieChartView = {
        let chartView = PieChartView()
        chartView.layer.cornerRadius = 20
        chartView.layer.masksToBounds = true
        return chartView
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Detaylı Gider Ekle", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = Colors.tryColor
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.titleLabel?.font = Fonts.generalFont
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Gider Sil", for: .normal)
        button.backgroundColor = .red
        button.titleLabel?.font = Fonts.generalFont
        button.layer.cornerRadius = 10
        return button
    }()
    
    let totalExpenseLabel = UIExtensions.createLabel(
        text: "Giderlerim: 0.0",
        fontSize: Fonts.generalFont!.pointSize,
        alignment: .center)
    let expenseDistributionLabel = UIExtensions.createLabel(
        text: "Gider Dağılımı:",
        fontSize: 18,
        alignment: .left)
    let monthLabel = UIExtensions.createLabel(
        text: "Ay:",
        fontSize: 18,
        alignment: .left)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(totalExpenseLabel)
        addSubview(monthLabel)
        addSubview(expenseChart)
        addSubview(addButton)
        addSubview(deleteButton)
        
        monthLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
        }
        monthLabel.textColor = Colors.lightThemeColor
        
        totalExpenseLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(monthLabel).offset(30)
        }
        totalExpenseLabel.textColor = Colors.lightThemeColor
        
        expenseChart.snp.makeConstraints { make in
            make.top.equalTo(totalExpenseLabel.snp.top).offset(80)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(300)
        }
        expenseChart.backgroundColor = .white
        
        let legend = expenseChart.legend
        legend.verticalAlignment = .bottom
        legend.horizontalAlignment = .center
        legend.orientation = .horizontal
        legend.formSize = 12
        legend.font = UIFont(name: "MalayalamSangamMN", size: 12) ?? .systemFont(ofSize: 12)
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(expenseChart.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.lessThanOrEqualTo(safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(40)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(addButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
    }
    
    func setupCombinedChart(generalData: [GeneralExpenseEntry]) {
        var generalExpenseEntries: [PieChartDataEntry] = []
        
        for (_, entry) in generalData.enumerated() {
            let generalExpenseEntry = PieChartDataEntry(value: entry.creditCardExpense, label: "Kredi Kartı \(entry.creditCardExpense)")
            generalExpenseEntries.append(generalExpenseEntry)
            
            let rentExpenseEntry = PieChartDataEntry(value: entry.rentExpense, label: "Kira")
            generalExpenseEntries.append(rentExpenseEntry)
            
            let totalExpense = entry.creditCardExpense + entry.rentExpense
            totalExpenseLabel.text = "\(totalExpense)"
        }
        
        let combinedEntries = generalExpenseEntries
        let totalProcent = combinedEntries.reduce(0) { $0 + $1.value }
        let procent = combinedEntries.map { $0.value / totalProcent }
        
        for (index, entry) in combinedEntries.enumerated() {
            if let procentWage = procent[safe: index] {
                let formattedOran = String(format: "%.2f%%", procentWage * 100)
                
                entry.label = entry.label.map { "\($0) - \(formattedOran)" }
            }
        }
        
        let generalExpenseDataSet = PieChartDataSet(entries: generalExpenseEntries, label: "")
        generalExpenseDataSet.colors = ChartColorTemplates.colorful()
        
        let generalDataSet = PieChartDataSet(
            entries: generalExpenseEntries,
            label: "")
        generalDataSet.colors = [UIColor.red, .blue]
        
        let generalData = PieChartData(dataSet: generalDataSet)
        generalData.setValueTextColor(UIColor.white)
        
        self.expenseChart.data = generalData
        self.expenseChart.centerText = "Genel Giderler"
        self.expenseChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeOutBack)
    }
    
    func updateGeneralChart() {
        var generalExpenseEntries: [PieChartDataEntry] = []
        let combinedEntries = generalExpenseEntries
        let combinedDataSet = PieChartDataSet(entries: combinedEntries, label: "")
        combinedDataSet.colors = ChartColorTemplates.material()

        let updatedDataSet = PieChartDataSet(entries: combinedEntries, label: "")
        expenseChart.data = PieChartData(dataSet: updatedDataSet)
    }
    
    func setupDetailExpenseChartView(detailExpenseData: [ExpenseEntry]) {
        var clothesExpenseEntries: [PieChartDataEntry] = []
        var electronicExpenseEntries: [PieChartDataEntry] = []
        var foodExpenseEntries: [PieChartDataEntry] = []
        var fuelExpenseEntries: [PieChartDataEntry] = []
        var rentExpenseEntries: [PieChartDataEntry] = []
        var taxExpenseEntries: [PieChartDataEntry] = []
        var transportEntries: [PieChartDataEntry] = []
        
        for (_, entry) in detailExpenseData.enumerated() {
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
            
            let totalExpense = entry.clothesExpense + entry.electronicExpense + entry.foodExpense + entry.fuelExpense + entry.rentExpense + entry.taxExpense + entry.transportExpense
            totalExpenseLabel.text = "Toplam Gider: \(totalExpense)"
            
            let month = entry.month
            if let unwrappedMonth = month {
                monthLabel.text = "\(unwrappedMonth) Dönemi"
            } else {
                monthLabel.text = "\(String(describing: month)) Bilinmiyor"
            }
            
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
        
        //TODO: Add Procent Pie
        
        let combinedDataSet = PieChartDataSet(
            entries: clothesExpenseEntries + electronicExpenseEntries + foodExpenseEntries + fuelExpenseEntries + rentExpenseEntries + taxExpenseEntries,
            label: "")
        combinedDataSet.colors = [
            .red, .blue, .green, .yellow, .orange, .purple, .magenta
        ]
        
        let combinedData = PieChartData(dataSet: combinedDataSet)
        combinedData.setValueTextColor(.white)
        self.expenseChart.data = combinedData
        self.expenseChart.centerText = "Giderlerim"
        self.expenseChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeOutBack)
    }
    
    func updateDetailChart() {
        var clothesExpenseEntries: [PieChartDataEntry] = []
        var electronicExpenseEntries: [PieChartDataEntry] = []
        var foodExpenseEntries: [PieChartDataEntry] = []
        var fuelExpenseEntries: [PieChartDataEntry] = []
        var rentExpenseEntries: [PieChartDataEntry] = []
        var taxExpenseEntries: [PieChartDataEntry] = []
        var transportEntries: [PieChartDataEntry] = []
        
        let combinedEntries = clothesExpenseEntries + electronicExpenseEntries + foodExpenseEntries + fuelExpenseEntries + rentExpenseEntries + taxExpenseEntries + transportEntries
        let combinedDataSet = PieChartDataSet(entries: combinedEntries, label: "")
        combinedDataSet.colors = ChartColorTemplates.material()

        let updatedDataSet = PieChartDataSet(entries: combinedEntries, label: "")
        expenseChart.data = PieChartData(dataSet: updatedDataSet)
    }
}
