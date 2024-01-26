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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = UIColor.white
        setupView()
        view.backgroundColor = Colors.piesGreenColor
    }
    
    private func setupView() {
        investment = Investment(viewModel: viewModel)
        view.addSubview(investment)
        
        investment.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
