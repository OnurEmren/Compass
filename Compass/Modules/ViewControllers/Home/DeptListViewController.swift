//
//  DeptListViewController.swift
//  Compass
//
//  Created by Onur Emren on 9.02.2024.
//

import UIKit

class DeptListViewController: UIViewController, Coordinating, DeptListViewModelProtocol {
    
    var coordinator: Coordinator?
    private var deptListView = DeptListView()
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var deptListRecord: [DeptEntry] = []
    private var record: DeptEntry?
    private var deptViewModel = DeptListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        setupViewModel()
        setupNavigationSettings()
        setupView()
        updateView(with: [])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadDeptListRecord()
    }
    
    private func setupViewModel() {
        deptViewModel = DeptListViewModel()
        deptViewModel.delegate = self
    }
    
    private func setupNavigationSettings() {
        title = Strings.deptTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped)
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
    
    @objc
    private func addButtonTapped() {
        coordinator?.eventOccured(with: .goToDetpEntryVC)
    }
    
    private func setupView() {
        view.addSubview(deptListView)
        
        deptListView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func updateView(with records: [DeptEntry]) {
        deptListView.updateAttendanceRecords(records)
    }
    
    private func loadDeptListRecord() {
        deptViewModel.loadAttendanceRecords()
    }
    
    func dataDidUpdate(records: [DeptEntry]) {
        deptListView.updateAttendanceRecords(records)
    }
}
