//
//  RZStoreRefrasher.swift
//  Yoga
//
//  Created by Александр Сенин on 28.09.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import Foundation
import UIKit
import SwiftyStoreKit

class RZStoreRefrasher{
    private static var refrashBackgroundTaskId: UIBackgroundTaskIdentifier?
    
    static func start(){
        refrash()
        _ = Timer.scheduledTimer(withTimeInterval: 20, repeats: true, block: {_ in
            DispatchQueue.global(qos: .background).async { refrash() }
        })
    }
    
    static func refrash(){
        refrashBackgroundTaskId = UIApplication.shared.beginBackgroundTask(withName: "refrash")
        
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: RZProduct.sharedSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            if case .success(let receipt) = result {
                let res = getActiveReceiptItem(receipt)
                RZStoreKit.activeReceipts = res
            }
            
            Thread.isMainThread ? RZStoreKit.delegate?.update() : DispatchQueue.main.sync {RZStoreKit.delegate?.update()}

            if let btID = refrashBackgroundTaskId{
                UIApplication.shared.endBackgroundTask(btID)
            }
        }
    }
    
    private static func getActiveReceiptItem(_ receipt: ReceiptInfo) -> [ReceiptItem]{
        var activeReceipts = [ReceiptItem]()
        for (_, product) in RZProduct.allProduct{
            if let receipt = product.productType == .subscription ? verifySubscription(product, receipt) : verifyPurchase(product, receipt){
                activeReceipts.append(receipt)
            }
        }
        return activeReceipts
    }
    
    private static func verifySubscription(_ product: RZProduct, _ receipt: ReceiptInfo) -> ReceiptItem? {
        let purchaseResult = SwiftyStoreKit.verifySubscription(ofType: .autoRenewable, productId: product.id, inReceipt: receipt)
        if case .purchased(_, let receiptItems) = purchaseResult{
            return receiptItems.first
        }
        return nil
    }
    
    private static func verifyPurchase(_ product: RZProduct, _ receipt: ReceiptInfo) -> ReceiptItem?{
        let purchaseResult = SwiftyStoreKit.verifyPurchase(productId: product.id, inReceipt: receipt)
        if case .purchased(let receiptItem) = purchaseResult{
            return receiptItem
        }
        return nil
    }
    
}
