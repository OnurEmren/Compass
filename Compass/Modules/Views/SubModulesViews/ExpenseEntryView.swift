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
                          fuelExpenseText: String?,
                          foodExpenseText: String?,
                          rentExpenseText: String?,
                          taxExpenseText: String?,
                          month: String?
    )
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
    
    private let expensePickerView = UIPickerView()
    private let monthsPickerView = UIPickerView()
    
    private let clothesExpenseText: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Tekstil Ürünleri Harcamanızı girin"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.backgroundColor = Colors.lightThemeColor
        textField.keyboardType = .numberPad
        textField.font = Fonts.generalFont
        return textField
    }()
    
    private let electronicExpenseText: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Elektronik Harcamanızı girin"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = Colors.lightThemeColor
        textField.keyboardType = .numberPad
        textField.font = Fonts.generalFont
        return textField
    }()
    
    private let taxExpenseText: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Fatura Giderlerim"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = Colors.lightThemeColor
        textField.keyboardType = .numberPad
        textField.font = Fonts.generalFont
        return textField
    }()
    
    private let foodExpenseText: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Gıda Harcamalarım"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = Colors.lightThemeColor
        textField.keyboardType = .numberPad
        textField.font = Fonts.generalFont
        return textField
    }()
    private let fuelExpenseText: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Akaryakıt Harcamalarım"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = Colors.lightThemeColor
        textField.keyboardType = .numberPad
        textField.font = Fonts.generalFont
        return textField
    }()
    
    private let rentExpenseText: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Kira Giderim"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = Colors.lightThemeColor
        textField.keyboardType = .numberPad
        textField.font = Fonts.generalFont
        return textField
    }()
    
    private let transportExpenseText: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Ulaşım Giderim"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = Colors.lightThemeColor
        textField.keyboardType = .numberPad
        textField.font = Fonts.generalFont
        return textField
    }()
    
    private let currencyTypeLabel: UITextField = {
        let textField = UITextField()
        textField.text = "Para Birimi"
        textField.layer.borderWidth = 0.7
        textField.layer.borderColor = Colors.darkThemeColor.cgColor
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.textAlignment = .center
        textField.font = Fonts.generalFont
        textField.textColor = .darkGray
        textField.backgroundColor = Colors.lightThemeColor
        textField.isUserInteractionEnabled = true
        return textField
    }()
    
    
    private let expenseTypeLabel: UITextField = {
        let label = UITextField()
        label.text = "Gider Türü"
        label.layer.borderWidth = 0.7
        label.layer.borderColor = Colors.darkThemeColor.cgColor
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.font = Fonts.generalFont
        label.textColor = .darkGray
        label.backgroundColor = Colors.lightThemeColor
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let monthLabel: UITextField = {
        let label = UITextField()
        label.text = "Dönem:"
        label.layer.borderWidth = 0.7
        label.layer.borderColor = Colors.darkThemeColor.cgColor
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.textColor = .darkGray
        label.backgroundColor = Colors.lightThemeColor
        label.font = Fonts.generalFont
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let imageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "spiral"))
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private let currencies = ["USD", "EUR", "TRY", "GBP", "JPY"]
    private let months = ["Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran", "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık"]
    private let currencyPickerView = UIPickerView()
    weak var delegate: ExpenseTypePickerViewDelegate?
    weak var saveDelegate: ExpenseEntryViewDelegate?
    
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
        addSubview(monthLabel)
        addSubview(clothesExpenseText)
        addSubview(foodExpenseText)
        addSubview(fuelExpenseText)
        addSubview(rentExpenseText)
        addSubview(taxExpenseText)
        addSubview(currencyTypeLabel)
        
        expensePickerView.dataSource = self
        expensePickerView.delegate = self
        expenseTypeLabel.inputView = expensePickerView
        expensePickerView.setPickerView()
        
        currencyPickerView.delegate = self
        currencyPickerView.dataSource = self
        currencyTypeLabel.inputView = currencyPickerView
        currencyPickerView.setPickerView()
        
        monthsPickerView.delegate = self
        monthsPickerView.dataSource = self
        monthLabel.inputView = monthsPickerView
        monthsPickerView.setPickerView()
        
        
        monthLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(150)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        clothesExpenseText.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(200)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        foodExpenseText.snp.makeConstraints { make in
            make.top.equalTo(clothesExpenseText.snp.bottom).offset(20)
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
        
        currencyTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(taxExpenseText.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        insertSubview(imageView, at: 0)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc
    func saveButtonTapped() {
        saveDelegate?.didTapSaveButton(
            clothesExpenseText: clothesExpenseText.text,
            fuelExpenseText: fuelExpenseText.text,
            foodExpenseText: foodExpenseText.text,
            rentExpenseText: rentExpenseText.text,
            taxExpenseText: taxExpenseText.text,
            month: monthLabel.text
        )
    }
}

//MARK: - Extensions

extension ExpenseEntryView: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == monthsPickerView {
            return months.count
        } else if pickerView == currencyPickerView {
            return currencies.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == monthsPickerView {
            return months[row]
        } else if pickerView == currencyPickerView {
            return currencies[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == monthsPickerView {
            let selectedMonth = months[row]
            monthLabel.text = selectedMonth
        } else if pickerView == currencyPickerView {
            let selectedCurrency = currencies[row]
            currencyTypeLabel.text = selectedCurrency
        }
    }
    
    private func getViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            responder = nextResponder
            if let viewController = responder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

