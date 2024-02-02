//
//  GeneralExpenseView.swift
//  Compass
//
//  Created by Onur Emren on 28.01.2024.
//

import Foundation
import UIKit

protocol GeneralExpenseSaveDelegate: AnyObject {
    func didTapGeneralExpenseSave(
        rentExpenseText: String?,
        creditCardExpenseText: String?)
}

protocol GeneralExpenseTypePickerViewDelegate: AnyObject {
    func didSelectIncomeType(_ incomeType: String)
}

class GeneralExpenseView: UIView {
    private var rentExpenseLabel = UITextField()
    private var creditCardExpenseLabel = UITextField()
    private var month = UITextField()
    private var saveButton = UIButton()
    weak var generalExpenseDelegate: GeneralExpenseSaveDelegate?
    private let monthsPickerView = UIPickerView()
    private let monthLabel: UITextField = {
        let label = UITextField()
        label.text = "Dönem"
        label.layer.borderWidth = 0.7
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.textColor = .white
        label.font = Fonts.generalFont
        label.isUserInteractionEnabled = true
        return label
    }()
    private let months = ["Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran", "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık"]
    weak var delegate: ExpenseTypePickerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc
    private func handleTap() {
        self.endEditing(true)
    }
    
    private func setupView() {
        addSubview(rentExpenseLabel)
        addSubview(creditCardExpenseLabel)
        addSubview(saveButton)
        addSubview(monthLabel)
        
        rentExpenseLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
        creditCardExpenseLabel.snp.makeConstraints { make in
            make.top.equalTo(rentExpenseLabel.snp.top).offset(60)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
        monthLabel.snp.makeConstraints { make in
            make.top.equalTo(creditCardExpenseLabel.snp.top).offset(60)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(monthLabel.snp.top).offset(60)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
        //RentExpenseLabel Settings
        rentExpenseLabel.attributedPlaceholder = NSAttributedString(
            string: "Yatırım yaptığınız tarihi giriniz",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        rentExpenseLabel.layer.cornerRadius = 10
        rentExpenseLabel.layer.borderWidth = 0.7
        rentExpenseLabel.layer.masksToBounds = true
        rentExpenseLabel.placeholder = "Kira Gideri"
        rentExpenseLabel.textColor = .white
        rentExpenseLabel.font = Fonts.generalFont
        rentExpenseLabel.textAlignment = .center
        rentExpenseLabel.layer.borderColor = UIColor.white.cgColor
        rentExpenseLabel.keyboardType = .numberPad
        
        //CreditCartLabel Settings
        creditCardExpenseLabel.attributedPlaceholder = NSAttributedString(
            string: "Yatırım yaptığınız tarihi giriniz",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        creditCardExpenseLabel.layer.cornerRadius = 10
        creditCardExpenseLabel.layer.borderWidth = 0.7
        creditCardExpenseLabel.layer.masksToBounds = true
        creditCardExpenseLabel.textColor = .white
        creditCardExpenseLabel.textAlignment = .center
        creditCardExpenseLabel.font = Fonts.generalFont
        creditCardExpenseLabel.placeholder = "Kredi Kartı Gideri"
        creditCardExpenseLabel.layer.borderColor = UIColor.white.cgColor
        creditCardExpenseLabel.keyboardType = .numberPad
        
        monthsPickerView.dataSource = self
        monthsPickerView.delegate = self
        monthLabel.inputView = monthsPickerView
        
        //Button Settings
        saveButton.setTitle("Kaydet", for: .normal)
        saveButton.backgroundColor = Colors.tryColor
        saveButton.titleLabel?.font = Fonts.generalFont
        saveButton.tintColor = .black
        saveButton.layer.cornerRadius = 10
        saveButton.layer.borderWidth = 0.7
        saveButton.layer.borderColor = UIColor.white.cgColor
        saveButton.layer.masksToBounds = true
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func saveButtonTapped() {
        generalExpenseDelegate?.didTapGeneralExpenseSave(
            rentExpenseText: rentExpenseLabel.text,
            creditCardExpenseText: creditCardExpenseLabel.text
        )
    }
}

extension GeneralExpenseView: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return months.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return months[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedMonth = months[row]
        monthLabel.text = selectedMonth
    }
}

