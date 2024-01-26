//
//  InvestmentListViewModel.swift
//  Compass
//
//  Created by Onur Emren on 26.01.2024.
//

import Foundation
import CoreData
import UIKit

protocol InvestmentListViewModelDelegate: AnyObject {
    func dataDidUpdate(records: [InvestmentEntry])
}

class InvestmentListViewModel {
    weak var delegate: InvestmentListViewModelDelegate?
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var profileView = InvestmentListView()
    private var attendanceRecords: [InvestmentEntry] = []
    
    
    func loadAttendanceRecords() {
        
        let fetchRequest: NSFetchRequest<InvestmentEntry> = InvestmentEntry.fetchRequest()
        do {
            let records = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
            delegate?.dataDidUpdate(records: records)
        } catch {
            print("Error fetching attendance records: \(error.localizedDescription)")
        }
    }
}
