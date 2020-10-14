//
//  SubRefrasher.swift
//  Yoga
//
//  Created by Александр Сенин on 28.09.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import Foundation
import SwiftyStoreKit

class SubRefrasher{
    private static var refrashBackgroundTaskId: UIBackgroundTaskIdentifier?
    
    static func start(){
        refrash()
        _ = Timer.scheduledTimer(withTimeInterval: 20, repeats: true, block: {_ in
            DispatchQueue.global(qos: .background).async { refrash() }
        })
    }
    
    static func refrash(){
        refrashBackgroundTaskId = UIApplication.shared.beginBackgroundTask(withName: "refrash")
        
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: Product.sharedSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            if case .success(let receipt) = result {
                let res = getActiveReceiptItem(receipt)
                SubController.activeReceipts = res
            }
        
            SubController.delegate?.upadate()
            if let btID = refrashBackgroundTaskId{
                UIApplication.shared.endBackgroundTask(btID)
            }
        }
    }
    
    private static func getActiveReceiptItem(_ receipt: ReceiptInfo) -> [ReceiptItem]{
        var activeReceipts = [ReceiptItem]()
        for (_, product) in Product.allProduct{
            if let receipt = product.productType == .subscription ? verifySubscription(product, receipt) : verifyPurchase(product, receipt){
                activeReceipts.append(receipt)
            }
        }
        return activeReceipts
    }
    
    private static func verifySubscription(_ product: Product, _ receipt: ReceiptInfo) -> ReceiptItem? {
        let purchaseResult = SwiftyStoreKit.verifySubscription(ofType: .autoRenewable, productId: product.id, inReceipt: receipt)
        if case .purchased(_, let receiptItems) = purchaseResult{
            return receiptItems.first
        }
        return nil
    }
    
    private static func verifyPurchase(_ product: Product, _ receipt: ReceiptInfo) -> ReceiptItem?{
        let purchaseResult = SwiftyStoreKit.verifyPurchase(productId: product.id, inReceipt: receipt)
        if case .purchased(let receiptItem) = purchaseResult{
            return receiptItem
        }
        return nil
    }
    
}
