//
//  PaywallViewModel.swift
//  Lullaby
//
//  Created by Akbar Khusanbaev on 05/12/23.
//

import Foundation
import StoreKit
import FirebaseAnalytics

// Hard coded part
func getHardcodedProductDescription(priceDisplay: String, productId: String) -> String {
    
    if productId == "autorenewable.weeklyaccess" {
        return "Listen without restrictions,".localized + priceDisplay + "/7 days\nBest deal".localized
    } else if productId == "nonconsumable.lifetimeaccess" {
        return "Upgrade forever for just".localized + priceDisplay + " " + "No subscription, pay once".localized
    } else if productId == "autorenewable.yearlyaccess" {
        return ""
    } else {
        return ""
    }
}

final class PaywallViewModel: ObservableObject {
    
    @Published private(set) var purchasing: Bool = false
    @Published private(set) var products: [Product] = []
    @Published private(set) var purchased: [Product] = []
    
    @Published var ready: Bool = false
    @Published var selectedProduct: Product?
    
    var updateListenerTask: Task<Void, Error>?
    
    private let productIds: [String : String]
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    init() {
        self.productIds = Self.loadProductIds()
        
        updateListenerTask = listenForTransactions()
        
        Task {
            await requestProducts()
            
            await updateCustomerProductStatus()
            
            await MainActor.run {
                ready = true
            }
        }
    }
    
    static func loadProductIds() -> [String : String] {
        guard let path = Bundle.main.path(forResource: "Products", ofType: "plist"),
              let plist = FileManager.default.contents(atPath: path),
              let data = try? PropertyListSerialization.propertyList(from: plist, format: nil) as? [String: String] else {
            return [:]
        }
        return data
    }
    
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            //Iterate through any transactions that don't come from a direct call to `purchase()`.
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)

                    //Deliver products to the user.
                    await self.updateCustomerProductStatus()

                    //Always finish a transaction.
                    await transaction.finish()
                } catch {
                    //StoreKit has a transaction that fails verification. Don't deliver content to the user.
                    print("Transaction failed verification")
                }
            }
        }
    }
    
    @MainActor
    func requestProducts() async {
        do {
            //Request products from the App Store using the identifiers that the Products.plist file defines.
            let storeProducts = try await Product.products(for: productIds.keys)
            var newProducts = [Product]()
            
            //Filter the products into categories based on their type.
            for product in storeProducts {
                switch product.type {
                case .nonConsumable:
//                    newProducts.append(product)
                    // Now we ignore one-time puchase
                    continue
                case .autoRenewable:
                    newProducts.append(product)
                default:
                    //Ignore this product.
                    print("Unknown product")
                }
            }
            if selectedProduct == nil {
                await MainActor.run {
                    self.selectedProduct = newProducts.last
                }
            }
            newProducts.sort(by: {$0.price > $1.price})
            products = newProducts
        } catch {
            print("Failed product request from the App Store server: \(error)")
        }
    }
    
    func purchase(_ product: Product) async throws -> Transaction? {
        await MainActor.run { [weak self] in
            self?.purchasing = true
        }
        //Begin purchasing the `Product` the user selects.
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            //Check whether the transaction is verified. If it isn't,
            //this function rethrows the verification error.
            let transaction = try checkVerified(verification)
            
            let category: String
            if product.id == "autorenewable.yearlyaccess" {
                category = "yearly"
            } else if product.id == "autorenewable.weeklyaccess" {
                category = "weekly"
            } else {
                category = "other"
            }
            
            Analytics.setDefaultEventParameters([AnalyticsParameterItemCategory: category])
            Analytics.logTransaction(transaction)

            //The transaction is verified. Deliver content to the user.
            await updateCustomerProductStatus()

            //Always finish a transaction.
            await transaction.finish()
            await MainActor.run { [weak self] in
                self?.purchasing = false
            }
            return transaction
        case .userCancelled, .pending:
            await MainActor.run { [weak self] in
                self?.purchasing = false
            }
            return nil
        default:
            await MainActor.run { [weak self] in
                self?.purchasing = false
            }
            return nil
        }
    }
    
    @MainActor
    func updateCustomerProductStatus() async {
        var purchasedItems: [Product] = []
        
        //Iterate through all of the user's purchased products.
        for await result in Transaction.currentEntitlements {
            do {
                //Check whether the transaction is verified. If it isn’t, catch `failedVerification` error.
                let transaction = try checkVerified(result)

                //Check the `productType` of the transaction and get the corresponding product from the store.
                switch transaction.productType {
                case .nonConsumable:
                    if let product = products.first(where: { $0.id == transaction.productID }) {
                        purchasedItems.append(product)
                    }
                case .autoRenewable:
                    if let product = products.first(where: { $0.id == transaction.productID}) {
                        purchasedItems.append(product)
                    }
                default:
                    break
                }
            } catch {
                print(error)
            }
        }
        
        self.purchased = purchasedItems
    }
    
    
    func isPurchased(_ product: Product) async throws -> Bool {
        //Determine whether the user purchases a given product.
        switch product.type {
        case .nonConsumable:
            return purchased.contains(product)
        case .autoRenewable:
            return purchased.contains(product)
        default:
            return false
        }
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        //Check whether the JWS passes StoreKit verification.
        switch result {
        case .unverified:
            //StoreKit parses the JWS, but it fails verification.
            throw StoreError.failedVerification
        case .verified(let safe):
            //The result is verified. Return the unwrapped value.
            return safe
        }
    }
    
}

enum StoreError: Error {
    case failedVerification
}
