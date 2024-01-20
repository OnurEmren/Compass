//
//  InComeEntryPickerView.swift
//  Compass
//
//  Created by Onur Emren on 20.01.2024.
//

import Foundation
import UIKit

protocol IncomeEntryViewDelegate: AnyObject {
    func didTapSaveButton(incomeText: String?,
                          sideIncomeText: String?,
                          inComeType: String?,
                          currency: String?)
}

protocol InComeUpdateViewDelegate: AnyObject {
    func didTapUpdateButton(inComeType: String?,
                            newWage: String,
                            newSideInCome: String)
}

protocol IncomeTypePickerViewDelegate: AnyObject {
    func didSelectIncomeType(_ incomeType: String)
}

class InComeEntryPickerView: UIView {

    private let saveButton: UIButton = {
            let button = UIButton()
            button.setTitle("Kaydet", for: .normal)
            button.backgroundColor = Colors.darkThemeColor
            button.layer.cornerRadius = 8
            return button
        }()
    private let inComePickerView = UIPickerView()
    
    private let incomeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Maaşınızı girin"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = Colors.lightThemeColor
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let sideIncomeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Yan Gelirinizi girin"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = Colors.lightThemeColor
        textField.keyboardType = .numberPad
        return textField
    }()
    
    weak var delegate: IncomeTypePickerViewDelegate?
    weak var saveDelegate: IncomeEntryViewDelegate?
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
    
    private let inComeTypeLabel: UITextField = {
        let label = UITextField()
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
    
    private let updateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Güncelle", for: .normal)
        button.backgroundColor = Colors.darkThemeColor
        button.layer.cornerRadius = 8
        return button
    }()

    let inComeType = ["Maaş", "Yan Gelir", "Diğer"]
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
        addSubview(incomeTextField)
        addSubview(sideIncomeTextField)
        addSubview(inComeTypeLabel)
        addSubview(currencyTypeLabel)
        addSubview(saveButton)
        addSubview(updateButton)
        
        inComePickerView.dataSource = self
        inComePickerView.delegate = self
        inComeTypeLabel.inputView = inComePickerView
        inComePickerView.setPickerView()
        
        currencyPickerView.delegate = self
        currencyPickerView.dataSource = self
        currencyTypeLabel.inputView = currencyPickerView
        currencyPickerView.setPickerView()
                
        
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
            incomeText: incomeTextField.text,
            sideIncomeText: sideIncomeTextField.text,
            inComeType: inComeTypeLabel.text,
            currency: currencyTypeLabel.text
        )
    }
    
    @objc private func updateButtonTapped() {
        updateDelegate?.didTapUpdateButton(
            inComeType: inComeTypeLabel.text ?? "",
            newWage: incomeTextField.text ?? "",
            newSideInCome: sideIncomeTextField.text ?? ""
        )
    }
}

//MARK: - Extensions

extension InComeEntryPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == inComePickerView {
            return inComeType.count
        } else if pickerView == currencyPickerView {
            return currencies.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == inComePickerView {
            return inComeType[row]
        } else if pickerView == currencyPickerView {
            return currencies[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == inComePickerView {
            let selectedIncomeType = inComeType[row]
            inComeTypeLabel.text = selectedIncomeType
            delegate?.didSelectIncomeType(selectedIncomeType)
        } else if pickerView == currencyPickerView {
            let selectedCurrency = currencies[row]
            currencyTypeLabel.text = selectedCurrency
            print("Seçilen Para Birimi: \(selectedCurrency)")
        }
    }
}

extension UIView {
    func showToast(message: String) {
        let toastLabel = UILabel(frame: CGRect(x: self.frame.size.width/2 - 150, y: self.frame.size.height-100, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.boldSystemFont(ofSize: 15)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds  =  true
        self.addSubview(toastLabel)
        
        UIView.animate(withDuration: 1.0, delay: 0.2, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
}

extension UITextField {
    func setTextField(_ placeHolder: String) {
        self.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        self.borderStyle = .roundedRect
        self.textColor = .brown
        self.backgroundColor = Colors.beigeColor
        self.placeholder = placeHolder
    }
}

extension UIPickerView {
    func setPickerView() {
        self.backgroundColor = Colors.beigeColor
        self.tintColor = .brown
    }
}
