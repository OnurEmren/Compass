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

class InComeViewController: UIViewController, Coordinating, ChartViewDelegate, InComeViewModelDelegate {
  
    var coordinator: Coordinator?
    private var inComeView = InComeView()
    private var inComeViewModel = InComeViewModel()
    private var fetchedInComeData: [InComeEntry] = []

    //MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.incomeTitle
        
        inComeViewModel.delegate = self
        setupNavigationView()
        setupViews()
        inComeView.incomeDistributionChart.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        inComeViewModel.fetchDataFromCoreData()
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
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
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
    
    //MARK: - Chart Methods
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
          // Kullanıcı bir dilime tıkladığında bu metod çağrılır
          if let pieChartDataEntry = entry as? PieChartDataEntry {
              // pieChartDataEntry, tıklanan dilimin bilgilerini içerir
              let value = pieChartDataEntry.value
              let label = pieChartDataEntry.label ?? ""
              let data: [InComeEntry] = []
           
              inComeView.incomeDistributionChart.centerText = "\(value)"
              // Burada tıklanan dilimle ilgili bir işlem yapabilirsiniz
              print("Tıklanan Dilim - Label: \(label), Değer: \(value)")
          }
      }
    
    func didFetchedInComeData(inComeData: [InComeEntry]) {
        self.setupChart(with: inComeData)
        self.fetchedInComeData = inComeData
    }
    
    private func setupChart(with data: [InComeEntry]) {
        inComeView.setupInComeChartView(with: data)
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
            
            if !result.isEmpty {
                showAlert(title: "Sil", message: "Genel harcamalar silinsin mi?", actions: [
                    UIAlertAction(title: "Evet", style: .default, handler: { _ in
                        self.inComeViewModel.deleteLastIncomeEntry()
                    }),
                    UIAlertAction(title: "İptal", style: .cancel, handler: { _ in
                    })
                ])
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
