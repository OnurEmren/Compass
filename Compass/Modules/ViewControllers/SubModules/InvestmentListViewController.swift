//
//  InvestmentListViewController.swift
//  Compass
//
//  Created by Onur Emren on 26.01.2024.
//

import UIKit

class InvestmentListViewController: UIViewController, Coordinating {
    var coordinator: Coordinator?
    var investmentListView = InvestmentListView()
    private var viewModel: InvestmentListViewModel!
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var attendanceRecords: [InvestmentEntry] = []
    private var record: InvestmentEntry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        setupView()
        updateView(with: [])
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped)
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadAttendanceRecords()
    }
    
    //MARK: - Private Methods
    
    private func setupViewModel() {
        viewModel = InvestmentListViewModel()
        viewModel.delegate = self
    }
    
    private func setupView() {
        view.addSubview(investmentListView)
        
        investmentListView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func addButtonTapped() {
        coordinator?.eventOccured(with: .goToInvestmentEntryVC)
    }
    
    
    private func updateView(with records: [InvestmentEntry]) {
        investmentListView.updateAttendanceRecords(records)
    }
    
    private func loadAttendanceRecords() {
        viewModel.loadAttendanceRecords()
    }
}

extension InvestmentListViewController: InvestmentListViewModelDelegate {
    func dataDidUpdate(records: [InvestmentEntry]) {
        updateView(with: records)
    }
}
