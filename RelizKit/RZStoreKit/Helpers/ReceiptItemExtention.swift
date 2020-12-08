//
//  ReceiptItemExtention.swift
//  Yoga
//
//  Created by Александр Сенин on 28.09.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import Foundation
import SwiftyStoreKit


extension ReceiptItem{
    func getJson() -> [String: AnyObject] {
        var json: [String: AnyObject] = [:]
        
        json["purchase_date_ms"] = "\(purchaseDate.timeIntervalSince1970 * 1000)" as AnyObject
        json["original_purchase_date_ms"] = "\(originalPurchaseDate.timeIntervalSince1970 * 1000)" as AnyObject
        if let cancellationDate = cancellationDate{
            json["cancellation_date_ms"] = "\(cancellationDate.timeIntervalSince1970 * 1000)" as AnyObject
        }
        if let subscriptionExpirationDate = subscriptionExpirationDate{
            json["expires_date_ms"] = "\(subscriptionExpirationDate.timeIntervalSince1970 * 1000)" as AnyObject
        }
        
        json["is_in_intro_offer_period"] = "\(isInIntroOfferPeriod)" as AnyObject
        json["is_trial_period"] = "\(isTrialPeriod)" as AnyObject
        
        json["quantity"] = "\(quantity)" as AnyObject
        
        json["original_transaction_id"] = originalTransactionId as AnyObject
        json["product_id"] = productId as AnyObject
        json["transaction_id"] = transactionId as AnyObject
        if let webOrderLineItemId = webOrderLineItemId{
            json["web_order_line_item_id"] = webOrderLineItemId as AnyObject
        }
        
        return json
    }
}
