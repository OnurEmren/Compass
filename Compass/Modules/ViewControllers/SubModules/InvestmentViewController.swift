//
//  InvestmentViewController.swift
//  Compass
//
//  Created by Onur Emren on 17.01.2024.
//

import UIKit

class InvestmentViewController: UIViewController, Coordinating {
    var coordinator: Coordinator?
    private var investment: Investment!
    private let viewModel: InvestmentViewModel
    
    init(viewModel: InvestmentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getServiceData()
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = UIColor.white
        
        title = "Yatırımlarım"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        view.backgroundColor = .black
        setupView()
        
        let saveButton = UIBarButtonItem(
            title: "Kaydet",
            style: .done,
            target: self,
            action: #selector(saveButtonTapped)
        )
        navigationItem.rightBarButtonItem = saveButton
        
    }
    
    private func setupView() {
        investment = Investment(viewModel: viewModel)
        view.addSubview(investment)
        
        investment.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc
    private func saveButtonTapped() {
        investment.saveButtonTapped()
    }
    
    private func getServiceData() {
//        let apiService = CurrencyServise()
//        let url = URL(string: "https://raw.githubusercontent.com/atilsamancioglu/CurrencyData/main/currency.json")!
//        apiService.fetchData(from: url) { result in
//            switch result {
//            case .success(let model):
//                DispatchQueue.main.async {
//                    var labelText = ""
//                    if let usdRate = model.rates["USD"] {
//                        labelText += "USD: \(usdRate)\n"
//                    }
//                    if let eurRate = model.rates["EUR"] {
//                        labelText += "EUR: \(eurRate)\n"
//                    }
//                    self.investment.pieceTextField.text = labelText
//                }
//
//                print(model)
//            case .failure(let error):
//                // Bir hata oluştu, hata ile ilgili işlemler
//                print("Hata: \(error)")
//            }
//        }
    }
}
