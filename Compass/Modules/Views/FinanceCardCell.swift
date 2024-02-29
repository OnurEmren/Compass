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
        label.textColor = Colors.tryColor
        return label
    }()
    
    let incomeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Colors.tryColor
        return label
    }()
    
    let expenseLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Colors.tryColor
        return label
    }()
    
    let investmentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    let receivablesLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    let deptLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    let accountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private let imageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "abstract2"))
        image.contentMode = .center
        image.clipsToBounds = true
        return image
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
        receivablesLabel.text = nil
        deptLabel.text = nil
    }

    private func setupViews() {
        addSubview(overallStatusLabel)
        addSubview(incomeLabel)
        addSubview(expenseLabel)
        addSubview(investmentLabel)
        addSubview(receivablesLabel)
        addSubview(deptLabel)
        addSubview(accountLabel)
        
        incomeLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(5)
            make.center.equalToSuperview()
        }
        
        overallStatusLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        investmentLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        expenseLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        receivablesLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        deptLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        accountLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func configure(with title: String, backgroundColor: UIColor, overallStatus: Double) {
        overallStatusLabel.text = title
        overallStatusLabel.textColor = .white
        overallStatusLabel.font = UIFont.preferredFont(forTextStyle: .body)
        self.backgroundColor = backgroundColor
        layer.cornerRadius = 12
        layer.masksToBounds = false
        layer.borderColor = UIColor.white.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        updateLabel(with: overallStatus)
    }
    
    func configureInComeLabel(with title: String, backgroundColor: UIColor, overallStatus: Double) {
        incomeLabel.text = title
        incomeLabel.font = UIFont.preferredFont(forTextStyle: .body)
        incomeLabel.textColor = .white
        self.backgroundColor = backgroundColor
        layer.cornerRadius = 12
        layer.masksToBounds = false
        layer.borderWidth = 0.7
        layer.borderColor = UIColor.white.cgColor
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        updateInComeLabel(with: overallStatus)
    }
    
    func configureExpenseLabel(with title: String, backgroundColor: UIColor, overallStatus: Double) {
        expenseLabel.text = title
        expenseLabel.font = UIFont.preferredFont(forTextStyle: .body)
        expenseLabel.textColor = .white
        self.backgroundColor = backgroundColor
        layer.cornerRadius = 12
        layer.masksToBounds = false
        layer.borderWidth = 0.7
        layer.borderColor = UIColor.white.cgColor
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        updateExpenseLabel(with: overallStatus)
    }
    
    func configureInvestmentLabel(with title: String, backgroundColor: UIColor, overallStatus: Double) {
        investmentLabel.text = title
        investmentLabel.font = UIFont.preferredFont(forTextStyle: .body)
        investmentLabel.textColor = .white
        self.backgroundColor = backgroundColor
        layer.cornerRadius = 12
        layer.masksToBounds = false
        layer.borderWidth = 0.7
        layer.borderColor = UIColor.white.cgColor
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        updateInvestmentLabel(with: overallStatus)
    }
    
    func configureReceivablesLabel(with title: String, backgroundColor: UIColor, overallStatus: Double) {
        receivablesLabel.text = title
        receivablesLabel.font = UIFont.preferredFont(forTextStyle: .body)
        receivablesLabel.textColor = .white
        self.backgroundColor = backgroundColor
        layer.cornerRadius = 12
        layer.masksToBounds = false
        layer.borderWidth = 0.7
        layer.borderColor = UIColor.white.cgColor
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        updateReceivablesLabel(with: overallStatus)
    }
    
    func configureDeptLabel(with title: String, backgroundColor: UIColor, deptStatus: Double) {
        deptLabel.text = title
        deptLabel.font = UIFont.preferredFont(forTextStyle: .body)
        deptLabel.textColor = .white
        self.backgroundColor = backgroundColor
        layer.cornerRadius = 12
        layer.masksToBounds = false
        layer.borderWidth = 0.7
        layer.borderColor = UIColor.white.cgColor
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        updateDeptLabel(with: deptStatus)
    }
    
    func configureAccountLabel(with title: String, backgroundColor: UIColor) {
        accountLabel.text = "Hesap İşlemleri"
        accountLabel.textColor = .white
        accountLabel.font = UIFont.preferredFont(forTextStyle: .body)
        self.backgroundColor = backgroundColor
        layer.cornerRadius = 12
        layer.masksToBounds = false
        layer.borderColor = UIColor.white.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        updateAccountLabel()
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
    
    private func updateReceivablesLabel(with overallStatus: Double) {
        receivablesLabel.text = "Alacaklarım: \(overallStatus)"
    }
    
    private func updateDeptLabel(with overallStatus: Double) {
        deptLabel.text = "Borçlarım: \(overallStatus)"
    }
    
    private func updateAccountLabel() {
        accountLabel.text = "Hesap İşlemleri"
    }
}
