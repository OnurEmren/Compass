//
//  Coordinator.swift
//  Compass
//
//  Created by Onur Emren on 17.01.2024.
//

import Foundation
import UIKit

enum Event {
    case goToHomeVC
    case goToDetailVC(for: Int)
    case goToInComeEntryVC
    case goToExpenseEntryVC
    case goToInvestmentEntryVC
    case goToGeneralExpenseVC
    case goToReceivablesEntryVC
    case goToDetpEntryVC
}

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController? { get set }
    var isGeneralExpense: Bool? {get set}
    func eventOccured(with type: Event)
    func start()
}

protocol Coordinating {
    var coordinator: Coordinator? { get set }
}
