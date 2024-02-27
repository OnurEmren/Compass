//
//  DeptViewController.swift
//  Compass
//
//  Created by Onur Emren on 9.02.2024.
//

import UIKit
import CoreData

class DeptViewController: UIViewController, Coordinating, DeptViewSaveProtocol {
   
    
    var coordinator: Coordinator?
    private var deptView: DeptView!
    private var deptViewModel: DeptViewModel!
    
    init(viewModel: DeptViewModel) {
        self.deptViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationSettings()
        setupView()
        view.backgroundColor = .black
    }
    
    private func navigationSettings() {
        title = "Tüm alanları doldurunuz."
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let saveButton = UIBarButtonItem(
            title: "Kaydet",
            style: .done,
            target: self,
            action: #selector(saveButtonTapped)
        )
        navigationItem.rightBarButtonItem = saveButton
    }
    private func setupView() {
        deptView = DeptView(viewModel: deptViewModel)
        view.addSubview(deptView)
        
        deptView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - Save Business
    
    @objc
    private func saveButtonTapped() {
        deptView.saveButtonTapped()
    }
    
    func didTapSaveDeptData(deptAmountTextField: String?, dateTextField: String?, personTextField: String?) {
        guard let deptAmountTextField = Double(deptAmountTextField ?? ""),
              let personTextField = personTextField,
              let dateTextField = dateTextField
        else {
            print("Geçersiz veri")
            return
        }
        
        do {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            if let deptEntity = NSEntityDescription.insertNewObject(forEntityName: "DeptEntry", into: context) as? DeptEntry {
                deptEntity.deptAmount  = deptAmountTextField
                deptEntity.person = personTextField
                deptEntity.date = dateTextField
                
                do {
                    try context.save()
                    showToast(message: "Borç kaydedildi.")
                    print("Veri başarıyla kaydedildi.")
                } catch {
                    print("Veri kaydedilemedi. Hata: \(error)")
                }
            }
        }
    }
}
