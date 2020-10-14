//
//  Product.swift
//  Yoga
//
//  Created by Александр Сенин on 09.10.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import Foundation
import StoreKit
import SwiftyStoreKit

public enum ProductType{
    case subscription
    case purchase
}

//MARK: - Product
/// `RU: - `
/// Модель продукта, используется для оформления покупки, нуждается в статической инициализации при запуске приложения
///
/// Пример статической инициализации:
///
///     Product.sharedSecret = "8318cg423s4145e3fgdffdfgdfgb7"
///     Product.add([
///         Product(id: "com.test.sub.year.a.allaccess",
///                 customData: [
///                     "af": "year_c",
///                     "adjust": [true: "fsdfse", false: "vthjec"]
///                 ]
///         ),
///         Product(id: "com.test.sub.livetime.allaccess",
///                 isSubscibe: false,
///                 customData: [
///                     "af": "livetime",
///                     "adjust": [true: "gercvj", false: "cefdhh"]
///                 ]
///         )
///     ])
public struct Product: Equatable{
    //MARK: - id
    /// `RU: - `
    /// ID  подписки из AppStore Connect
    public var id: String
    
    //MARK: - isSubscibe
    /// `RU: - `
    /// Флаг подписки. Установите `true` если продукт является подпиской
    public var productType: ProductType = .subscription
    
    //MARK: - customData
    /// `RU: - `
    /// Любые данные которые могут быть использованны в дальнейшем
    public var customData: [String: Any] = [:]
    
    //MARK: - init
    /// `RU: - `
    /// инициализатор продукта
    ///
    /// - Parameter id
    /// ID  подписки из AppStore Connect
    ///
    /// - Parameter productType
    /// Тип продукта. Значение по умолчанию `.subscription`
    ///
    /// - Parameter isSubscibe
    /// Любые данные которые могут быть использованны в дальнейшем
    public init(id: String, productType: ProductType = .subscription, customData: [String: Any] = [:]){
        self.id = id
        self.productType = productType
        self.customData = customData
    }
    
    //MARK: - getProduct
    /// `RU: - `
    /// Возвращает зарегестрированный продукт
    ///
    /// - Parameter id
    /// ID  подписки из AppStore Connect
    public static func getProduct(_ id: String) -> Product?{
        return allProduct[id]
    }
    
    //MARK: - sharedSecret
    /// `RU: - `
    /// Ключ приложения
    public static var sharedSecret: String = ""
    
    //MARK: - add
    /// `RU: - `
    /// Метод регестрирующий продукты для дальшейшего использования
    public static func add(_ products: [Product]){
        for product in products{
            allProduct[product.id] = product
        }
        getProducInfo()
    }
    
    //MARK: - subscribe
    /// `RU: - `
    /// Метод инициирующий процесс покупки
    ///
    /// - Parameter customData
    /// Любые данные которые могут быть использованны в делегате
    ///
    /// - Parameter completion
    /// Замыкание которое будет вызвано после окончания процесса покупки
    public func subscribe(_ customData: Any? = nil, completion: (()->())? = nil){
        SubController.subscribe(product: self, customData: customData, completion: completion)
    }
    
    //MARK: - getPrice
    /// `RU: - `
    /// Метод устанавливает замыкание ожидающее получения локализованного ценника подписки
    ///
    /// Если значение цены уже получено зымыкание будет вызвано сразу
    ///
    /// - Parameter productId
    /// Продукт
    /// - Parameter action
    /// Замыкание принимающее локалезированный ценник
    public static func getPrice(productId: Product, action: @escaping (String)->()){
        DispatchQueue.main.async {
            getValue(productId, prises, &prisesClosure, action)
        }
    }
    
    /// `RU: - `
    /// Метод устанавливает замыкание ожидающее получения локализованного ценника подписки
    ///
    /// Если значение цены уже получено зымыкание будет вызвано сразу
    ///
    /// - Parameter action
    /// Замыкание принимающее локалезированный ценник
    public func getPrice(action: @escaping (String)->()){
        Self.getPrice(productId: self, action: action)
    }
    
    //MARK: - getPricesMans
    /// `RU: - `
    /// Метод устанавливает замыкание ожидающее получения ценника подписки
    ///
    /// Если значение цены уже получено зымыкание будет вызвано сразу
    ///
    /// - Parameter productId
    /// Продукт
    /// - Parameter action
    /// Замыкание принимающее локалезированный ценник
    public static func getPricesMans(productId: Product, action: @escaping (String)->()){
        DispatchQueue.main.async {
            getValue(productId, prisesMans, &prisesMansClosure, action)
        }
    }
    
