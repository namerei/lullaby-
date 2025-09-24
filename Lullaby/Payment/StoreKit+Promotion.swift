//
//  StoreKit+Promotion.swift
//  Lullaby
//
//  Created by Akbar Khusanbaev on 02/02/24.
//

import StoreKit

extension AppDelegate: SKPaymentTransactionObserver, SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                self.purchasedTransaction(transaction: transaction)
            default:
                break
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        // Getting products dictionary
        self.productIds = self.getProductIds()
        
        let paywallVM = PaywallViewModel()
        
        if paywallVM.purchased.contains(where: {$0.id == product.productIdentifier}) {
            return false
        }
        
        let request = SKProductsRequest(productIdentifiers: Set(productIds.keys))
        request.delegate = self
        request.start()
        
        return true
    }
    
    func getProductIds() -> [ String : String ] {
        guard let path = Bundle.main.path(forResource: "Products", ofType: "plist"),
              let plist = FileManager.default.contents(atPath: path),
              let data = try? PropertyListSerialization.propertyList(from: plist, format: nil) as? [String: String] else {
            return [:]
        }
        return data
    }
    
    func purchasedTransaction(transaction: SKPaymentTransaction) {
        if let product = products.first(where: {$0.productIdentifier == transaction.payment.productIdentifier}) {
            // Product product is purchased!
        }
    }
}
