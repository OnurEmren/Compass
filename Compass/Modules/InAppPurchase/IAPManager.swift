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
    private var completion: ((String) -> Void)?
    public var user: Bool = false
    
    enum Product: String, CaseIterable {
        case subscribe_premium
        
        var completion: String {
            switch self {
            case .subscribe_premium:
                return "premium"
            }
        }
    }
    
    public func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: Set(Product.allCases.compactMap({ $0.rawValue})))
        request.delegate = self
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Products Returned: \(response.products.count)")
        self.products = response.products
    }
    
    func purchase(product: Product, completion: @escaping ((String) -> Void) ) {
        guard SKPaymentQueue.canMakePayments() else { return }
        guard let storeKitProduct = products.first(where: {$0.productIdentifier == product.rawValue}) else {
            return
        }
        
        self.completion = completion
        
        let paymentRequest = SKPayment(product: storeKitProduct)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(paymentRequest)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach({
            switch $0.transactionState {
                
            case .purchasing:
                break
            case .purchased:
                if let product = Product(rawValue: $0.payment.productIdentifier) {
                    completion?("\(products.count)")
                    user = true
                    UserDefaults.standard.set(true, forKey: "userIsPremium")
                    print("premium özellikler açıldı - \(user)")
                }
                SKPaymentQueue.default().finishTransaction($0)
                SKPaymentQueue.default().remove(self)
                
                
            case .failed:
                print("özellikler kısıtlandı")
                break
            case .restored:
                break
            case .deferred:
                break
            @unknown default:
                break
            }
        })
    }
}