    /// `RU: - `
    /// Метод устанавливает замыкание ожидающее получения ценника подписки
    ///
    /// Если значение цены уже получено зымыкание будет вызвано сразу
    ///
    /// - Parameter action
    /// Замыкание принимающее ценник
    public func getPricesMans(action: @escaping (String)->()){
        Self.getPricesMans(productId: self, action: action)
    }
    
    //MARK: - getCurrencyCods
    /// `RU: - `
    /// Метод устанавливает замыкание ожидающее получение кода валюты подписки
    ///
    /// Если значение кода валюты уже получено зымыкание будет вызвано сразу
    ///
    /// - Parameter productId
    /// Продукт
    /// - Parameter action
    /// Замыкание принимающее локалезированный кода валюты
    public static func getCurrencyCods(productId: Product, action: @escaping (String)->()){
        DispatchQueue.main.async {
            getValue(productId, currencyCods, &currencyCodsClosure, action)
        }
    }
    
    /// `RU: - `
    /// Метод устанавливает замыкание ожидающее получение кода валюты подписки
    ///
    /// Если значение кода валюты уже получено зымыкание будет вызвано сразу
    ///
    /// - Parameter action
    /// Замыкание принимающее локалезированный кода валюты
    public func getCurrencyCods(action: @escaping (String)->()){
        Self.getCurrencyCods(productId: self, action: action)
    }
    
    static var allProduct: [String: Product] = [:]
    
    static var allKeys: Set<String> {
        var allKeys: Set<String> = []
        allProduct.forEach{allKeys.insert($0.key)}
        return allKeys
    }
    
    public static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.id == rhs.id
    }
    
    private static var prises: [String: String] = [:]
    private static var prisesMans: [String: String] = [:]
    private static var currencyCods: [String: String] = [:]
    
    private static var prisesClosure: [String: (String)->()] = [:]
    private static var prisesMansClosure: [String: (String)->()] = [:]
    private static var currencyCodsClosure: [String: (String)->()] = [:]
    
    static func setPrise(_ productId: Product, _ prise: String){
        DispatchQueue.main.async {
            prises[productId.id] = prise
            prisesClosure.removeValue(forKey: productId.id)?(prise)
        }
    }
    static func setPrisesMans(_ productId: Product, _ priseMan: String){
        DispatchQueue.main.async {
            prisesMans[productId.id] = priseMan
            prisesMansClosure.removeValue(forKey: productId.id)?(priseMan)
        }
    }
    static func setCurrencyCods(_ productId: Product, _ currencyCod: String){
        DispatchQueue.main.async {
            currencyCods[productId.id] = currencyCod
            currencyCodsClosure.removeValue(forKey: productId.id)?(currencyCod)
        }
    }
    
    private static func getProducInfo(){
        var skProducts: Set<SKProduct> = []{
            didSet{
                DispatchQueue.main.async{ setProducInfo(prodects: skProducts) }
            }
        }
        SwiftyStoreKit.retrieveProductsInfo(allKeys) { result in
            if skProducts != result.retrievedProducts{
                skProducts = result.retrievedProducts
            }
            if result.retrievedProducts.count < allKeys.count{
                DispatchQueue.main.async {
                    getProducInfo()
                }
                return
            }
        }
    }
    
    private static func setProducInfo(prodects: Set<SKProduct>){
        if prodects != []{
            for plan in prodects{
                if let productId = getProduct(plan.productIdentifier),
                   let price = plan.localizedPrice,
                   let currencyCode = plan.priceLocale.currencyCode{
                    setPrise(productId, price)
                    setPrisesMans(productId, "\(plan.price)")
                    setCurrencyCods(productId, currencyCode)
                }
            }
            SubController.delegate?.productsReceived(skProducts: prodects)
        }else{
            getProducInfo()
        }
    }
    
    
    
    
    private static func getValue(_ productId: Product,
                                 _ dic: [String: String],
                                 _ closures: inout [String: (String)->()],
                                 _ action: @escaping (String)->()){
        if let value = dic[productId.id]{
            action(value)
        }else{
            closures[productId.id] = action
        }
    }
}
