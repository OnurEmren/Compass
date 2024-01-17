//
//  HomeView.swift
//  Compass
//
//  Created by Onur Emren on 17.01.2024.
//

import Foundation
import UIKit
import SnapKit

class HomeView: UIView, Coordinating {
    var coordinator: Coordinator?
    
    
    private let button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        addSubview(button)
        
        button.setTitle("Go", for: .normal)
        button.tintColor = Colors.darkThemeColor
        button.addTarget(self, action: #selector(goToDetailPage), for: .touchUpInside)
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc
    private func goToDetailPage() {
        //coordinator?.eventOccured(with: .goToDetailVC)
    }
    
}
