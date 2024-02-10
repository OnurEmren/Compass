//
//  ExpenseViewController.swift
//  Compass
//
//  Created by Onur Emren on 17.01.2024.
//

import UIKit
import Charts
import SnapKit
import DGCharts
import CoreData

class ExpenseViewController: UIViewController, Coordinating, ExpenseViewModelDelegate {
    var coordinator: Coordinator?
    var isGeneralExpense = false
    private var expenseViewModel = ExpenseViewModel()
    var entityName = "ExpenseEntry"
    private var expenseView = ExpenseView()
    
    private let segmentedControl: UISegmentedControl = {
        let items = ["Detay Harcamalar", "Genel Harcamalar"]
        let segmented = UISegmentedControl(items: items)
        segmented.selectedSegmentIndex = 0
        return segmented
    }()

    private var fetchedGeneralData: [GeneralExpenseEntry] = []
    private var fetchedDetailData: [ExpenseEntry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        expenseViewModel.delegate = self
        view.backgroundColor = .black
        setupNavigationSettings()
        setupView()
        loadAttendanceRecords()
        segmentedControl.selectedSegmentIndex = 0
        expenseView.expenseTableView.isHidden = false
        expenseView.generalExpenseTableView.isHidden = true
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .allEvents)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if entityName == "GeneralExpenseEntry" {
            segmentedControl.selectedSegmentIndex = 1
            fetchGeneralData()
            expenseView.generalExpenseTableView.reloadData()

        } else {
            segmentedControl.selectedSegmentIndex = 0
            fetchDetailData()
            expenseView.expenseTableView.reloadData()
            setupView()
        }
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    private func setupNavigationSettings() {
        title = Strings.expenseTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(rightAddButtonTapped)
        )
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil
        )
        
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    private func setupView() {
        view.addSubview(expenseView)
        view.addSubview(segmentedControl)
        
        expenseView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(90)
        }
        
        segmentedControl.layer.borderWidth = 0.7
        segmentedControl.layer.borderColor = UIColor.white.cgColor
        segmentedControl.backgroundColor = .gray
        segmentedControl.tintColor = .black
        
        expenseView.expenseTableView.reloadData()
        expenseView.addButton.addTarget(self, action: #selector(goToAddExpense), for: .touchUpInside)
        expenseView.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    @objc
     private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
         switch sender.selectedSegmentIndex {
         case 0:
             fetchDetailData()
             entityName = "ExpenseEntry"
             expenseView.setupDetailExpenseChartView(detailExpenseData: fetchedDetailData)
             loadAttendanceRecords()
             expenseView.expenseTableView.isHidden = false
             expenseView.generalExpenseTableView.isHidden = true
             expenseView.expenseTableView.reloadData()
             expenseView.updateChart()
             break
         case 1:
             fetchGeneralData()
             entityName = "GeneralExpenseEntry"
             expenseView.setupCombinedChart(generalData: fetchedGeneralData)
             loadGeneralRecords()
             expenseView.expenseTableView.isHidden = true
             expenseView.generalExpenseTableView.isHidden = false
             expenseView.generalExpenseTableView.reloadData()
             expenseView.updateCombinedChart()
             break
         default:
             break
         }
     }
    
    func loadAttendanceRecords() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest: NSFetchRequest<ExpenseEntry> = ExpenseEntry.fetchRequest()
        do {
            let records = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
            expenseViewModel.delegate?.didFetchedDetailData(detailExpenseData: records)
            expenseView.updateExpenseRecords(records)
            expenseViewModel.fetchDataFromCoreData()
        } catch {
            print("Error fetching attendance records: \(error.localizedDescription)")
        }
    }
    
    func loadGeneralRecords() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let fetchRequest: NSFetchRequest<GeneralExpenseEntry> = GeneralExpenseEntry.fetchRequest()
        do {
            let records = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
            expenseViewModel.delegate?.didFetchGeneralData(generalData: records)
            expenseView.updateGeneralExpenseRecords(records)
            expenseViewModel.fetchDataFromCoreData()
        } catch {
            print("Error fetching attendance records: \(error.localizedDescription)")
        }
    }
    
    @objc
    private func rightAddButtonTapped() {
        coordinator?.eventOccured(with: .goToGeneralExpenseVC)
    }
    
    private func fetchDetailData() {
        expenseViewModel.fetchDetailData()
    }
    
    func didFetchGeneralData(generalData: [GeneralExpenseEntry]) {
        expenseView.setupCombinedChart(generalData: generalData)
        self.fetchedGeneralData = generalData
        
        if let lastEntry = generalData.last {
            expenseView.setupCombinedChart(generalData: [lastEntry])
        }
    }
    
    func didFetchedDetailData(detailExpenseData: [ExpenseEntry]) {
        self.setupDetailExpenseChart(expenseData: detailExpenseData)
        self.fetchedDetailData = detailExpenseData
    }
    
    private func fetchGeneralData() {
        expenseViewModel.fetchDataFromCoreData()
    }
    
    private func setupDetailExpenseChart(expenseData: [ExpenseEntry]) {
        expenseView.setupDetailExpenseChartView(detailExpenseData: expenseData)
    }
    
    @objc
    private func goToAddExpense() {
        coordinator?.eventOccured(with: .goToExpenseEntryVC)
        entityName = "ExpenseEntry"
        isGeneralExpense = false
    }
    
    @objc
    func deleteButtonTapped() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ExpenseEntry> = ExpenseEntry.fetchRequest()
        let generalFetchRequest: NSFetchRequest<GeneralExpenseEntry> = GeneralExpenseEntry.fetchRequest()
        
        if entityName == "ExpenseEntry" {
            do {
                let result = try context.fetch(fetchRequest)
                
                if !result.isEmpty {
                    showAlert(title: "Sil", message: "Genel harcamalar silinsin mi?", actions: [
                        UIAlertAction(title: "Evet", style: .default, handler: { _ in
                            self.expenseViewModel.deleteExpenseData(entityName: self.entityName)
                            self.expenseView.updateDetailChart()
                            self.expenseView.expenseTableView.reloadData()
                        }),
                        UIAlertAction(title: "İptal", style: .cancel, handler: { _ in
                            //
                        })
                    ])
                }
            } catch {
                print("Hata: \(error)")
            }
        } else {
            do {
                let result = try context.fetch(generalFetchRequest)
                
                if !result.isEmpty {
                    showAlert(title: "Sil", message: "Genel harcamalar silinsin mi?", actions: [
                        UIAlertAction(title: "Evet", style: .default, handler: { _ in
                            self.expenseViewModel.deleteExpenseData(entityName: self.entityName)
                            self.expenseView.updateGeneralChart()
                            self.expenseView.generalExpenseTableView.reloadData()
                        }),
                        UIAlertAction(title: "İptal", style: .cancel, handler: { _ in
                            // İptal butonuna tıklandığında yapılacak işlemler
                        })
                    ])
                }
            } catch {
                print("Hata: \(error)")
            }
        }
    }
}
