//
//  ReceivablesViewController.swift
//  Compass
//
//  Created by Onur Emren on 3.02.2024.
//

import UIKit
import CoreData

class ReceivablesViewController: UIViewController, Coordinating, ReceivablesViewDelegate {
 
    
    var coordinator: Coordinator?
    private var receivablesView: ReceivablesView!
    private var receiVablesViewModel: ReceivablesViewModel!
    
    //MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        navigationSettings()
        setupView()
        receivablesView.saveDelegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    //MARK: - Inits
    
    init(viewModel: ReceivablesViewModel) {
        self.receiVablesViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Navigation Settings
    
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
    
    //MARK: - View
    
    private func setupView() {
        receivablesView = ReceivablesView(viewModel: receiVablesViewModel)
        view.addSubview(receivablesView)
        
        receivablesView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - Save Business
    
    @objc
    private func saveButtonTapped() {
        receivablesView.saveButtonTapped()
    }
    
    func didTapSaveButton(receivablesAmountTextField: String?, 
                          dateTextField: String?,
                          personTextField: String?) {
        
        guard let receivablesAmountTextField = Double(receivablesAmountTextField ?? ""),
              let personTextField = personTextField,
              let dateTextField = dateTextField
        else {
            print("Geçersiz veri")
            return
        }
        
        do {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            if let receivablesEntity = NSEntityDescription.insertNewObject(forEntityName: "ReceivablesEntry", into: context) as? ReceivablesEntry {
                receivablesEntity.receivablesAmount  = receivablesAmountTextField
                receivablesEntity.person = personTextField
                receivablesEntity.date = dateTextField
                
                do {
                    try context.save()
                    showToast(message: "Alacak kaydedildi.")
                    print("Veri başarıyla kaydedildi.")
                } catch {
                    print("Veri kaydedilemedi. Hata: \(error)")
                }
            }
        }
    }
}
