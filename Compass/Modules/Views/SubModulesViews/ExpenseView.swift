//
//  ExpenseView.swift
//  Compass
//
//  Created by Onur Emren on 28.01.2024.
//

import Foundation
import UIKit
import DGCharts

class ExpenseView: UIView {
    let expenseChart: PieChartView = {
        let chartView = PieChartView()
        chartView.layer.cornerRadius = 20
        chartView.layer.masksToBounds = true
        return chartView
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Detaylı Gider Ekle", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Colors.buttonColor
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.titleLabel?.font = Fonts.generalFont
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sil", for: .normal)
        button.backgroundColor = .red
        button.titleLabel?.font = Fonts.generalFont
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let segmented: UISegmentedControl = {
        let items = ["Detaylı", "Genel"]
        let segmented = UISegmentedControl(items: items)
        segmented.selectedSegmentIndex = 0 // Varsayılan olarak ilk segmenti seç
        segmented.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        return segmented
    }()
    
    let totalExpenseLabel = UIExtensions.createLabel(
        text: "Giderlerim: 0.0",
        fontSize: Fonts.generalFont!.pointSize,
        alignment: .center)
    let expenseDistributionLabel = UIExtensions.createLabel(
        text: "Gider Dağılımı:",
        fontSize: 18,
        alignment: .left)
    let monthLabel = UIExtensions.createLabel(
        text: "Ay:",
        fontSize: 18,
        alignment: .left)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            //
            break
        case 1:
            // "Gider" seçildiğinde yapılacak işlemler
            break
        case 2:
            // "Yatırım" seçildiğinde yapılacak işlemler
            break
        case 3:
            // "Genel" seçildiğinde yapılacak işlemler
            break
        default:
            break
        }
    }
    
    private func setupView() {
        addSubview(totalExpenseLabel)
        addSubview(monthLabel)
        addSubview(segmented)
        addSubview(expenseChart)
        addSubview(addButton)
        addSubview(deleteButton)
        
        monthLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
        }
        monthLabel.textColor = Colors.lightThemeColor
        
        totalExpenseLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(monthLabel).offset(30)
        }
        totalExpenseLabel.textColor = Colors.lightThemeColor
        
        segmented.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(totalExpenseLabel.snp.top).offset(40)
        }
        
        segmented.layer.borderWidth = 0.7
        segmented.layer.borderColor = UIColor.white.cgColor
        segmented.backgroundColor = .gray
        segmented.tintColor = .black
        
        expenseChart.snp.makeConstraints { make in
            make.top.equalTo(segmented.snp.top).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(300)
        }
        expenseChart.backgroundColor = .white
        
        let legend = expenseChart.legend
        legend.verticalAlignment = .bottom
        legend.horizontalAlignment = .center
        legend.orientation = .horizontal
        legend.formSize = 10
        legend.font = UIFont(name: "Tahoma", size: 12) ?? .systemFont(ofSize: 12)
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(expenseChart.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.lessThanOrEqualTo(safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(40)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(addButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
    }
}
