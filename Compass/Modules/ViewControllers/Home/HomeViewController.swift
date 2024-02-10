//
//  ViewController.swift
//  Compass
//
//  Created by Onur Emren on 17.01.2024.
//

import UIKit
import CoreData
import DGCharts

class HomeViewController: UIViewController, Coordinating, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var coordinator: Coordinator?
    private var homeViewModel = HomeViewModel()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(FinanceCardCell.self, forCellWithReuseIdentifier: FinanceCardCell.reuseIdentifier)
        return collectionView
    }()
    private var financeCardCell = FinanceCardCell()
    let data = [
        ("Gelir", .black),
        ("Gider", UIColor.black),
        ("Yatırım", UIColor.black),
        ("Alacaklarım", UIColor.black),
        ("Borçlarım", UIColor.black),
        ("Genel Durum", UIColor.black)
    ]
    
    private let imageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "spiral"))
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    //MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ana Sayfa"
        setupCollectionView()
        
        view.backgroundColor = .black
        navigationSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layoutIfNeeded()
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        collectionView.reloadData()
    }
    
    //MARK: - Private Methods
    
    //Setupview
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.bottom.equalToSuperview()
            make.trailing.leading.equalToSuperview()
        }
        
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = false
        collectionView.reloadData()
        
        view.insertSubview(imageView, at: 0)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func navigationSettings() {
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
 
    //MARK: - CollectionView Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FinanceCardCell.reuseIdentifier, for: indexPath) as! FinanceCardCell
        let (title, color) = data[indexPath.item]
        
        let inComeData = homeViewModel.fetchInComeData()
        let expenseData = homeViewModel.fetchExpenseData()
        let generalExpenseData = homeViewModel.fetchGeneralExpenseData()
        let investmentData = homeViewModel.fetchInvestmentData()
        let receivablesData = homeViewModel.fetchReceivablesData()
        let deptData = homeViewModel.fetchDeptData()
        
        let totalIncome = inComeData.reduce(0) { (result, entry) in
            return result + entry.wage + entry.sideInCome
        }
        
        let totalDetailExpense = expenseData.reduce(0) { (result, entry) in
            let total = entry.clothesExpense + entry.foodExpense + entry.fuelExpense + entry.rentExpense + entry.taxExpense
            return result + total
        }
        
        
        let totalGeneralExpense = generalExpenseData.reduce(0) { (result, entry) in
            let total = entry.creditCardExpense + entry.rentExpense
            return result + total
        }
        
        let totalExpense = totalDetailExpense + totalGeneralExpense
        
        let totalInvestment = investmentData.reduce(0) { (result, entry) in
            return result + entry.investmentAmount
        }
        
        let totalReceivables = receivablesData.reduce(0) {(result, entry) in
            return result + entry.receivablesAmount
        }
        
        let deptExpense = deptData.reduce(0) {( result, entry) in
            return result + entry.deptAmount
        }
        
        let overallStatus = (totalIncome - totalExpense) + totalInvestment + totalReceivables
        
        switch title {
        case "Gelir":
            cell.configureInComeLabel(with: title, backgroundColor: color, overallStatus: totalIncome)
            
        case "Gider":
            cell.configureExpenseLabel(with: title, backgroundColor: color, overallStatus: totalExpense)
            
        case "Yatırım":
            cell.configureInvestmentLabel(with: title, backgroundColor: color, overallStatus: totalInvestment)
            
        case "Alacaklarım":
            cell.configureReceivablesLabel(with: title, backgroundColor: color, overallStatus: totalReceivables)
            
        case "Borçlarım":
            cell.configureDeptLabel(with: title, backgroundColor: color, deptStatus: deptExpense)
            
        case "Genel Durum":
            let overallStatus = overallStatus
            cell.configure(with: title, backgroundColor: color, overallStatus: overallStatus)
        default:
            break
        }
        cell.backgroundColor = .clear

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
          return UIEdgeInsets(top: 20, left: 15, bottom: 0, right: 15)
      }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = 175
        let height: CGFloat = 175
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = indexPath.row
        coordinator?.eventOccured(with: .goToDetailVC(for: selectedItem))
    }
}

extension UICollectionView {
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

