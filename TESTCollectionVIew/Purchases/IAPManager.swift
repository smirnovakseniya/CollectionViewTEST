//
//  IAPManager.swift
//  TESTCollectionVIew
//
//  Created by Kseniya Smirnova on 7.10.22.
//

import Foundation
import StoreKit

final class IAPManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    //MARK: - Variables
    
    static let shared = IAPManager()
    
    private var products = [SKProduct]()
    private var completion: ((Bool) -> Void)?
    
    //MARK: - Functions
    
    public func fetchProduct() {
        let request = SKProductsRequest(productIdentifiers: Set(Product.allCases.compactMap({ $0.rawValue })))
        request.delegate = self
        request.start()
    }
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
    }
    
    public func purchase(product: Product?, completion: @escaping (Bool) -> Void) {
        guard SKPaymentQueue.canMakePayments() else { return }
        guard let storeKitProduct = products.first(where: { $0.productIdentifier == product?.rawValue}) else { return }
        
        self.completion = completion
        
        let paymentRequest = SKPayment(product: storeKitProduct)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(paymentRequest)
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach ({
            switch $0.transactionState {
            case .purchased:
                completion?(true)
                SKPaymentQueue.default().finishTransaction($0)
                SKPaymentQueue.default().remove(self)
            default:
                break
            }
        })
    }
}
