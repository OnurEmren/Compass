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

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "SanFranciscoText-ThinItalic", size: 20)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }

    func configure(with title: String, backgroundColor: UIColor, overallStatus: Double) {
        titleLabel.text = title
        self.backgroundColor = backgroundColor
        layer.cornerRadius = 12
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        updateLabel(with: overallStatus)
    }

    private func updateLabel(with overallStatus: Double) {
        titleLabel.text = "Genel durum: \(overallStatus)"
    }



}
