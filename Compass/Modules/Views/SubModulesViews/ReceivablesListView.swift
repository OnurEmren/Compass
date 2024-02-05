//
//  ReceivablesListView.swift
//  Compass
//
//  Created by Onur Emren on 5.02.2024.
//

import Foundation
import UIKit

class ReceivablesListView: UIView {
    private let tableView = UITableView()
    private var attendanceRecords: [ReceivablesEntry] = []
    private let cellIdentifier = "receivablesViewCell"
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private let imageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "spiral"))
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.backgroundColor = .clear
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        insertSubview(imageView, at: 0)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func updateAttendanceRecords(_ records: [ReceivablesEntry]) {
        attendanceRecords = records
        tableView.reloadData()
    }
}

extension ReceivablesListView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        attendanceRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let record = attendanceRecords[indexPath.row]
        
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        setLabelTag(cell: cell, record: record, indexPath: indexPath)

        cell.layer.cornerRadius = 20
        cell.layer.masksToBounds = false
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 150
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { [weak self] (_, _, completionHandler) in
            self?.deleteActionTapped(at: indexPath)
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = .red
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func deleteActionTapped(at indexPath: IndexPath) {
        let recordToDelete = attendanceRecords[indexPath.row]
        let context = appDelegate.persistentContainer.viewContext
        context.delete(recordToDelete)
        
        do {
            try context.save()
            showToastInvestment(message: "Veriler silindi.")
            attendanceRecords.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        } catch {
            print("Veri silinirken hata oluştu: \(error.localizedDescription)")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func createAndConfigureLabel(tag: Int, text: String, cell: UITableViewCell, topView: UIView? = nil) -> UILabel {
        let label = UILabel()
        label.textColor = .black
        label.font = Fonts.generalFont
        cell.contentView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            if let topView = topView {
                make.top.equalTo(topView.snp.bottom).offset(5)
            } else {
                make.top.equalToSuperview().offset(10)
            }
        }
        
        label.text = text
        return label
    }
    
    private func setLabelTag(cell: UITableViewCell, record: ReceivablesEntry, indexPath: IndexPath) {
        //Set DateFormatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        //Set Label Tag
        let labelConfigs: [(tag: Int, text: String)] = [
            (1, "Ödeme Alacağım Kişi: \(record.person ?? "")"),
            (2, "Miktar: \(record.receivablesAmount)"),
            (3, "Tarih: \(record.date!)")
            
        ]
        
        var previousLabel: UIView?
        
        for config in labelConfigs {
            previousLabel = createAndConfigureLabel(tag: config.tag, text: config.text, cell: cell, topView: previousLabel)
        }
        
        //Set Color
        let colorIndex = indexPath.row % Colors.colors.count
        cell.backgroundColor = Colors.colors[colorIndex]
    }
}
