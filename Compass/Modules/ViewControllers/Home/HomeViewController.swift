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
        collectionView.backgroundColor = .white
        return collectionView
    }()
    private var financeCardCell = FinanceCardCell()
    
    let data = [("Gelir", UIColor.systemGreen), ("Gider", UIColor.red), ("Yatırım", UIColor.blue), ("Genel", UIColor.lightGray) ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        view.backgroundColor = Colors.beigeColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layoutIfNeeded()
        collectionView.reloadData()
    }
    
    //MARK: - Private Methods
    
    //Setupview
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.backgroundColor = Colors.piesGreenColor
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = false
        collectionView.reloadData()
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
        let investmentData = homeViewModel.fetchInvestmentData()
        
        
        let totalIncome = inComeData.reduce(0) { (result, entry) in
            return result + entry.wage + entry.sideInCome
        }
        
        let totalExpense = expenseData.reduce(0) { (result, entry) in
            let total = entry.clothesExpense + entry.electronicExpense + entry.foodExpense + entry.fuelExpense + entry.rentExpense + entry.taxExpense + entry.transportExpense
            return result + total
        }
        
        let totalInvestment = investmentData.reduce(0) { (result, entry) in
            return result + entry.investmentAmount
        }
        
        let overallStatus = (totalIncome - totalExpense) + totalInvestment
        
        switch title {
        case "Gelir":
            cell.configureInComeLabel(with: title, backgroundColor: color, overallStatus: totalIncome)
            
        case "Gider":
            cell.configureExpenseLabel(with: title, backgroundColor: color, overallStatus: totalExpense)
            
        case "Yatırım":
            cell.configureInvestmentLabel(with: title, backgroundColor: color, overallStatus: totalInvestment)
            
        case "Genel":
            let overallStatus = overallStatus
            cell.configure(with: title, backgroundColor: color, overallStatus: overallStatus)
            
        default:
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 40
        let height: CGFloat = 150
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = indexPath.row
        coordinator?.eventOccured(with: .goToDetailVC(for: selectedItem))
    }
    
    func updateRecord() {
        collectionView.reloadData()
    }
}
