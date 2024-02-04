//
//  ReceivablesView.swift
//  Compass
//
//  Created by Onur Emren on 4.02.2024.
//

import Foundation
import UIKit
import CoreData

class ReceivablesView: UIView, UITextFieldDelegate {
    
    private var receivablesAmountTextfield: UITextField = {
        let textfield = UITextField()
        textfield.text = "Alacaklı olduğunuz miktarı giriniz."
        textfield.textColor = .black
        textfield.backgroundColor = .white
        return textfield
    }()
    
    private var dateTextfield: UITextField = {
        let textField = UITextField()
        textField.text = "Ödemeyi alacağınız tarih"
        textField.textColor = .black
        textField.backgroundColor = .white
        return textField
    }()
    
    private var person: UITextField = {
        let textField = UITextField()
        textField.text = "Ödeme Alacağınız Kişi"
        textField.backgroundColor = .black
        textField.textColor = .white
        textField.textAlignment = .center
        return textField
    }()
    
    private var datePickerView = UIPickerView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupView() {
        addSubview(receivablesAmountTextfield)
        addSubview(dateTextfield)
        
        receivablesAmountTextfield.delegate = self
        dateTextfield.delegate = self
        
        dateTextfield.inputView = datePickerView
        
        receivablesAmountTextfield.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(60)
            make.trailing.leading.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        
    }
    
}
