//
//  ExpenseView.swift
//  Compass
//
//  Created by Onur Emren on 28.01.2024.
//

import Foundation
import UIKit
import DGCharts
import CoreData

class ExpenseView: UIView, UITableViewDelegate, UITableViewDataSource {
    let expenseChart: PieChartView = {
        let chartView = PieChartView()
        chartView.layer.cornerRadius = 20
        chartView.layer.masksToBounds = true
        return chartView
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Detaylı Gider Ekle", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.titleLabel?.font = Fonts.generalFont
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sil", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = Fonts.generalFont
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let imageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "spiral"))
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.alpha = 0.6
        return image
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
        text: "Dönem:",
        fontSize: 18,
        alignment: .left)
    
    var expenseTableView = UITableView()
    var generalExpenseTableView = UITableView()
    private let cellIdentifier = "expenseCellIdentifier"
    private let cellIdentifier2 = "generalExpenseCellIdentifier"
    private var expenseRecord: [ExpenseEntry] = []
    private var generalExpenseRecord: [GeneralExpenseEntry] = []
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
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
        addSubview(expenseTableView)
        addSubview(generalExpenseTableView)
        
        monthLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
        }
        monthLabel.textColor = Colors.lightThemeColor
        
        totalExpenseLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(monthLabel).offset(30)
        }
        totalExpenseLabel.textColor = .white
        
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
        legend.font = UIFont.preferredFont(forTextStyle: .body)
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(expenseChart.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.lessThanOrEqualTo(safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(40)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(expenseChart.snp.top).offset(10)
            make.right.equalTo(-30)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        expenseTableView.snp.makeConstraints { make in
            make.top.equalTo(addButton.snp.top).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(15)
        }
        
        generalExpenseTableView.snp.makeConstraints { make in
            make.top.equalTo(addButton.snp.top).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(15)
        }
        
        expenseTableView.dataSource = self
        expenseTableView.delegate = self
        expenseTableView.backgroundColor = .clear
        expenseTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        generalExpenseTableView.dataSource = self
        generalExpenseTableView.delegate = self
        generalExpenseTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier2)
        generalExpenseTableView.backgroundColor = .clear
        
        insertSubview(imageView, at: 0)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        expenseTableView.reloadData()
        generalExpenseTableView.reloadData()
    }
    
    func showPieChart(with entry: ExpenseEntry) {
        var clothesEntries: [PieChartDataEntry] = []
        var foodEntries: [PieChartDataEntry] = []
        var fuelEntries: [PieChartDataEntry] = []
        var rentEntries: [PieChartDataEntry] = []
        var taxEntries: [PieChartDataEntry] = []

        // Veri setini oluştur
        let clothesExpense = PieChartDataEntry(value: entry.clothesExpense, label: "Giyim")
        clothesEntries.append(clothesExpense)

        let foodExpense = PieChartDataEntry(value: entry.foodExpense, label: "Gıda")
        foodEntries.append(foodExpense)
        
        let fuelExpense = PieChartDataEntry(value: entry.fuelExpense, label: "Ulaşım")
        fuelEntries.append(fuelExpense)
        
        let rentExpense = PieChartDataEntry(value: entry.rentExpense, label: "Kira")
        rentEntries.append(rentExpense)
        
        let taxExpense = PieChartDataEntry(value: entry.taxExpense, label: "Faturalar")
        taxEntries.append(taxExpense)
    

        let combinedEntries = clothesEntries + foodEntries + fuelEntries + rentEntries + taxEntries
        let totalProcent = combinedEntries.reduce(0) { $0 + $1.value }
        let yuzdelikOranlari = combinedEntries.map { $0.value / totalProcent }

        for (index, entry) in combinedEntries.enumerated() {
            if let yuzdelikOran = yuzdelikOranlari[safe: index] {
                let formattedOran = String(format: "%.2f%%", yuzdelikOran * 100)
                entry.label = entry.label.map {"\($0) - \(formattedOran)" }
            }
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0
       
        let combinedDataSet = PieChartDataSet(entries: combinedEntries, label: "")
        combinedDataSet.colors = ChartColorTemplates.pastel()

        let combinedData = PieChartData(dataSet: combinedDataSet)
        combinedData.setValueTextColor(.white)
        combinedData.setValueFormatter(DefaultValueFormatter(formatter: formatter))

        expenseChart.data = combinedData
        expenseChart.centerText = "Giderlerim"
        expenseChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeOutBack)
    }
    
    func showGeneralChart(with entry: GeneralExpenseEntry) {
        var creditCardEntries: [PieChartDataEntry] = []
        var rentEntries: [PieChartDataEntry] = []

        // Veri setini oluştur
        let creditCardExpense = PieChartDataEntry(value: entry.creditCardExpense, label: "Maaş")
        creditCardEntries.append(creditCardExpense)

        let rentExpense = PieChartDataEntry(value: entry.rentExpense, label: "Yan Gelir")
        rentEntries.append(rentExpense)
        
       
        let combinedEntries = creditCardEntries + rentEntries
        let totalProcent = combinedEntries.reduce(0) { $0 + $1.value }
        let yuzdelikOranlari = combinedEntries.map { $0.value / totalProcent }

        for (index, entry) in combinedEntries.enumerated() {
            if let yuzdelikOran = yuzdelikOranlari[safe: index] {
                let formattedOran = String(format: "%.2f%%", yuzdelikOran * 100)
                entry.label = entry.label.map {"\($0) - \(formattedOran)" }
            }
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0

        let combinedDataSet = PieChartDataSet(entries: combinedEntries, label: "")
        combinedDataSet.colors = ChartColorTemplates.pastel()

        let combinedData = PieChartData(dataSet: combinedDataSet)
        combinedData.setValueTextColor(.white)
        combinedData.setValueFormatter(DefaultValueFormatter(formatter: formatter))

        expenseChart.data = combinedData
        expenseChart.centerText = "Giderlerim"
        expenseChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeOutBack)
    }
    
    //MARK: - TableView Delegate and Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           if tableView == expenseTableView {
               return expenseRecord.count
           } else {
               return generalExpenseRecord.count
           }
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
           if tableView == expenseTableView {
               let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
               let record = expenseRecord[indexPath.row]
               cell.contentView.subviews.forEach { $0.removeFromSuperview() }
               setLabelTag(cell: cell, record: record, indexPath: indexPath)
               cell.layer.cornerRadius = 20
               cell.layer.masksToBounds = false
               cell.layer.borderColor = UIColor.white.cgColor
               cell.layer.borderWidth = 0.7
               cell.backgroundColor = .clear
               return cell
           } else {
               let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier2, for: indexPath)
               let generalRecord = generalExpenseRecord[indexPath.row]
               cell.contentView.subviews.forEach { $0.removeFromSuperview() }
               setupCombinedChart(generalData: generalExpenseRecord)
               setGeneralLabelTag(cell: cell, record: generalRecord, indexPath: indexPath)
               cell.layer.cornerRadius = 20
               cell.layer.masksToBounds = false
               cell.layer.borderColor = UIColor.white.cgColor
               cell.layer.borderWidth = 0.7
               cell.backgroundColor = .clear
               return cell
           }
       }
       
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
             return 80
         }
       
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           expenseTableView.deselectRow(at: indexPath, animated: true)
           generalExpenseTableView.deselectRow(at: indexPath, animated: true)
           
           if tableView == expenseTableView {
               let selectedRecord = expenseRecord[indexPath.row]
               showPieChart(with: selectedRecord)
           } else {
               let selectedGeneralRecord = generalExpenseRecord[indexPath.row]
               showGeneralChart(with: selectedGeneralRecord)
           }
       }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if tableView == expenseTableView {
                let recordToRemove = expenseRecord[indexPath.row]
                deleteExpenseData(record: recordToRemove)
                expenseRecord.remove(at: indexPath.row)
            } else {
                let recordToRemove = generalExpenseRecord[indexPath.row]
                deleteGeneralExpenseData(record: recordToRemove)
                generalExpenseRecord.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func deleteExpenseData(record: ExpenseEntry) {
        let context = appDelegate.persistentContainer.viewContext
        context.delete(record)
        do {
            try context.save()
            updateChart()
        } catch {
            print("Error deleting expense data: \(error.localizedDescription)")
        }
    }

    func deleteGeneralExpenseData(record: GeneralExpenseEntry) {
        let context = appDelegate.persistentContainer.viewContext
        context.delete(record)
        do {
            try context.save()
            updateCombinedChart()
        } catch {
            print("Error deleting general expense data: \(error.localizedDescription)")
        }
    }
    
    private func setLabelTag(cell: UITableViewCell, record: ExpenseEntry, indexPath: IndexPath) {
        //Set DateFormatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        let totalExpense = record.clothesExpense + record.foodExpense + record.fuelExpense + record.rentExpense + record.taxExpense
        //Set Label Tag
        let labelConfigs: [(tag: Int, text: String)] = [
            (1, "Toplam: \(totalExpense)"),
            (2, "Dönem: \(String(describing: record.month ?? ""))"),
        ]
        
        var previousLabel: UIView?
        
        for config in labelConfigs {
            previousLabel = createAndConfigureLabel(tag: config.tag, text: config.text, cell: cell, topView: previousLabel)
        }
        cell.backgroundColor = .clear
    }
    //MARK: - Private Methods
    
    private func configureCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        if tableView == expenseTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            let record = expenseRecord[indexPath.row]
            setLabelTag(cell: cell, record: record, indexPath: indexPath)
            showPieChart(with: record)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier2, for: indexPath)
            let generalRecord = generalExpenseRecord[indexPath.row]
            setGeneralLabelTag(cell: cell, record: generalRecord, indexPath: indexPath)
            setupCombinedChart(generalData: generalExpenseRecord)
        }
        
        cell.layer.cornerRadius = 20
        cell.layer.masksToBounds = false
        
        return cell
    }
    
    private func setGeneralLabelTag(cell: UITableViewCell, record: GeneralExpenseEntry, indexPath: IndexPath) {
        //Set DateFormatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        let totalGeneralExpense = record.creditCardExpense + record.rentExpense
        
        //Set Label Tag
        let labelConfigs: [(tag: Int, text: String)] = [
            (1, "Toplam: \(totalGeneralExpense)"),
            (2, "Dönem: \(String(describing: record.month ?? ""))"),
        ]
        
        var previousLabel: UIView?
        
        for config in labelConfigs {
            previousLabel = createAndConfigureLabel(tag: config.tag, text: config.text, cell: cell, topView: previousLabel)
        }
        
        //Set Color
 //       let colorIndex = indexPath.row % Colors.colors.count
        cell.backgroundColor = .white
    }
    
    private func createAndConfigureLabel(tag: Int, text: String, cell: UITableViewCell, topView: UIView? = nil) -> UILabel {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        cell.contentView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            if let topView = topView {
                make.top.equalTo(topView.snp.bottom).offset(5)
            } else {
                make.top.equalToSuperview().offset(10)
            }
        }
        
        label.text = text
        return label
    }
    
    func updateExpenseRecords(_ records: [ExpenseEntry]) {
        expenseRecord = records
        expenseTableView.reloadData()
    }
    
    func updateGeneralExpenseRecords(_ records: [GeneralExpenseEntry]) {
        generalExpenseRecord = records
        generalExpenseTableView.reloadData()
    }
    
    func setupCombinedChart(generalData: [GeneralExpenseEntry]) {
        let generalExpenseEntries: [PieChartDataEntry] = []
        let rentExpenseEntries: [PieChartDataEntry] = []
        
        guard let lastEntry = generalData.last else {
               return
           }

        let generalExpenseEntry = PieChartDataEntry(value: lastEntry.creditCardExpense, label: "Kredi Kartı")
        let rentExpenseEntry = PieChartDataEntry(value: lastEntry.rentExpense, label: "Kira")

        for (_, _) in generalData.enumerated() {
            
            let totalExpense = lastEntry.creditCardExpense + lastEntry.rentExpense
            totalExpenseLabel.text = "\(totalExpense)"
            
            let month = lastEntry.month
            if let unwrappedMonth = month {
                monthLabel.text = "\(unwrappedMonth) Dönemi"
            } else {
                monthLabel.text = "\(String(describing: month)) Bilinmiyor"
            }
        }
        
        //TODO: Set the procent views
        
        let combinedEntries = generalExpenseEntries + rentExpenseEntries
        let totalProcent = combinedEntries.reduce(0) { $0 + $1.value }
        let yuzdelikOranlari = combinedEntries.map { $0.value / totalProcent }
        
        for (index, entry) in combinedEntries.enumerated() {
            if let yuzdelikOran = yuzdelikOranlari[safe: index] {
                let formattedOran = String(format: "%.2f%%", yuzdelikOran * 100)
                
                entry.label = entry.label.map {_ in "\(formattedOran)" }
            }
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.multiplier = 1.0

        let combinedDataSet = PieChartDataSet(entries: combinedEntries, label: "")
        combinedDataSet.colors = ChartColorTemplates.material()

        let combinedData = PieChartData(dataSet: combinedDataSet)
        combinedData.setValueTextColor(.white)
        combinedData.setValueFormatter(DefaultValueFormatter(formatter: formatter))

        self.expenseChart.data = combinedData
        self.expenseChart.centerText = "Maaş ve Yan Gelir"
        self.expenseChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeOutBack)
        
        
        let generalExpenseDataSet = PieChartDataSet(entries: [generalExpenseEntry, rentExpenseEntry], label: "")
        generalExpenseDataSet.colors = ChartColorTemplates.pastel()

        let generalData = PieChartData(dataSet: generalExpenseDataSet)
        generalData.setValueTextColor(UIColor.white)

        self.expenseChart.data = generalData
        self.expenseChart.centerText = "Genel Giderler"
        self.expenseChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeOutBack)
    }
    
    //After deleted data
    func updateGeneralChart() {
        let generalExpenseEntries: [PieChartDataEntry] = []
        let combinedEntries = generalExpenseEntries
        let combinedDataSet = PieChartDataSet(entries: combinedEntries, label: "")
        combinedDataSet.colors = ChartColorTemplates.material()

        let updatedDataSet = PieChartDataSet(entries: combinedEntries, label: "")
        expenseChart.data = PieChartData(dataSet: updatedDataSet)
    }
    
    func setupDetailExpenseChartView(detailExpenseData: [ExpenseEntry]) {
        guard let lastEntry = detailExpenseData.last else {
            return
        }
        
        let clothesExpenseEntry = PieChartDataEntry(value: lastEntry.clothesExpense, label: "Giyim")
        let foodExpenseEntry = PieChartDataEntry(value: lastEntry.foodExpense, label: "Gıda")
        let fuelExpenseEntry = PieChartDataEntry(value: lastEntry.fuelExpense, label: "Yakıt")
        let rentExpenseEntry = PieChartDataEntry(value: lastEntry.rentExpense, label: "Kira")
        let taxExpenseEntry = PieChartDataEntry(value: lastEntry.taxExpense, label: "Faturalar")
        
        let clothesDataSet = PieChartDataSet(entries: [clothesExpenseEntry], label: "")
        clothesDataSet.colors = ChartColorTemplates.pastel()
        
        let foodDataSet = PieChartDataSet(entries: [foodExpenseEntry], label: "")
        foodDataSet.colors = ChartColorTemplates.pastel()
        
        let fuelDataSet = PieChartDataSet(entries: [fuelExpenseEntry], label: "")
        fuelDataSet.colors = ChartColorTemplates.pastel()
        
        let rentDataSet = PieChartDataSet(entries: [rentExpenseEntry], label: "")
        rentDataSet.colors = ChartColorTemplates.pastel()
        
        let taxDataSet = PieChartDataSet(entries: [taxExpenseEntry], label: "")
        taxDataSet.colors = ChartColorTemplates.pastel()
        
        let clothesData = PieChartData(dataSet: clothesDataSet)
        let foodData = PieChartData(dataSet: foodDataSet)
        let fuelData = PieChartData(dataSet: fuelDataSet)
        let rentData = PieChartData(dataSet: rentDataSet)
        let taxData = PieChartData(dataSet: taxDataSet)
        
        clothesData.setValueTextColor(.white)
        foodData.setValueTextColor(.white)
        fuelData.setValueTextColor(.white)
        rentData.setValueTextColor(.white)
        taxData.setValueTextColor(.white)
        
        //TODO: Add Procent Pie
        
        let combinedDataSet = PieChartDataSet(
            entries: [clothesExpenseEntry, foodExpenseEntry, fuelExpenseEntry, rentExpenseEntry, taxExpenseEntry],
            label: "")
        combinedDataSet.colors = ChartColorTemplates.pastel()
        
        let combinedData = PieChartData(dataSet: combinedDataSet)
        combinedData.setValueTextColor(.white)
        self.expenseChart.data = combinedData
        self.expenseChart.centerText = "Giderlerim"
        self.expenseChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeOutBack)
        
        let totalExpense = lastEntry.clothesExpense + lastEntry.foodExpense + lastEntry.fuelExpense + lastEntry.rentExpense + lastEntry.taxExpense
        totalExpenseLabel.text = "Toplam Gider: \(totalExpense)"
        
        let month = lastEntry.month
        if let unwrappedMonth = month {
            monthLabel.text = "\(unwrappedMonth) Dönemi"
        } else {
            monthLabel.text = "\(String(describing: month)) Bilinmiyor"
        }
    }
    
    //After deleted data
    func updateDetailChart() {
        let clothesExpenseEntries: [PieChartDataEntry] = []
        let electronicExpenseEntries: [PieChartDataEntry] = []
        let foodExpenseEntries: [PieChartDataEntry] = []
        let fuelExpenseEntries: [PieChartDataEntry] = []
        let rentExpenseEntries: [PieChartDataEntry] = []
        let taxExpenseEntries: [PieChartDataEntry] = []
        let transportEntries: [PieChartDataEntry] = []
        
        let combinedEntries = clothesExpenseEntries + electronicExpenseEntries + foodExpenseEntries + fuelExpenseEntries + rentExpenseEntries + taxExpenseEntries + transportEntries
        let combinedDataSet = PieChartDataSet(entries: combinedEntries, label: "")
        combinedDataSet.colors = ChartColorTemplates.material()

        let updatedDataSet = PieChartDataSet(entries: combinedEntries, label: "")
        expenseChart.data = PieChartData(dataSet: updatedDataSet)
    }
    
    func updateChart() {
        setupDetailExpenseChartView(detailExpenseData: expenseRecord)
        expenseTableView.reloadData()
    }
    
    func updateCombinedChart(){
        setupCombinedChart(generalData: generalExpenseRecord)
        generalExpenseTableView.reloadData()
    }
}
