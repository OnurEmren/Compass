//
//  GeneralExpenseView.swift
//  Compass
//
//  Created by Onur Emren on 28.01.2024.
//

import Foundation
import UIKit

class GeneralExpenseView: UIView {
    private var rentExpensePickerView = UIPickerView()
    private var creditCardExpensePickerView = UIPickerView()
    private var rentExpenseLabel = UITextField()
    private var creditCardExpenseLabel = UITextField()
    private var saveButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(rentExpenseLabel)
        addSubview(creditCardExpenseLabel)
        addSubview(saveButton)
        
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
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(creditCardExpenseLabel.snp.top).offset(60)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
        //RentExpenseLabel Settings
        rentExpenseLabel.attributedPlaceholder = NSAttributedString(
            string: "Yatırım yaptığınız tarihi giriniz",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        rentExpenseLabel.inputView = rentExpensePickerView
        rentExpenseLabel.layer.cornerRadius = 10
        rentExpenseLabel.layer.borderWidth = 0.7
        rentExpenseLabel.layer.masksToBounds = true
        rentExpenseLabel.placeholder = "Kira Gideri"
        rentExpenseLabel.textColor = .white
        rentExpenseLabel.font = Fonts.generalFont
        rentExpenseLabel.textAlignment = .center
        rentExpenseLabel.layer.borderColor = UIColor.white.cgColor
        
        //CreditCartLabel Settings
        creditCardExpenseLabel.attributedPlaceholder = NSAttributedString(
            string: "Yatırım yaptığınız tarihi giriniz",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        creditCardExpenseLabel.inputView = creditCardExpensePickerView
        creditCardExpenseLabel.layer.cornerRadius = 10
        creditCardExpenseLabel.layer.borderWidth = 0.7
        creditCardExpenseLabel.layer.masksToBounds = true
        creditCardExpenseLabel.textColor = .white
        creditCardExpenseLabel.textAlignment = .center
        creditCardExpenseLabel.font = Fonts.generalFont
        creditCardExpenseLabel.placeholder = "Kredi Kartı Gideri"
        creditCardExpenseLabel.layer.borderColor = UIColor.white.cgColor
        
        //Button Settings
        saveButton.setTitle("Kaydet", for: .normal)
        saveButton.backgroundColor = Colors.buttonColor
        saveButton.titleLabel?.font = Fonts.generalFont
        saveButton.tintColor = .white
        saveButton.layer.cornerRadius = 10
        saveButton.layer.borderWidth = 0.7
        saveButton.layer.borderColor = UIColor.white.cgColor
        saveButton.layer.masksToBounds = true
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func saveButtonTapped() {
        //
    }
}
