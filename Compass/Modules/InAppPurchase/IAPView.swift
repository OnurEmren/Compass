//
//  IAPView.swift
//  Compass
//
//  Created by Onur Emren on 27.02.2024.
//

import Foundation
import UIKit
import SnapKit

struct IpModel {
    var title: String
    var handler: (() -> Void)
}

class IAPView: UIView, UITableViewDelegate, UITableViewDataSource {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Premium Üyelik Avantajları"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    let benefitsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    private var tableView = UITableView()
    private var ipData = [IpModel]()
    private let cellIdentifier = "IPCell"
    private var descriptionView = UIView()
    private var descriptionLabel = UILabel()
    private var descriptionLabel2 = UILabel()
    let imageView = UIImageView(image: UIImage(systemName: "suit.diamond.fill"))
    let imageView2 = UIImageView(image: UIImage(systemName: "suit.diamond.fill"))
    
    private let image: UIImageView = {
        let image = UIImageView(image: UIImage(named: "spiral"))
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.alpha = 0.6
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupDescription()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        ipData.append(IpModel(title: "Premium", handler: {
            IAPManager.shared.purchase(product: .subscribe_premium) { [weak self] count in
                DispatchQueue.main.async {
                    let currentCount = self?.mySubscribeCount ?? 0
                    UserDefaults.standard.setValue(currentCount, forKey: "subscribe_premium")
                    self?.setupHeader()
                }
            }
        }))
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "IPCell")
        tableView.backgroundColor = .clear
        tableView.frame = bounds
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(110)
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.height.equalTo(70)
        }
        
        insertSubview(image, at: 0)
        image.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupDescription() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(200)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        var lastView: UIView = titleLabel
        
        let benefits = [
            "Reklamsız kullanım",
            "Özel içeriklere erişim",
            "Hızlı ve öncelikli destek"
            // Diğer avantajlar...
        ]
        
        
        
        for benefit in benefits {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.alignment = .top
            stack.spacing = 2
            
            let bulletLabel = UILabel()
            bulletLabel.text = "•"
            bulletLabel.textColor = .white
            
            let benefitLabel = UILabel()
            benefitLabel.text = benefit
            benefitLabel.textColor = .white
            
            stack.addArrangedSubview(bulletLabel)
            stack.addArrangedSubview(benefitLabel)
            
            addSubview(stack)
            stack.snp.makeConstraints { make in
                make.top.equalTo(lastView.snp.bottom).offset(8)
                make.leading.trailing.equalToSuperview().inset(10)
            }
            
            lastView = stack
        }
        lastView.snp.makeConstraints { make in
            make.bottom.lessThanOrEqualToSuperview().inset(16)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ipData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let ipData = ipData[indexPath.row]
        
        cell.textLabel?.text = ipData.title
        cell.imageView?.image = UIImage(systemName: "suit.diamond.fill")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let ipData = ipData[indexPath.row]
        ipData.handler()
    }
    
    var mySubscribeCount: Int  {
        return UserDefaults.standard.integer(forKey: "subscribe_premium")
    }
    
    func setupHeader() {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.width))
        let imageView = UIImageView(image: UIImage(systemName: "suit.diamond.fill"))
        imageView.frame = CGRect(x: (frame.size.width - 100) / 2, y: 10, width: 100, height: 100)
        imageView.tintColor = .systemBlue
        header.addSubview(imageView)
        
        let label = UILabel(frame: CGRect(x: 10, y: 120, width: frame.size.width - 20, height: 100))
        header.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 25)
        label.textAlignment = .center
        label.text = "\(mySubscribeCount) Subscribe"
        tableView.tableHeaderView = header
    }
}
