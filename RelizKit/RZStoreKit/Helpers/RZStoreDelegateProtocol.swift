//
//  RZStoreDelegateProtocol.swift
//  Yoga
//
//  Created by Александр Сенин on 08.10.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import StoreKit


public protocol RZStoreDelegateProtocol: class{
    func upadate()
    
    func buySucces(product: RZProduct, customData: Any?)
    func buyFaild(product: RZProduct, customData: Any?)
    
    func productsReceived(skProducts: Set<SKProduct>)
}


