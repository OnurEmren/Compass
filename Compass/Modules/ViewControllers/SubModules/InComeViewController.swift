//
//  InComeViewController.swift
//  Compass
//
//  Created by Onur Emren on 17.01.2024.
//

import UIKit
import Charts
import SnapKit
import DGCharts

class InComeViewController: UIViewController, Coordinating {
    var coordinator: Coordinator?
    
    private let incomeDistributionChart: BarChartView = {
        let chartView = BarChartView()
        return chartView
    }()
    
    private let totalIncomeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.text = "Toplam Gelir: $10,000" // Bu kısmı dinamik olarak güncellemelisiniz
        return label
    }()
    
    private let incomeSourcesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .left
        label.text = "Gelir Kaynakları:"
        return label
    }()
    
    private let incomeSourcesTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isEditable = false
        textView.text = "- Maaş: $6,000\n- Yatırım Getirisi: $3,000\n- Diğer: $1,000"
        return textView
    }()
    
    private let incomeDistributionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .left
        label.text = "Gelir Dağılımı:"
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.setTitle("Gelir Ekle", for: .normal)
        button.setTitleColor(Colors.darkThemeColor, for: .normal)
        button.addTarget(self, action: #selector(goToAddInCome), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupChart()
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(totalIncomeLabel)
        view.addSubview(incomeSourcesLabel)
        view.addSubview(incomeSourcesTextView)
        view.addSubview(incomeDistributionLabel)
        view.addSubview(incomeDistributionChart)
        view.addSubview(addButton)
        
        totalIncomeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        incomeSourcesLabel.snp.makeConstraints { make in
            make.top.equalTo(totalIncomeLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        incomeSourcesTextView.snp.makeConstraints { make in
            make.top.equalTo(incomeSourcesLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(incomeSourcesTextView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }
        
        incomeDistributionLabel.snp.makeConstraints { make in
            make.top.equalTo(addButton.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        incomeDistributionChart.snp.makeConstraints { make in
            make.top.equalTo(incomeDistributionLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(150)
        }
    }
    
    private func setupChart() {
        let entries = [
            BarChartDataEntry(x: 0.0, y: 3000.0),
            BarChartDataEntry(x: 1.0, y: 5000.0),
            BarChartDataEntry(x: 2.0, y: 2000.0)
        ]
        
        let dataSet = BarChartDataSet(entries: entries, label: "Gelir Dağılımı")
        dataSet.colors = ChartColorTemplates.material()
        
        let data = BarChartData(dataSet: dataSet)
        incomeDistributionChart.data = data
        
        incomeDistributionChart.chartDescription.text = ""
        incomeDistributionChart.xAxis.labelPosition = .bottom
        incomeDistributionChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }
    
    @objc
    private func goToAddInCome() {
        coordinator?.eventOccured(with: .goToInComeEntryVC)
    }
}

