//
//  InComeView.swift
//  Compass
//
//  Created by Onur Emren on 29.01.2024.
//

import Foundation
import UIKit
import DGCharts
import CoreData

class InComeView: UIView {
    private var attendanceRecords: [InComeEntry] = []
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let cellIdentifier = "inComeCellIdentifier"

    let incomeDistributionChart: PieChartView = {
        let chartView = PieChartView()
        chartView.layer.cornerRadius = 20
        chartView.layer.masksToBounds = true
        chartView.entryLabelFont = Fonts.generalFont
        chartView.backgroundColor = .systemBackground
        return chartView
    }()
    
    let totalIncomeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = Fonts.generalFont
        return label
    }()
    
    let incomeSourcesLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = Fonts.generalFont
        label.textColor = .white
        label.text = "Gelir Kaynakları:"
        return label
    }()
    
    let incomeMonthsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = Fonts.generalFont
        label.text = "Dönem:"
        return label
    }()
    
    let incomeSourcesTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.layer.cornerRadius = 10
        textView.layer.masksToBounds = true
        let text = """
            - Maaş: 0,000
        """
        
        let attributedText = NSMutableAttributedString(string: text)
        
        if let font = UIFont(name: "MalayalamSangamMN", size: 16) {
            let attributes: [NSAttributedString.Key: Any] = [.font: font]
            attributedText.addAttributes(attributes, range: NSRange(location: 0, length: text.count))
        } else {
            print("Belirtilen font bulunamadı.")
        }
        textView.attributedText = attributedText
        
        return textView
    }()
    
    let incomeDistributionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = Fonts.generalFont
        label.text = "Gelir Dağılımı:"
        return label
    }()
    
    private let imageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "spiral"))
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Gelir Ekle", for: .normal)
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
        button.layer.cornerRadius = 8
        button.titleLabel?.font = Fonts.generalFont
        return button
    }()
    
    var inComeTableView: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        inComeTableView = UITableView()

        addSubview(totalIncomeLabel)
        addSubview(incomeDistributionChart)
        addSubview(incomeSourcesLabel)
        addSubview(incomeSourcesTextView)
        addSubview(incomeMonthsLabel)
        addSubview(addButton)
        addSubview(deleteButton)
        addSubview(inComeTableView)
        
        incomeMonthsLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).offset(40)
        }
        
        totalIncomeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(incomeMonthsLabel).offset(30)
        }
        
        incomeDistributionChart.snp.makeConstraints { make in
            make.top.equalTo(totalIncomeLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(350)
        }
        
        let legend = incomeDistributionChart.legend
        legend.verticalAlignment = .bottom
        legend.horizontalAlignment = .center
        legend.orientation = .vertical
        legend.formSize = 15
        legend.font = UIFont(name: "MalayalamSangamMN", size: 15) ?? .systemFont(ofSize: 19)
                
        addButton.snp.makeConstraints { make in
            make.top.equalTo(incomeDistributionChart.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualTo(safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(40)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(incomeDistributionChart.snp.top).offset(10)
            make.right.equalTo(-30)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        insertSubview(imageView, at: 0)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        inComeTableView.dataSource = self
        inComeTableView.delegate = self
        inComeTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        inComeTableView.backgroundColor = .red
        inComeTableView.snp.makeConstraints { make in
            make.top.equalTo(addButton.snp.top).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(15)
        }
    }
    
    func updateAttendanceRecords(_ records: [InComeEntry]) {
        attendanceRecords = records
        inComeTableView.reloadData()
    }
   
    func setupInComeChartView(with data: [InComeEntry]) {
        var wageEntries: [PieChartDataEntry] = []
        var sideIncomeEntries: [PieChartDataEntry] = []
        
        for (_, entry) in data.enumerated() {
            
            let wage = PieChartDataEntry(value: entry.wage, label: "Maaş")
            wageEntries.append(wage)

            let sideIncomeEntry = PieChartDataEntry(value: entry.sideInCome, label: "Yan Gelir")
            sideIncomeEntries.append(sideIncomeEntry)
            
            let totalIncome = entry.wage + entry.sideInCome
            totalIncomeLabel.text = "Toplam Gelir: \(totalIncome)"
            
            let month = entry.month
            if let unwrappedMonth = month {
                incomeMonthsLabel.text = "\(unwrappedMonth) Dönemi"
            } else {
                incomeMonthsLabel.text = "\(String(describing: month)) Bilinmiyor"
            }
        }
        
        let combinedEntries = wageEntries + sideIncomeEntries
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
        combinedDataSet.colors = ChartColorTemplates.material()

        let combinedData = PieChartData(dataSet: combinedDataSet)
        combinedData.setValueTextColor(.white)
        combinedData.setValueFormatter(DefaultValueFormatter(formatter: formatter))

        incomeDistributionChart.data = combinedData
        incomeDistributionChart.centerText = "Maaş ve Yan Gelir"
        incomeDistributionChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeOutBack)
    }
    
    func showPieChart(with entry: InComeEntry) {
        var wageEntries: [PieChartDataEntry] = []
        var sideIncomeEntries: [PieChartDataEntry] = []

        // Veri setini oluştur
        let wage = PieChartDataEntry(value: entry.wage, label: "Maaş")
        wageEntries.append(wage)

        let sideIncomeEntry = PieChartDataEntry(value: entry.sideInCome, label: "Yan Gelir")
        sideIncomeEntries.append(sideIncomeEntry)

        let totalIncome = entry.wage + entry.sideInCome
        totalIncomeLabel.text = "Toplam Gelir: \(totalIncome)"

        let month = entry.month
        if let unwrappedMonth = month {
            incomeMonthsLabel.text = "\(unwrappedMonth) Dönemi"
        } else {
            incomeMonthsLabel.text = "\(String(describing: month)) Bilinmiyor"
        }

        let combinedEntries = wageEntries + sideIncomeEntries
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
        combinedDataSet.colors = ChartColorTemplates.material()

        let combinedData = PieChartData(dataSet: combinedDataSet)
        combinedData.setValueTextColor(.white)
        combinedData.setValueFormatter(DefaultValueFormatter(formatter: formatter))

        incomeDistributionChart.data = combinedData
        incomeDistributionChart.centerText = "Maaş ve Yan Gelir"
        incomeDistributionChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeOutBack)
    }

    
    func updateChart() {
        let wageEntries: [PieChartDataEntry] = []
        let sideIncomeEntries: [PieChartDataEntry] = []
        let combinedEntries = wageEntries + sideIncomeEntries
        let combinedDataSet = PieChartDataSet(entries: combinedEntries, label: "")
        combinedDataSet.colors = ChartColorTemplates.material()

        let updatedDataSet = PieChartDataSet(entries: combinedEntries, label: "")
        incomeDistributionChart.data = PieChartData(dataSet: updatedDataSet)
    }
}

