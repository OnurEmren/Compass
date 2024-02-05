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
        
        view.backgroundColor = .black
        inComeViewModel.delegate = self
        setupNavigationView()
        setupViews()
        loadAttendanceRecords()
        inComeView.incomeDistributionChart.delegate = self
    }
    
    func loadAttendanceRecords() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest: NSFetchRequest<InComeEntry> = InComeEntry.fetchRequest()
        do {
            let records = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
            inComeViewModel.delegate?.didFetchedInComeData(inComeData: records)
            updateView(with: records)
        } catch {
            print("Error fetching attendance records: \(error.localizedDescription)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        inComeViewModel.fetchDataFromCoreData()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
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
    
    func didFetchedInComeData(inComeData: [InComeEntry]) {
        self.setupChart(with: inComeData)
        self.fetchedInComeData = inComeData
    }
    
    private func setupChart(with data: [InComeEntry]) {
        inComeView.setupInComeChartView(with: data)
    }
    
    private func updateView(with records: [InComeEntry]) {
        inComeView.updateAttendanceRecords(records)
        inComeViewModel.fetchDataFromCoreData()
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
                showAlert(title: "Sil", message: "Tüm gelirler silinsin mi?", actions: [
                    UIAlertAction(title: "Evet", style: .default, handler: { _ in
                        self.inComeViewModel.deleteLastIncomeEntry()
                        self.inComeView.updateChart()
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

//MARK: - Extensions

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
