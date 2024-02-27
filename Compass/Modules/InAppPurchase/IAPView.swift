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
   
    private var tableView = UITableView()
    private var ipData = [IpModel]()
    private let cellIdentifier = "IPCell"
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        ipData.append(IpModel(title: "Bronz", handler: {
            
        }))
        
        ipData.append(IpModel(title: "Silver", handler: {
            
        }))
        
        ipData.append(IpModel(title: "Gold", handler: {
            
        }))
        
        ipData.append(IpModel(title: "Diamond", handler: {
            
        }))
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "IPCell")
        tableView.backgroundColor = .red
        
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ipData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let ipData = ipData[indexPath.row]

        cell.textLabel?.text = ipData.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let ipData = ipData[indexPath.row]
        ipData.handler()
    }
}
