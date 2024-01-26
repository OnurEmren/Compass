//
//  InvestmentView.swift
//  Compass
//
//  Created by Onur Emren on 26.01.2024.
//

import UIKit
import SnapKit

class Investment: UIView, UIPickerViewDataSource, UIPickerViewDelegate {

    let investmentOptions = ["Döviz", "Altın", "Hisse Senedi"]

    lazy var investmentPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()
    
    private var investmentTypeTextField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(investmentTypeTextField)
        investmentTypeTextField.text = "Yatırım Türü"
        investmentTypeTextField.inputView = investmentPicker
        
        investmentTypeTextField.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    // MARK: - UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return investmentOptions.count
    }

    // MARK: - UIPickerViewDelegate

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return investmentOptions[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedInvestment = investmentOptions[row]
        investmentTypeTextField.text = selectedInvestment
        
    }
}
