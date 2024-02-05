//
//  ReceivablesListViewModel.swift
//  Compass
//
//  Created by Onur Emren on 5.02.2024.
//

import Foundation
import CoreData
import UIKit

protocol ReceivablesListViewModelDelegate: AnyObject {
    func dataDidUpdate(records: [ReceivablesEntry])
}

class ReceivablesListViewModel {
    weak var delegate: ReceivablesListViewModelDelegate?
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var profileView = ReceivablesListView()
    private var attendanceRecords: [ReceivablesEntry] = []
    
    
    func loadAttendanceRecords() {
        
        let fetchRequest: NSFetchRequest<ReceivablesEntry> = ReceivablesEntry.fetchRequest()
        do {
            let records = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
            delegate?.dataDidUpdate(records: records)
        } catch {
            print("Error fetching attendance records: \(error.localizedDescription)")
        }
    }
}
