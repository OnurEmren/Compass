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
    let data = [("Gelir", .black), ("Gider", UIColor.black), ("Yatırım", UIColor.black), ("Genel", UIColor.black) ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ana Sayfa"
        setupCollectionView()
        view.backgroundColor = .systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layoutIfNeeded()
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Colors.tryColor]

        collectionView.reloadData()
        
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
    }
    
    //MARK: - Private Methods
    
    //Setupview
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(700)
        }
        
        let originalBlack = UIColor.black
        let slightlyBrighterBlack = originalBlack.withAlphaComponent(0.95)
        collectionView.backgroundColor = slightlyBrighterBlack
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
        let generalExpenseData = homeViewModel.fetchGeneralExpenseData()
        let investmentData = homeViewModel.fetchInvestmentData()
        
        
        let totalIncome = inComeData.reduce(0) { (result, entry) in
            return result + entry.wage + entry.sideInCome
        }
        
        let totalDetailExpense = expenseData.reduce(0) { (result, entry) in
            let total = entry.clothesExpense + entry.electronicExpense + entry.foodExpense + entry.fuelExpense + entry.rentExpense + entry.taxExpense + entry.transportExpense
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
        collectionView.roundCorners([.topLeft,.topRight], radius: 20)
        cell.backgroundColor = .clear

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
          return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
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
}

extension UICollectionView {
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

