//
//  InComeView.swift
//  Compass
//
//  Created by Onur Emren on 29.01.2024.
//

import Foundation
import UIKit
import DGCharts

class InComeView: UIView {
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
        label.text = "Ay:"
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
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Gelir Ekle", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Colors.tryColor
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.titleLabel?.font = Fonts.generalFont
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sil", for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 8
        button.titleLabel?.font = Fonts.generalFont
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(totalIncomeLabel)
        addSubview(incomeDistributionChart)
        addSubview(incomeSourcesLabel)
        addSubview(incomeSourcesTextView)
        addSubview(incomeMonthsLabel)
        addSubview(addButton)
        addSubview(deleteButton)
        
        let originalBlack = UIColor.black
        let slightlyBrighterBlack = originalBlack.withAlphaComponent(0.95)
        backgroundColor = slightlyBrighterBlack
        
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
            make.top.equalTo(incomeDistributionChart    .snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.lessThanOrEqualTo(safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(40)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(addButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
    }
    
    func setupInComeChartView(with data: [InComeEntry]) {
        var wageEntries: [PieChartDataEntry] = []
        var sideIncomeEntries: [PieChartDataEntry] = []
        
        for (_, entry) in data.enumerated() {
            
            let wage = PieChartDataEntry(value: entry.wage, label: "Maaş")
            let sideIncomeEntry = PieChartDataEntry(value: entry.sideInCome, label: "Yan Gelir)")
            wageEntries.append(wage)
            sideIncomeEntries.append(sideIncomeEntry)
            
            let wageEntry = PieChartDataEntry(value: entry.wage, label: "Maaş \(entry.wage)")
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

        incomeDistributionChart.notifyDataSetChanged()

        incomeDistributionChart.data = combinedData
        incomeDistributionChart.centerText = "Maaş ve Yan Gelir"
        incomeDistributionChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeOutBack)
    }
    
    func updateChart() {
        var wageEntries: [PieChartDataEntry] = []
        var sideIncomeEntries: [PieChartDataEntry] = []
        let combinedEntries = wageEntries + sideIncomeEntries
        let combinedDataSet = PieChartDataSet(entries: combinedEntries, label: "")
        combinedDataSet.colors = ChartColorTemplates.material()

        let updatedDataSet = PieChartDataSet(entries: combinedEntries, label: "")
        incomeDistributionChart.data = PieChartData(dataSet: updatedDataSet)
    }
}
