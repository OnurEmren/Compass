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
    private let investmentOptions = ["Dolar", "Euro", "Altın", "Hisse Senedi"]
    private lazy var datePicker = UIDatePicker()
    private var purchasePriceTextField = UITextField()
    private var investmentTypeTextField = UITextField()
    private var investmentDateTextField = UITextField()
    private var pieceTextField = UITextField()
    private var titleLabel = UILabel()
    private var saveButton = UIButton()
    private let imageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "spiral"))
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
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
        addSubview(investmentDateTextField)
        addSubview(purchasePriceTextField)
        addSubview(pieceTextField)
        addSubview(saveButton)
        
        insertSubview(imageView, at: 0)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        //Constraints
        investmentTypeTextField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(50)
            make.height.equalTo(40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        investmentDateTextField.snp.makeConstraints { make in
            make.top.equalTo(investmentTypeTextField.snp.top).offset(60)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
        purchasePriceTextField.snp.makeConstraints { make in
            make.top.equalTo(investmentDateTextField.snp.top).offset(60)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
        pieceTextField.snp.makeConstraints { make in
            make.top.equalTo(purchasePriceTextField.snp.top).offset(60)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(pieceTextField.snp.top).offset(60)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
                
        //InvestmentDateTextField Settings
        investmentDateTextField.attributedPlaceholder = NSAttributedString(
            string: "Yatırım yaptığınız tarihi giriniz",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        investmentDateTextField.inputView = datePicker
        investmentDateTextField.layer.borderWidth = 0.7
        investmentDateTextField.layer.borderColor = UIColor.white.cgColor
        investmentDateTextField.layer.cornerRadius = 10
        investmentDateTextField.layer.masksToBounds = true
        investmentDateTextField.textColor = .white
        investmentDateTextField.textAlignment = .center
        investmentDateTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
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
        investmentTypeTextField.font = Fonts.generalFont
        investmentTypeTextField.textAlignment = .center
        
        //purchasePriceTextField Settings
        purchasePriceTextField.delegate = self
        purchasePriceTextField.keyboardType = .decimalPad
        purchasePriceTextField.layer.borderWidth = 0.7
        purchasePriceTextField.layer.borderColor = UIColor.white.cgColor
        purchasePriceTextField.layer.cornerRadius = 10
        purchasePriceTextField.layer.masksToBounds = true
        purchasePriceTextField.textColor = .white
        purchasePriceTextField.font = Fonts.generalFont
        purchasePriceTextField.textAlignment = .center
        purchasePriceTextField.attributedPlaceholder = NSAttributedString(
            string: "Aldığınız ürünün birim fiyatını giriniz",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        
        //pieceTextField Settings
        pieceTextField.delegate = self
        pieceTextField.keyboardType = .numberPad
        pieceTextField.layer.borderWidth = 0.7
        pieceTextField.layer.borderColor = UIColor.white.cgColor
        pieceTextField.layer.cornerRadius = 10
        pieceTextField.layer.masksToBounds = true
        pieceTextField.textColor = .white
        pieceTextField.textAlignment = .center
        pieceTextField.font = Fonts.generalFont
        pieceTextField.attributedPlaceholder = NSAttributedString(
            string: "Ürünün adetini giriniz",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
    }
    
    //MARK: - Save
    
    @objc
    func saveButtonTapped() {
        guard let investmentType = investmentTypeTextField.text,
              
              let date = investmentDateTextField.text,
              let piece = pieceTextField.text,
              let purchase = purchasePriceTextField.text
        else {
            return
        }
        
        guard let purchase = Double(purchase.replacingOccurrences(of: ",", with: ".")),
              let piece = Double(piece)
        else {
            print("Geçersiz miktar formatı")
            showToastInvestment(message: "Tüm alanları uygun şekilde doldurunuz.")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        guard let selectedDate = dateFormatter.date(from: date) else {
            print("Geçersiz tarih formatı")
            showToastInvestment(message: "Geçersiz tarih formatı.")
            return
        }
        
        let calculatedAmount = purchase * piece
        
        viewModel.saveInvestments(invesmentType: investmentType, amount: calculatedAmount, selectedDate: selectedDate, purchase: purchase, piece: piece)
        
        showToastInvestment(message: "Kayıt Başarılı")
    }
    
    
    @objc
    public func datePickerValueChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        investmentDateTextField.text = dateFormatter.string(from: datePicker.date)
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
