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
                          currency: String?,
                          month: String?)
}

protocol IncomeTypePickerViewDelegate: AnyObject {
    func didSelectIncomeType(_ incomeType: String)
}

class InComeEntryPickerView: UIView {
    weak var delegate: IncomeTypePickerViewDelegate?
    weak var saveDelegate: IncomeEntryViewDelegate?
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Kaydet", for: .normal)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 8
        button.titleLabel?.font = Fonts.generalFont
        return button
    }()
    private let inComePickerView = UIPickerView()
    
    private let incomeTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Maaşım",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.textColor = .white
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.textAlignment = .center
        textField.backgroundColor = .clear
        textField.layer.borderWidth = 0.7
        textField.layer.borderColor = UIColor.white.cgColor
        textField.keyboardType = .numberPad
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        return textField
    }()
    
    private let sideIncomeTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Yan Gelirlerim",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.textColor = .white
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.textAlignment = .center
        textField.backgroundColor = .clear
        textField.layer.borderWidth = 0.7
        textField.layer.borderColor = UIColor.white.cgColor
        textField.keyboardType = .numberPad
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        return textField
    }()
    
    private let currencyTypeLabel: UITextField = {
        let label = UITextField()
        label.text = "Para Birimi"
        label.layer.borderWidth = 0.7
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.isUserInteractionEnabled = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    
    private let monthLabel: UITextField = {
        let label = UITextField()
        label.text = "Dönem"
        label.layer.borderWidth = 0.7
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.textColor = .white
        label.isUserInteractionEnabled = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    
    private let currencyPickerView = UIPickerView()
    private let monthPickerView = UIPickerView()
    
    private let inComeTypeLabel: UITextField = {
        let label = UITextField()
        label.text = "Gelir Tipi"
        label.layer.borderWidth = 0.7
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.isUserInteractionEnabled = true
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    
    private let imageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "spiral"))
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.alpha = 0.6
        return image
    }()
    
    private let currencies = ["USD", "EUR", "TRY", "GBP", "JPY"]
    private let month = ["Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran", "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık"]
    
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
        addSubview(currencyTypeLabel)
        addSubview(monthLabel)
        addSubview(saveButton)
        addSubview(imageView)
        
        currencyPickerView.delegate = self
        currencyPickerView.dataSource = self
        currencyTypeLabel.inputView = currencyPickerView
        currencyPickerView.setPickerView()
        
        monthPickerView.delegate = self
        monthPickerView.dataSource = self
        monthLabel.inputView = monthPickerView
        monthPickerView.setPickerView()
        
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
        
        currencyTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(sideIncomeTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        monthLabel.snp.makeConstraints { make in
            make.top.equalTo(currencyTypeLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        insertSubview(imageView, at: 0)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
 
    func saveButtonTapped() {
        saveDelegate?.didTapSaveButton(
            incomeText: incomeTextField.text,
            sideIncomeText: sideIncomeTextField.text,
            inComeType: inComeTypeLabel.text,
            currency: currencyTypeLabel.text,
            month: monthLabel.text
        )
    }
}

//MARK: - Extensions

extension InComeEntryPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == currencyPickerView {
            return currencies.count
        } else if pickerView == monthPickerView {
            return month.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == currencyPickerView {
            return currencies[row]
        } else if pickerView == monthPickerView {
            return month[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == currencyPickerView {
            let selectedCurrency = currencies[row]
            currencyTypeLabel.text = selectedCurrency
        } else if pickerView == monthPickerView {
            let selectedMonth = month[row]
            monthLabel.text = selectedMonth
        }
    }
    
    //PickerView Colors
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        if pickerView == currencyPickerView {
            let attributedText = NSAttributedString(string: currencies[row], attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0)
            ])
            
            label.attributedText = attributedText
            label.textAlignment = .center
            
            return label
        } else {
            let attributedText = NSAttributedString(string: month[row], attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0)
            ])
            
            label.attributedText = attributedText
            label.textAlignment = .center
            
            return label
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
        
        UIView.animate(withDuration: 2.0, delay: 0.2, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
}

extension UIPickerView {
    func setPickerView() {
        self.backgroundColor = .clear
        self.tintColor = .black
    }
}
