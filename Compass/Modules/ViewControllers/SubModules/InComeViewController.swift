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

    private let incomeDistributionChart: PieChartView = {
        let chartView = PieChartView()
        chartView.layer.cornerRadius = 20
        chartView.layer.masksToBounds = true
        chartView.entryLabelFont = Fonts.generalFont
        return chartView
    }()
    
    private let totalIncomeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "0.0"
        label.font = Fonts.generalFont
        return label
    }()
    
    private let incomeSourcesLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = Fonts.generalFont
        label.text = "Gelir Kaynakları:"
        return label
    }()
    
    private let incomeMonthsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = Fonts.generalFont
        label.text = "Ay:"
        return label
    }()
    
    private let incomeSourcesTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.layer.cornerRadius = 10
        textView.layer.masksToBounds = true
        let text = """
            - Maaş: 0,000
            - Yatırım Getirisi: 0,000
        """
        
        let attributedText = NSMutableAttributedString(string: text)
        
        if let font = UIFont(name: "Tahoma", size: 16) {
            let attributes: [NSAttributedString.Key: Any] = [.font: font]
            attributedText.addAttributes(attributes, range: NSRange(location: 0, length: text.count))
        } else {
            print("Belirtilen font bulunamadı.")
        }
        
        textView.attributedText = attributedText
        
        return textView
    }()
    
    private let incomeDistributionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = Fonts.generalFont
        label.text = "Gelir Dağılımı:"
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Gelir Ekle", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Colors.buttonColor
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.titleLabel?.font = Fonts.generalFont
        button.addTarget(self, action: #selector(goToAddInCome), for: .touchUpInside)
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sil", for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 8
        button.titleLabel?.font = Fonts.generalFont
        return button
    }()
    
    //MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.incomeTitle
        setupNavigationView()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDataFromCoreData()
    }
    
    //MARK: - Private Methods
    
    private func setupNavigationView() {
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = UIColor.white
        let font = UIFont(name: "Tahoma", size: 18.0)
        navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: font!, NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    //Setup Views
    private func setupViews() {
        view.backgroundColor = Colors.piesGreenColor
        view.addSubview(totalIncomeLabel)
        view.addSubview(incomeDistributionChart)
        view.addSubview(incomeSourcesLabel)
        view.addSubview(incomeSourcesTextView)
        view.addSubview(incomeMonthsLabel)
        view.addSubview(addButton)
        view.addSubview(deleteButton)
        
        incomeMonthsLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
        }
        incomeMonthsLabel.textColor = .white
        
        totalIncomeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(incomeMonthsLabel).offset(20)
        }
        totalIncomeLabel.textColor = .white
        
        incomeDistributionChart.snp.makeConstraints { make in
            make.top.equalTo(totalIncomeLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(300)
        }
        incomeDistributionChart.backgroundColor = Colors.lightThemeColor
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(addButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
        
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)

        let legend = incomeDistributionChart.legend
        legend.verticalAlignment = .bottom
        legend.horizontalAlignment = .center
        legend.orientation = .horizontal
        legend.formSize = 10
        legend.font = UIFont(name: "Tahoma", size: 12) ?? .systemFont(ofSize: 15)
        
        incomeSourcesLabel.snp.makeConstraints { make in
            make.top.equalTo(incomeDistributionChart.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
        }
        incomeSourcesLabel.textColor = .white
        
        incomeSourcesTextView.snp.makeConstraints { make in
            make.top.equalTo(incomeSourcesLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }
        incomeSourcesTextView.backgroundColor = .white
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(incomeSourcesTextView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(40)
        }
    }
    
    private func setupChart(with data: [InComeEntry]) {
        var wageEntries: [PieChartDataEntry] = []
        var sideIncomeEntries: [PieChartDataEntry] = []
        
        for (_, entry) in data.enumerated() {
            let wageEntry = PieChartDataEntry(value: entry.wage, label: "Maaş")
            let sideIncomeEntry = PieChartDataEntry(value: entry.sideInCome, label: "Yan Gelir")
            
            wageEntries.append(wageEntry)
            sideIncomeEntries.append(sideIncomeEntry)
        }
        
        let wageDataSet = PieChartDataSet(entries: wageEntries, label: "")
        wageDataSet.colors = ChartColorTemplates.material()
        
        let sideIncomeDataSet = PieChartDataSet(entries: sideIncomeEntries, label: "")
        sideIncomeDataSet.colors = ChartColorTemplates.colorful()
        
        let wageData = PieChartData(dataSet: wageDataSet)
        let sideIncomeData = PieChartData(dataSet: sideIncomeDataSet)
        wageData.setValueTextColor(.white)
        sideIncomeData.setValueTextColor(.white)
        
        let combinedDataSet = PieChartDataSet(entries: wageEntries + sideIncomeEntries, label: "")
        combinedDataSet.colors = ChartColorTemplates.material()
        
        let combinedData = PieChartData(dataSet: combinedDataSet)
        combinedData.setValueTextColor(.white)
        
        incomeDistributionChart.data = combinedData
        incomeDistributionChart.centerText = "Maaş"
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
                let salary = entry.wage
                let sideInCome = entry.sideInCome
                let inComeTotal = salary + sideInCome
                let currency = entry.currency
                let month = entry.month
                incomeSourcesTextView.text = "- Maaş:\(salary)\n- Yan Gelirler: \(sideInCome)"
                
                if let unwrappedMonth = month {
                    incomeMonthsLabel.text = "\(unwrappedMonth)"
                } else {
                    incomeMonthsLabel.text = "\(String(describing: month)) Bilinmiyor"
                }

                if let unwrappedCurrency = currency {
                    totalIncomeLabel.text = "\(inComeTotal) \(unwrappedCurrency)"
                } else {
                    totalIncomeLabel.text = "\(inComeTotal) Bilinmiyor"
                }
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
    
    @objc
    func deleteButtonTapped() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<InComeEntry> = InComeEntry.fetchRequest()
        
        do {
            let result = try context.fetch(fetchRequest)
            
            if result.isEmpty {
               showToast(message: "Silinecek veri bulunamadı.")
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
        
        let fetchRequest: NSFetchRequest<InComeEntry> = InComeEntry.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "wage", ascending: false)]
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
