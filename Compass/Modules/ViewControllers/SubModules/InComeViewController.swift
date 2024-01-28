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
    private var inComeView = InComeView()
    
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
        view.addSubview(inComeView)
        
        inComeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        inComeView.addButton.addTarget(self, action: #selector(goToAddInCome), for: .touchUpInside)
        inComeView.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
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
        
        inComeView.incomeDistributionChart.data = combinedData
        inComeView.incomeDistributionChart.centerText = "Maaş"
        inComeView.incomeDistributionChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
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
            inComeView.totalIncomeLabel.text = "Toplam Gelir: \(totalIncome)"
            for entry in fetchedData {
                let salary = entry.wage
                let sideInCome = entry.sideInCome
                let inComeTotal = salary + sideInCome
                let currency = entry.currency
                let month = entry.month
                inComeView.incomeSourcesTextView.text = "- Maaş:\(salary)\n- Yan Gelirler: \(sideInCome)"
                
                if let unwrappedMonth = month {
                    inComeView.incomeMonthsLabel.text = "\(unwrappedMonth)"
                } else {
                    inComeView.incomeMonthsLabel.text = "\(String(describing: month)) Bilinmiyor"
                }

                if let unwrappedCurrency = currency {
                    inComeView.totalIncomeLabel.text = "\(inComeTotal) \(unwrappedCurrency)"
                } else {
                    inComeView.totalIncomeLabel.text = "\(inComeTotal) Bilinmiyor"
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
