//
//  ExpenseEntryView.swift
//  Compass
//
//  Created by Onur Emren on 21.01.2024.
//

import Foundation
import UIKit

protocol ExpenseEntryViewDelegate: AnyObject {
    func didTapSaveButton(clothesExpenseText: String?,
                          electronicExpenseText: String?,
                          fuelExpenseText: String?,
                          foodExpenseText: String?,
                          rentExpenseText: String?,
                          taxExpenseText: String?)
}

protocol ExpenseUpdateViewDelegate: AnyObject {
    func didTapUpdateButton(inComeType: String?,
                            newWage: String,
                            newSideInCome: String)
}

protocol ExpenseTypePickerViewDelegate: AnyObject {
    func didSelectIncomeType(_ incomeType: String)
}

class ExpenseEntryView: UIView {

    private let saveButton: UIButton = {
            let button = UIButton()
            button.setTitle("Kaydet", for: .normal)
            button.backgroundColor = Colors.darkThemeColor
            button.layer.cornerRadius = 8
            return button
        }()
    private let expensePickerView = UIPickerView()
    
    private let clothesExpenseText: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Tekstil Ürünleri Harcamanızı girin"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.backgroundColor = Colors.lightThemeColor
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let electronicExpenseText: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Elektronik Harcamanızı girin"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = Colors.lightThemeColor
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let taxExpenseText: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Fatura Giderlerinizi girin"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = Colors.lightThemeColor
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let foodExpenseText: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Gıda Harcamanızı girin"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = Colors.lightThemeColor
        textField.keyboardType = .numberPad
        return textField
    }()
    private let fuelExpenseText: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Akaryakıt Harcamanızı girin"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = Colors.lightThemeColor
        textField.keyboardType = .numberPad
        return textField
    }()
    private let rentExpenseText: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Kira Giderinizi Girin"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = Colors.lightThemeColor
        textField.keyboardType = .numberPad
        return textField
    }()
    weak var delegate: ExpenseTypePickerViewDelegate?
    weak var saveDelegate: ExpenseEntryViewDelegate?
    weak var updateDelegate: InComeUpdateViewDelegate?
    
    private let currencyTypeLabel: UITextField = {
        let label = UITextField()
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
    
    private let currencyPickerView = UIPickerView()
    
    private let expenseTypeLabel: UITextField = {
        let label = UITextField()
        label.text = "Gider Türü"
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
    
    private let updateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Güncelle", for: .normal)
        button.backgroundColor = Colors.darkThemeColor
        button.layer.cornerRadius = 8
        return button
    }()

    let expenseType = ["Gıda", "Giyim", "Ulaşım", "Akaryakıt", "Kira", "Elektronik"]
    private let currencies = ["USD", "EUR", "TRY", "GBP", "JPY"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Methods
    
    private func setGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    //MARK: - Handle Methods
    
    @objc
    private func handleTap() {
        self.endEditing(true)
    }
    
    private func setupViews() {
        addSubview(clothesExpenseText)
        addSubview(electronicExpenseText)
        addSubview(expenseTypeLabel)
        addSubview(foodExpenseText)
        addSubview(fuelExpenseText)
        addSubview(rentExpenseText)
        addSubview(taxExpenseText)
        addSubview(currencyTypeLabel)
        addSubview(saveButton)
        addSubview(updateButton)
        
        expensePickerView.dataSource = self
        expensePickerView.delegate = self
        expenseTypeLabel.inputView = expensePickerView
        expensePickerView.setPickerView()
                
        currencyPickerView.delegate = self
        currencyPickerView.dataSource = self
        currencyTypeLabel.inputView = currencyPickerView
        currencyPickerView.setPickerView()
                
        
        clothesExpenseText.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(150)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        electronicExpenseText.snp.makeConstraints { make in
            make.top.equalTo(clothesExpenseText.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        foodExpenseText.snp.makeConstraints { make in
            make.top.equalTo(electronicExpenseText.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        fuelExpenseText.snp.makeConstraints { make in
            make.top.equalTo(foodExpenseText.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        rentExpenseText.snp.makeConstraints { make in
            make.top.equalTo(fuelExpenseText.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        taxExpenseText.snp.makeConstraints { make in
            make.top.equalTo(rentExpenseText.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        expenseTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(taxExpenseText.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        currencyTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(expenseTypeLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        saveButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(currencyTypeLabel.snp.bottom).offset(30)
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
        
        updateButton.snp.makeConstraints { make in
            make.top.equalTo(saveButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
        
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        updateButton.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func saveButtonTapped() {
        saveDelegate?.didTapSaveButton(
            clothesExpenseText: clothesExpenseText.text,
            electronicExpenseText: electronicExpenseText.text,
            fuelExpenseText: fuelExpenseText.text,
            foodExpenseText: foodExpenseText.text,
            rentExpenseText: rentExpenseText.text,
            taxExpenseText: taxExpenseText.text
        )
    }
    
    @objc private func updateButtonTapped() {
        updateDelegate?.didTapUpdateButton(
            inComeType: expenseTypeLabel.text ?? "",
            newWage: clothesExpenseText.text ?? "",
            newSideInCome: electronicExpenseText.text ?? ""
        )
    }
}

//MARK: - Extensions

extension ExpenseEntryView: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == expensePickerView {
            return expenseType.count
        } else if pickerView == currencyPickerView {
            return currencies.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == expensePickerView {
            return expenseType[row]
        } else if pickerView == currencyPickerView {
            return currencies[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == expensePickerView {
            let selectedIncomeType = expenseType[row]
            expenseTypeLabel.text = selectedIncomeType
            delegate?.didSelectIncomeType(selectedIncomeType)
        } else if pickerView == currencyPickerView {
            let selectedCurrency = currencies[row]
            currencyTypeLabel.text = selectedCurrency
            print("Seçilen Para Birimi: \(selectedCurrency)")
        }
    }
}
