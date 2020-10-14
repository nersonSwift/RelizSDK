//
//  SubDelegateProtocol.swift
//  Yoga
//
//  Created by Александр Сенин on 08.10.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import StoreKit


public protocol SubDelegateProtocol: class{
    func upadate()
    
    func subscibeSucces(product: Product, customData: Any?)
    func subscibeFaild(product: Product, customData: Any?)
    
    func productsReceived(skProducts: Set<SKProduct>)
}