extension InComeView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        attendanceRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let record = attendanceRecords[indexPath.row]
        
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        setLabelTag(cell: cell, record: record, indexPath: indexPath)

        cell.layer.cornerRadius = 20
        cell.layer.masksToBounds = false

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 100
      }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        inComeTableView.deselectRow(at: indexPath, animated: true)
        let selectedRecord = attendanceRecords[indexPath.row]
        showPieChart(with: selectedRecord)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { [weak self] (_, _, completionHandler) in
            self?.deleteActionTapped(at: indexPath)
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = .red
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func deleteActionTapped(at indexPath: IndexPath) {
        let recordToDelete = attendanceRecords[indexPath.row]
        let context = appDelegate.persistentContainer.viewContext
        context.delete(recordToDelete)
        
        do {
            try context.save()
            showToastInvestment(message: "Veriler silindi.")
            attendanceRecords.remove(at: indexPath.row)
            inComeTableView.deleteRows(at: [indexPath], with: .automatic)
            inComeTableView.reloadData()
        } catch {
            print("Veri silinirken hata oluştu: \(error.localizedDescription)")
        }
    }
    
    private func createAndConfigureLabel(tag: Int, text: String, cell: UITableViewCell, topView: UIView? = nil) -> UILabel {
        let label = UILabel()
        label.textColor = .black
        label.font = Fonts.generalFont
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
    
    private func setLabelTag(cell: UITableViewCell, record: InComeEntry, indexPath: IndexPath) {
        //Set DateFormatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        //Set Label Tag
        let labelConfigs: [(tag: Int, text: String)] = [
            (1, "Maaş: \(record.wage)"),
            (2, "Yan Gelir: \(record.sideInCome)"),
            (3, "Tarih: \(String(describing: record.month))"),
        ]
        
        var previousLabel: UIView?
        
        for config in labelConfigs {
            previousLabel = createAndConfigureLabel(tag: config.tag, text: config.text, cell: cell, topView: previousLabel)
        }
        
        //Set Color
        let colorIndex = indexPath.row % Colors.colors.count
        cell.backgroundColor = Colors.colors[colorIndex]
    }
    
}
