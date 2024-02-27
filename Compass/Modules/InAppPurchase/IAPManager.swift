//
//  IAPurchase.swift
//  Compass
//
//  Created by Onur Emren on 27.02.2024.
//

import Foundation
import StoreKit

final class IAPManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    static let shared = IAPManager()
    var products = [SKProduct]()
    
    enum Products: String, CaseIterable {
        case subscribe_bronz
        case subscribe_silver
        case subscribe_gold
        case subscribe_diamond
    }
    
    public func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: Set(Products.allCases.compactMap({ $0.rawValue})))
        request.delegate = self
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        <#code#>
    }
}
