//
//  DeptListViewModel.swift
//  Compass
//
//  Created by Onur Emren on 10.02.2024.
//

import Foundation
import CoreData
import UIKit

protocol DeptListViewModelProtocol: AnyObject {
    func dataDidUpdate(records: [DeptEntry])
}

class DeptListViewModel {
    weak var delegate: DeptListViewModelProtocol?
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var profileView = DeptListView()
    
    func loadAttendanceRecords() {
        
        let fetchRequest: NSFetchRequest<DeptEntry> = DeptEntry.fetchRequest()
        do {
            let records = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
            delegate?.dataDidUpdate(records: records)
        } catch {
            print("Error fetching attendance records: \(error.localizedDescription)")
        }
    }
}
