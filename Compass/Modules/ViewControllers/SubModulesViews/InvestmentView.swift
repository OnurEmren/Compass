//
//  InvestmentView.swift
//  Compass
//
//  Created by Onur Emren on 26.01.2024.
//

import UIKit
import SnapKit

class Investment: UIView, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
  
    lazy var investmentPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()
    private var viewModel: InvestmentViewModel
    let investmentOptions = ["Döviz", "Altın", "Hisse Senedi"]
    lazy var datePicker = UIDatePicker()
    private var investmentAmount = UITextField()
    private var investmentTypeTextField = UITextField()
    private var investmentDate = UITextField()
    private var saveButton = UIButton()
    
    
    init(viewModel: InvestmentViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupView()
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
    
    @objc
    private func handleTap() {
        self.endEditing(true)
    }
    
    //MARK: - Views
    
    private func setupView() {
        addSubview(investmentTypeTextField)
        addSubview(investmentDate)
        addSubview(investmentAmount)
        addSubview(saveButton)
        
        //Constraints
        investmentTypeTextField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(30)
            make.height.equalTo(40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        investmentDate.snp.makeConstraints { make in
            make.top.equalTo(investmentTypeTextField.snp.top).offset(60)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
        investmentAmount.snp.makeConstraints { make in
            make.top.equalTo(investmentDate.snp.top).offset(60)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(investmentAmount.snp.top).offset(60)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
        //AmountTextField Settings
        investmentAmount.delegate = self
        investmentAmount.keyboardType = .numberPad
        investmentAmount.layer.borderWidth = 0.7
        investmentAmount.layer.borderColor = UIColor.white.cgColor
        investmentAmount.layer.cornerRadius = 10
        investmentAmount.layer.masksToBounds = true
        investmentAmount.textColor = .white
        investmentAmount.textAlignment = .center
        investmentAmount.attributedPlaceholder = NSAttributedString(
            string: "Yatırım miktarınızı giriniz",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        
        //InvestmentDateTextField Settings
        investmentDate.attributedPlaceholder = NSAttributedString(
            string: "Yatırım yaptığınız tarihi giriniz",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        investmentDate.inputView = datePicker
        investmentDate.layer.borderWidth = 0.7
        investmentDate.layer.borderColor = UIColor.white.cgColor
        investmentDate.layer.cornerRadius = 10
        investmentDate.layer.masksToBounds = true
        investmentDate.textColor = .white
        investmentDate.textAlignment = .center
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        investmentDate.inputView = datePicker
        datePicker.setDatePickerView(datePicker)
        
        //InvestmentTypeTextField Setting
        investmentTypeTextField.attributedPlaceholder = NSAttributedString(
            string: "Hangi alanda yatırım yaptınız",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        investmentTypeTextField.inputView = investmentPicker
        investmentTypeTextField.layer.borderWidth = 0.7
        investmentTypeTextField.layer.borderColor = UIColor.white.cgColor
        investmentTypeTextField.layer.cornerRadius = 10
        investmentTypeTextField.layer.masksToBounds = true
        investmentTypeTextField.textColor = .white
        investmentTypeTextField.textAlignment = .center
        
        //Button Settings
        saveButton.setTitle("Kaydet", for: .normal)
        saveButton.layer.cornerRadius = 10
        saveButton.layer.borderWidth = 0.7
        saveButton.layer.borderColor = UIColor.white.cgColor
        saveButton.layer.masksToBounds = true
        saveButton.backgroundColor = Colors.buttonColor
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func saveButtonTapped() {
        guard let investmentType = investmentTypeTextField.text,
              let amountText = investmentAmount.text,
              let date = investmentDate.text else {
            return
        }
        
        // amountText'i Double'a çevir
        guard let amount = Double(amountText) else {
            print("Geçersiz miktar formatı")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        guard let selectedDate = dateFormatter.date(from: date) else {
            print("Geçersiz tarih formatı")
            return
        }
        
        viewModel.saveLesson(invesmentType: investmentType, amount: amount, selectedDate: selectedDate)
    }

    
    @objc
    public func datePickerValueChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        investmentDate.text = dateFormatter.string(from: datePicker.date)
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

extension UIDatePicker {
    func setDatePickerView(_ datePicker: UIDatePicker) {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.tintColor = .brown
        datePicker.backgroundColor = Colors.beigeColor
    }
}
