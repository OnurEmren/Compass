//
//  DeptView.swift
//  Compass
//
//  Created by Onur Emren on 10.02.2024.
//

import Foundation
import UIKit
import CoreData


protocol DeptViewSaveProtocol: AnyObject {
    func didTapSaveDeptData(deptAmountTextField: String?,
                          dateTextField: String?,
                          personTextField: String?
    )
}

class DeptView: UIView {
    
    private var viewModel: DeptViewModel
    private var deptAmountTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Borç miktarı",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 0.7
        textField.layer.masksToBounds = true
        textField.textColor = .white
        textField.font = UIFont.preferredFont(forTextStyle: .headline)
        textField.textAlignment = .center
        textField.layer.borderColor = UIColor.white.cgColor
        return textField
    }()
    
    private var dateTextfield: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Ödeme alacağım tarih",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 0.7
        textField.layer.masksToBounds = true
        textField.textColor = .white
        textField.font = UIFont.preferredFont(forTextStyle: .headline)
        textField.textAlignment = .center
        textField.layer.borderColor = UIColor.white.cgColor
        return textField
    }()
    
    private let personTextfield: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: "Borçlu kişi ya da kurum",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 0.7
        textField.layer.masksToBounds = true
        textField.textColor = .white
        textField.font = UIFont.preferredFont(forTextStyle: .headline)
        textField.textAlignment = .center
        textField.layer.borderColor = UIColor.white.cgColor
        return textField
    }()
    
    private var imageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "spiral"))
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.alpha = 0.6
        return image
    }()
    
    private var datePickerView = UIDatePicker()
    weak var saveDelegate: ReceivablesViewDelegate?
    
    init(viewModel: DeptViewModel) {
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
    
    //MARK: - Handle Methods
    
    @objc
    private func handleTap() {
        self.endEditing(true)
    }
    
    //MARK: - Setup View
    
    private func setupView() {
        insertSubview(imageView, at: 0)
        addSubview(personTextfield)
        addSubview(deptAmountTextField)
        addSubview(dateTextfield)
        
        dateTextfield.inputView = datePickerView
        datePickerView.setDate(datePickerView)
        
        personTextfield.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(60)
            make.trailing.leading.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        deptAmountTextField.snp.makeConstraints { make in
            make.top.equalTo(personTextfield.snp.top).offset(60)
            make.trailing.leading.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        dateTextfield.snp.makeConstraints { make in
            make.top.equalTo(deptAmountTextField.snp.top).offset(60)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)

    }
    
    @objc
    public func datePickerValueChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateTextfield.text = dateFormatter.string(from: datePickerView.date)
    }
    
    @objc
    func saveButtonTapped() {
        guard let person = personTextfield.text,
              let date = dateTextfield.text,
              let deptAmound = deptAmountTextField.text
        else {
            return
        }
                
        viewModel.saveDept(
            deptAmountText: deptAmound,
            dateTextField: date,
            personTextField: person)
        showToastInvestment(message: "Kayıt Başarılı")
    }
}
