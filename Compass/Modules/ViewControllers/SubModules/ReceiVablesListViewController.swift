//
//  ReceiVablesListViewController.swift
//  Compass
//
//  Created by Onur Emren on 5.02.2024.
//

import UIKit

class ReceiVablesListViewController: UIViewController, Coordinating, ReceivablesListViewModelDelegate {
    func dataDidUpdate(records: [ReceivablesEntry]) {
        updateView(with: records)
    }
    
    var coordinator: Coordinator?
    var receivablesListView = ReceivablesListView()
    private var viewModel: ReceivablesListViewModel!
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var attendanceRecords: [InvestmentEntry] = []
    private var record: InvestmentEntry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        navigationSettings()
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
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    private func navigationSettings() {
        title = "Alacaklarım"
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    //MARK: - Private Methods
    
    private func setupViewModel() {
        viewModel = ReceivablesListViewModel()
        viewModel.delegate = self
    }
    
    private func setupView() {
        view.addSubview(receivablesListView)
        
        receivablesListView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc
    private func addButtonTapped() {
        coordinator?.eventOccured(with: .goToReceivablesEntryVC)
    }
    
    private func updateView(with records: [ReceivablesEntry]) {
        receivablesListView.updateAttendanceRecords(records)
    }
    
    private func loadAttendanceRecords() {
        viewModel.loadAttendanceRecords()
    }
}
