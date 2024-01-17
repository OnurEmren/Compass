//
//  ViewController.swift
//  Compass
//
//  Created by Onur Emren on 17.01.2024.
//

import UIKit

class HomeViewController: UIViewController, Coordinating, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var coordinator: Coordinator?
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(FinanceCardCell.self, forCellWithReuseIdentifier: FinanceCardCell.reuseIdentifier)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    let data = [("Gelir", UIColor.systemGreen), ("Gider", UIColor.red), ("Yatırım", UIColor.blue)]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        view.backgroundColor = Colors.beigeColor
    }
    
    //MARK: - Private Methods
    
    //Setupview
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.backgroundColor = Colors.beigeColor
        collectionView.dataSource = self
        collectionView.delegate = self
    }
        
    //MARK: - CollectionView Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FinanceCardCell.reuseIdentifier, for: indexPath) as! FinanceCardCell
        let (title, color) = data[indexPath.item]
        cell.configure(with: title, backgroundColor: color)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 40
        let height: CGFloat = 200
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = indexPath.row
        coordinator?.eventOccured(with: .goToDetailVC(for: selectedItem))
    }
}

