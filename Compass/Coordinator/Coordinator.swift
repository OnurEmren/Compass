//
//  Coordinator.swift
//  Compass
//
//  Created by Onur Emren on 17.01.2024.
//

import Foundation
import UIKit

enum Event {
    case goToDetail
}

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController? { get set }
    func eventOccured(with type: Event)
    func start()
}

protocol Coordinating {
    var coordinator: Coordinator? { get set }
}
