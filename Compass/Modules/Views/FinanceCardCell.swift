//
//  FinanceCardCell.swift
//  Compass
//
//  Created by Onur Emren on 17.01.2024.
//

//
//  FinanceCardCell.swift
//  Compass
//
//  Created by Onur Emren on 17.01.2024.
//

import UIKit
import Charts
import SnapKit
import DGCharts

class FinanceCardCell: UICollectionViewCell {
    static let reuseIdentifier = "FinanceCardCell"
    
    let overallStatusLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: 20)
        return label
    }()
    
    let incomeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: 20)
        return label
    }()
    
    let expenseLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: 20)
        return label
    }()
    
    let investmentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: 20)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Clear labels
    override func prepareForReuse() {
        super.prepareForReuse()
        overallStatusLabel.text = nil
        incomeLabel.text = nil
        expenseLabel.text = nil
        investmentLabel.text = nil
    }

    private func setupViews() {
        addSubview(overallStatusLabel)
        addSubview(incomeLabel)
        addSubview(expenseLabel)
        addSubview(investmentLabel)
        
        
        overallStatusLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        incomeLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)

            make.center.equalToSuperview()
        }
        
        investmentLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        expenseLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    
    
    func configure(with title: String, backgroundColor: UIColor, overallStatus: Double) {
        overallStatusLabel.text = title
        overallStatusLabel.textColor = .black
        self.backgroundColor = backgroundColor
        layer.cornerRadius = 12
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        updateLabel(with: overallStatus)
    }
    
    func configureInComeLabel(with title: String, backgroundColor: UIColor, overallStatus: Double) {
        incomeLabel.text = title
        incomeLabel.font = Fonts.generalFont
        self.backgroundColor = backgroundColor
        layer.cornerRadius = 12
        layer.masksToBounds = false
        layer.borderWidth = 0.7
        layer.borderColor = UIColor.systemBackground.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        updateInComeLabel(with: overallStatus)
    }
    
    func configureExpenseLabel(with title: String, backgroundColor: UIColor, overallStatus: Double) {
        expenseLabel.text = title
        expenseLabel.font = Fonts.generalFont
        self.backgroundColor = backgroundColor
        layer.cornerRadius = 12
        layer.masksToBounds = false
        layer.borderWidth = 0.7
        layer.borderColor = UIColor.systemBackground.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        updateExpenseLabel(with: overallStatus)
    }
    
    func configureInvestmentLabel(with title: String, backgroundColor: UIColor, overallStatus: Double) {
        investmentLabel.text = title
        investmentLabel.font = Fonts.generalFont
        self.backgroundColor = backgroundColor
        layer.cornerRadius = 12
        layer.masksToBounds = false
        layer.borderWidth = 0.7
        layer.borderColor = UIColor.systemBackground.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        updateInvestmentLabel(with: overallStatus)
    }
    
    private func updateLabel(with overallStatus: Double) {
        if overallStatus < 0 {
            overallStatusLabel.textColor = .red
        } else if overallStatus == 0 {
            overallStatusLabel.textColor = .gray
        } else {
            overallStatusLabel.textColor = .green
        }
        
        overallStatusLabel.text = "Genel durum: \(overallStatus)"
    }
    
    private func updateInComeLabel(with overallStatus: Double) {
        incomeLabel.text = "Gelir: \(overallStatus)"
    }
    
    private func updateExpenseLabel(with overallStatus: Double) {
        expenseLabel.text = "Giderler: \(overallStatus)"
    }
    
    private func updateInvestmentLabel(with overallStatus: Double) {
        investmentLabel.text = "Yatırımlar: \(overallStatus)"
    }
}
