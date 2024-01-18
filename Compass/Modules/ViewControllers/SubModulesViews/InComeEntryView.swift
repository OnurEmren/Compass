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
    func didTapSaveButton(incomeText: String?, sideIncomeText: String?)
}

class IncomeEntryView: UIView {

    private let incomeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Maaşınızı girin"
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let sideIncomeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Yan Gelirinizi girin"
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Kaydet", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        return button
    }()

    weak var delegate: IncomeEntryViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        addSubview(incomeTextField)
        addSubview(sideIncomeTextField)
        addSubview(saveButton)

        incomeTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }

        sideIncomeTextField.snp.makeConstraints { make in
            make.top.equalTo(incomeTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }

        saveButton.snp.makeConstraints { make in
            make.top.equalTo(sideIncomeTextField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(40)
        }

        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }

    @objc private func saveButtonTapped() {
        
        delegate?.didTapSaveButton(incomeText: incomeTextField.text, sideIncomeText: sideIncomeTextField.text)
    }
}
