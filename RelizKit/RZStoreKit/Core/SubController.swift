//
//  ProductId.swift
//  Yoga
//
//  Created by Александр Сенин on 25.09.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import UIKit
import StoreKit
import SwiftyStoreKit

//MARK: - SubController
/// `RU: - `
/// Класс отвечающий за все процессы покупок и отслеживание состояния подписок
///
/// Для запуска нужно вызвать метод `start`
///
///     SubController.start(SubDelegate.instans)
///
/// Для корректоной работы необходимо провести инициализацию `Product`
public class SubController{
    //MARK: - start
    /// `RU: - `
    /// Запускает все необходимые для проверки подписок процессы. Для корректной работы лучше запускать из `AppDelegate` приложения
    public static func start(_ delegate: SubDelegateProtocol? = nil){
        self.delegate = delegate
        SubRefrasher.start()
    }
    
    public static weak var delegate: SubDelegateProtocol?
    
    public static var activeProducts: [Product] {
        var activeProducts = [Product]()
        for activeReceipt in activeReceipts{
            if let activeProduct = Product.getProduct(activeReceipt.productId){
                activeProducts.append(activeProduct)
            }
        }
        return activeProducts
    }
    
    private static var activeReceiptsKey = "activeReceipts"
    public static var activeReceipts: [ReceiptItem]{
        set(activeReceipts){
            let arr = activeReceipts.map{ $0.getJson() }
            
            UserDefaults.standard.set(arr, forKey: activeReceiptsKey)
        }
        get{
            guard let activeReceiptsRow = UserDefaults.standard.object(forKey: activeReceiptsKey) as? [[String: AnyObject]] else { return [] }
            
            var receiptItems = [ReceiptItem]()
            for activeReceiptRow in activeReceiptsRow{
                if let activeReceipt = ReceiptItem(receiptInfo: activeReceiptRow){
                    receiptItems.append(activeReceipt)
                }
            }
            
            return verefyReceiptItems(receiptItems)
        }
    }
    
    private static func verefyReceiptItems(_ value: [ReceiptItem]) -> [ReceiptItem]{
        return value.filter { self.verefyReceiptItem($0) }
    }
    
    private static func verefyReceiptItem(_ value: ReceiptItem) -> Bool{
        if let ti = value.subscriptionExpirationDate?.timeIntervalSince1970{
            if ti < Date().timeIntervalSince1970{
                return false
            }else {
                return true
            }
        }else if value.webOrderLineItemId == nil{
            return true
        }
        return false
    }
    
    
    //MARK: - subscribe
    /// `RU: - `
    /// Метод для инициирования процесса подписки
    ///
    /// - Parameter productId
    /// id продукта
    /// - Parameter completion
    /// замыкае вызываемое при окончании процесса подписки
    public static func subscribe(product: Product, customData: Any? = nil, completion: (()->())? = nil){
        SwiftyStoreKit.purchaseProduct(product.id, atomically: true){ result in
            
            switch result{
            case .success(let purchase):
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
                
                delegate?.subscibeSucces(product: product, customData: customData)
                completion?()
                SubRefrasher.refrash()
            case .error:
                delegate?.subscibeFaild(product: product, customData: customData)
                completion?()
            }
        }
    }
}








