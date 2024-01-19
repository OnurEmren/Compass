//
//  InComeEntryView.swift
//  Compass
//
//  Created by Onur Emren on 18.01.2024.
//

import Foundation
import UIKit
import SnapKit

protocol IncomeEntryViewDelegate: AnyObject {
    func didTapSaveButton(incomeText: String?, sideIncomeText: String?, inComeType: String?)
}

protocol IncomeTypePickerViewDelegate: AnyObject {
    func didSelectIncomeType(_ incomeType: String)
}

class IncomeEntryView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private var isPickerVisible: Bool = false
    private var isCurrencyPickerVisible: Bool = false
    weak var delegate: IncomeTypePickerViewDelegate?
    weak var saveDelegate: IncomeEntryViewDelegate?
    
    private let incomeTypePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    private let incomeTypes = ["Maaş", "Yatırım Getirisi", "Diğer"]
    
    private let incomeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Maaşınızı girin"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = Colors.lightThemeColor
        return textField
    }()
    
    private let sideIncomeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Yan Gelirinizi girin"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = Colors.lightThemeColor
        return textField
    }()
    
    private let inComeTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "Gelir Tipi"
        label.layer.borderWidth = 0.7
        label.layer.borderColor = Colors.darkThemeColor.cgColor
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .darkGray
        label.backgroundColor = Colors.lightThemeColor
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let currencyTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "Para Birimi"
        label.layer.borderWidth = 0.7
        label.layer.borderColor = Colors.darkThemeColor.cgColor
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .darkGray
        label.backgroundColor = Colors.lightThemeColor
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let currencyPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Kaydet", for: .normal)
        button.backgroundColor = Colors.darkThemeColor
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let currencies = ["USD", "EUR", "TRY", "GBP", "JPY"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Colors.beigeColor
        setupViews()
        setupIncomeTypePicker()
        setupCurrencyPicker()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupIncomeTypePicker()
        setupCurrencyPicker()
    }
    
    private func setupViews() {
        addSubview(incomeTextField)
        addSubview(sideIncomeTextField)
        addSubview(inComeTypeLabel)
        addSubview(currencyTypeLabel)
        addSubview(saveButton)
        
        incomeTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(150)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        sideIncomeTextField.snp.makeConstraints { make in
            make.top.equalTo(incomeTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        inComeTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(sideIncomeTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        currencyTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(inComeTypeLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(currencyTypeLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
        currencyPickerView.isHidden = true
        incomeTypePickerView.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(inComeTypeLabelTapped))
        let currencyTapGesture = UITapGestureRecognizer(target: self, action: #selector(currencyTypeLabelTapped))
        currencyTypeLabel.addGestureRecognizer(currencyTapGesture)
        inComeTypeLabel.addGestureRecognizer(tapGesture)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    //PickerView Setup
    private func setupIncomeTypePicker() {
        incomeTypePickerView.delegate = self
        incomeTypePickerView.dataSource = self
        addSubview(incomeTypePickerView)
        
        incomeTypePickerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
            make.height.equalTo(150)
        }
    }
    
    private func setupCurrencyPicker() {
        currencyPickerView.delegate = self
        currencyPickerView.dataSource = self
        addSubview(currencyPickerView)
        
        currencyPickerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
            make.height.equalTo(150)
        }
    }
    
    @objc private func inComeTypeLabelTapped() {
        isPickerVisible.toggle()
        updatePickerVisibility()
    }
    
    private func updatePickerVisibility() {
        incomeTypePickerView.isHidden = !isPickerVisible
    }
    
    @objc private func currencyTypeLabelTapped() {
        isCurrencyPickerVisible.toggle()
        updateCurrencyPickerVisibility()
    }
    
    private func updateCurrencyPickerVisibility() {
        currencyPickerView.isHidden = !isCurrencyPickerVisible
        if isCurrencyPickerVisible {
            incomeTypePickerView.isHidden = true
        }
    }

    
    @objc private func saveButtonTapped() {
        saveDelegate?.didTapSaveButton(
            incomeText: incomeTextField.text,
            sideIncomeText: sideIncomeTextField.text,
            inComeType: inComeTypeLabel.text
        )
    }
    
    //PickerView Methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == incomeTypePickerView {
            return incomeTypes.count
        } else if pickerView == currencyPickerView {
            return currencies.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == incomeTypePickerView {
            return incomeTypes[row]
        } else if pickerView == currencyPickerView {
            return currencies[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == incomeTypePickerView {
            let selectedIncomeType = incomeTypes[row]
            inComeTypeLabel.text = selectedIncomeType
            delegate?.didSelectIncomeType(selectedIncomeType)
        } else if pickerView == currencyPickerView {
            let selectedCurrency = currencies[row]
            currencyTypeLabel.text = selectedCurrency
            print("Seçilen Para Birimi: \(selectedCurrency)")
        }
    }
}
