//
//  CurrencyModel.swift
//  Compass
//
//  Created by Onur Emren on 10.02.2024.
//

import Foundation

struct CurrencyModel: Codable {
    let success: Bool
    let timestamp: TimeInterval
    let base: String
    let date: String
    let rates: [String: Double]
}
