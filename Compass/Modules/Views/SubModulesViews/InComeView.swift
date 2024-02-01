//
//  InComeView.swift
//  Compass
//
//  Created by Onur Emren on 29.01.2024.
//

import Foundation
import UIKit
import DGCharts

class InComeView: UIView {
    let incomeDistributionChart: PieChartView = {
        let chartView = PieChartView()
        chartView.layer.cornerRadius = 20
        chartView.layer.masksToBounds = true
        chartView.entryLabelFont = Fonts.generalFont
        return chartView
    }()
    
    let totalIncomeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "0.0"
        label.font = Fonts.generalFont
        return label
    }()
    
    let incomeSourcesLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = Fonts.generalFont
        label.text = "Gelir Kaynakları:"
        return label
    }()
    
    let incomeMonthsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = Fonts.generalFont
        label.text = "Ay:"
        return label
    }()
    
    let incomeSourcesTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.layer.cornerRadius = 10
        textView.layer.masksToBounds = true
        let text = """
            - Maaş: 0,000
        """
        
        let attributedText = NSMutableAttributedString(string: text)
        
        if let font = UIFont(name: "Tahoma", size: 16) {
            let attributes: [NSAttributedString.Key: Any] = [.font: font]
            attributedText.addAttributes(attributes, range: NSRange(location: 0, length: text.count))
        } else {
            print("Belirtilen font bulunamadı.")
        }
        textView.attributedText = attributedText
        
        return textView
    }()
    
    let incomeDistributionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = Fonts.generalFont
        label.text = "Gelir Dağılımı:"
        return label
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Gelir Ekle", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Colors.tryColor
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.titleLabel?.font = Fonts.generalFont
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sil", for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 8
        button.titleLabel?.font = Fonts.generalFont
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(totalIncomeLabel)
        addSubview(incomeDistributionChart)
        addSubview(incomeSourcesLabel)
        addSubview(incomeSourcesTextView)
        addSubview(incomeMonthsLabel)
        addSubview(addButton)
        addSubview(deleteButton)
        
        let originalBlack = UIColor.black
        let slightlyBrighterBlack = originalBlack.withAlphaComponent(0.95)
        backgroundColor = slightlyBrighterBlack
        
        incomeMonthsLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).offset(40)
        }
        incomeMonthsLabel.textColor = .white
        
        totalIncomeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(incomeMonthsLabel).offset(20)
        }
        totalIncomeLabel.textColor = .white
        
        incomeDistributionChart.snp.makeConstraints { make in
            make.top.equalTo(totalIncomeLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(300)
        }
        incomeDistributionChart.backgroundColor = Colors.tryColor
        
        let legend = incomeDistributionChart.legend
        legend.verticalAlignment = .bottom
        legend.horizontalAlignment = .center
        legend.orientation = .horizontal
        legend.formSize = 10
        legend.font = UIFont(name: "Tahoma", size: 12) ?? .systemFont(ofSize: 15)
                
        addButton.snp.makeConstraints { make in
            make.top.equalTo(incomeDistributionChart    .snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.lessThanOrEqualTo(safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(40)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(addButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
    }
}
