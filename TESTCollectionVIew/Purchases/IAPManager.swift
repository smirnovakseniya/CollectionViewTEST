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
    
    var products = [SKProduct]()
    
    private var complition: ((Bool) -> Void)?
    
    //MARK: - Functions
    
    public func fetchProduct() {
        
        let request = SKProductsRequest(productIdentifiers: Set(Product.allCases.compactMap({ $0.rawValue })))
        request.delegate = self
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
    }
    
    public func purchase(product: Product, complition: @escaping (Bool) -> Void) {
        guard SKPaymentQueue.canMakePayments() else { return }
        guard let storeKitProduct = products.first(where: { $0.productIdentifier == product.rawValue}) else { return }
        
        self.complition = complition
        
        let paymentRequest = SKPayment(product: storeKitProduct)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(paymentRequest)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach ({
            switch $0.transactionState {
            case .purchased:
                complition?(true)
                SKPaymentQueue.default().finishTransaction($0)
                SKPaymentQueue.default().remove(self)
            default:
                break
            }
        })
    }
}
