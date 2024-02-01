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

class InComeViewController: UIViewController, Coordinating, ChartViewDelegate {
    var coordinator: Coordinator?
    private var inComeView = InComeView()
    
    //MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.incomeTitle
        setupNavigationView()
        setupViews()
        inComeView.incomeDistributionChart.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchDataFromCoreData()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.tryColor]

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
        view.addSubview(inComeView)
        
        inComeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        inComeView.addButton.addTarget(self, action: #selector(goToAddInCome), for: .touchUpInside)
        inComeView.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
          // Kullanıcı bir dilime tıkladığında bu metod çağrılır
          if let pieChartDataEntry = entry as? PieChartDataEntry {
              // pieChartDataEntry, tıklanan dilimin bilgilerini içerir
              let value = pieChartDataEntry.value
              let label = pieChartDataEntry.label ?? ""
              let data: [InComeEntry] = []
           
              inComeView.incomeDistributionChart.centerText = "\(label), Değer: \(value)"

              // Burada tıklanan dilimle ilgili bir işlem yapabilirsiniz
              print("Tıklanan Dilim - Label: \(label), Değer: \(value)")
          }
      }
    
    private func setupChart(with data: [InComeEntry]) {
        var wageEntries: [PieChartDataEntry] = []
        var sideIncomeEntries: [PieChartDataEntry] = []
   

        for (_, entry) in data.enumerated() {
            
            if let unwrappedCurrency = entry.currency {
                let wageEntry = PieChartDataEntry(value: entry.wage, label: "Maaş \(unwrappedCurrency)")
                let sideIncomeEntry = PieChartDataEntry(value: entry.sideInCome, label: "Yan Gelir \(unwrappedCurrency)")
                wageEntries.append(wageEntry)
                sideIncomeEntries.append(sideIncomeEntry)
            }
            
            let wageEntry = PieChartDataEntry(value: entry.wage, label: "Maaş \(entry.wage)")

        }

        let combinedEntries = wageEntries + sideIncomeEntries

        // Toplam yüzdelik oranları hesapla
        let toplamYuzde = combinedEntries.reduce(0) { $0 + $1.value }
        let yuzdelikOranlari = combinedEntries.map { $0.value / toplamYuzde }

        // Yüzdelik oranlarını etiketleme
        for (index, entry) in combinedEntries.enumerated() {
            if let yuzdelikOran = yuzdelikOranlari[safe: index] {
                let formattedOran = String(format: "%.2f%%", yuzdelikOran * 100)
                
                // Label değerini güvenli bir şekilde güncelle
                entry.label = entry.label.map { "\($0) - \(formattedOran)" } ?? "\(formattedOran)"
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

        inComeView.incomeDistributionChart.data = combinedData
        inComeView.incomeDistributionChart.centerText = "Maaş ve Yan Gelir Dağılımı"
        inComeView.incomeDistributionChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeOutBack)
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

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
