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
import CoreData

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
        textView.backgroundColor = Colors.lightThemeColor
        textView.layer.borderWidth = 0.7
        textView.layer.borderColor = Colors.darkThemeColor.cgColor
        textView.layer.cornerRadius = 10
        textView.layer.masksToBounds = true
        textView.text = "- Maaş: $0,000\n- Yatırım Getirisi: $0,000\n- Diğer: $0,000"
        return textView
    }()
    
    private let incomeDistributionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .left
        label.text = "Gelir Dağılımı:"
        return label
    }()
    
    private let inComeTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .left
        label.text = "Gelir Tipi:"
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
    
    //MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.beigeColor
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDataFromCoreData()
    }
    
    //MARK: - Private Methods
    
    //Setup Views
    private func setupViews() {
        view.addSubview(totalIncomeLabel)
        view.addSubview(incomeSourcesLabel)
        view.addSubview(incomeSourcesTextView)
        view.addSubview(incomeDistributionLabel)
        view.addSubview(inComeTypeLabel)
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
        
        inComeTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(incomeSourcesTextView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(inComeTypeLabel.snp.bottom).offset(10)
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
    
    private func setupChart(with data: [InComeEntry]) {
        var entries: [BarChartDataEntry] = []

        for (index, entry) in data.enumerated() {
            let barEntry = BarChartDataEntry(x: Double(index), y: entry.wage)
            entries.append(barEntry)
        }

        let dataSet = BarChartDataSet(entries: entries, label: "Gelir Dağılımı")
        dataSet.colors = ChartColorTemplates.material()

        let data = BarChartData(dataSet: dataSet)
        incomeDistributionChart.data = data

        incomeDistributionChart.chartDescription.text = ""
        incomeDistributionChart.xAxis.labelPosition = .bottom
        incomeDistributionChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }

    
    //MARK: - Load Data
    
    private func fetchDataFromCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "InComeEntry")
        
        do {
            let fetchedData = try context.fetch(fetchRequest) as! [InComeEntry]
            // Veriyi kullanarak labellara atama
            let totalIncome = fetchedData.reduce(0) { (result, entry) in
                return result + entry.wage
            }
            totalIncomeLabel.text = "Toplam Gelir: \(totalIncome)"
            
            for entry in fetchedData {
                let incomeTypeName = entry.inComeType
                let salary = entry.wage
                let sideInCome = entry.sideInCome
                inComeTypeLabel.text = "Gelir Tipi: \(String(describing: incomeTypeName))"
                incomeSourcesTextView.text = "- Maaş: $\(salary)\n- Yan Gelirler: \(sideInCome)"
            }
            setupChart(with: fetchedData)
        } catch {
            print("Veri çekme hatası: \(error)")
        }
    }
    
    //MARK: - @objc Methods
    
    @objc
    private func goToAddInCome() {
        coordinator?.eventOccured(with: .goToInComeEntryVC)
    }
}

