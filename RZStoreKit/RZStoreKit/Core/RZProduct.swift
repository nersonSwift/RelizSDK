//
//  RZProduct.swift
//  Yoga
//
//  Created by Александр Сенин on 09.10.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import Foundation
import StoreKit
import SwiftyStoreKit

public enum RZProductType{
    case subscription
    case purchase
}

//MARK: - RZProduct
/// `RU: - `
/// Модель продукта, используется для оформления покупки, нуждается в статической инициализации при запуске приложения
///
/// Пример статической инициализации:
///
///     RZProduct.sharedSecret = "8318cg423s4145e3fgdffdfgdfgb7"
///     RZProduct.add([
///         RZProduct(id: "com.test.sub.year.a.allaccess",
///                 customData: [
///                     "af": "year_c",
///                     "adjust": [true: "fsdfse", false: "vthjec"]
///                 ]
///         ),
///         RZProduct(id: "com.test.sub.livetime.allaccess",
///                 isSubscibe: false,
///                 customData: [
///                     "af": "livetime",
///                     "adjust": [true: "gercvj", false: "cefdhh"]
///                 ]
///         )
///     ])
public struct RZProduct: Equatable{
    //MARK: - id
    /// `RU: - `
    /// ID  подписки из AppStore Connect
    public var id: String
    
    //MARK: - isSubscibe
    /// `RU: - `
    /// Флаг подписки. Установите `true` если продукт является подпиской
    public var productType: RZProductType = .subscription
    
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
    public init(id: String, productType: RZProductType = .subscription, customData: [String: Any] = [:]){
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
    public static func getProduct(_ id: String) -> RZProduct?{
        return allProduct[id]
    }
    
    //MARK: - sharedSecret
    /// `RU: - `
    /// Ключ приложения
    public static var sharedSecret: String = ""
    
    //MARK: - add
    /// `RU: - `
    /// Метод регестрирующий продукты для дальшейшего использования
    public static func add(_ products: [RZProduct]){
        for product in products{
            allProduct[product.id] = product
        }
        getProducInfo()
    }
    
    //MARK: - buy
    /// `RU: - `
    /// Метод инициирующий процесс покупки
    ///
    /// - Parameter customData
    /// Любые данные которые могут быть использованны в делегате
    ///
    /// - Parameter completion
    /// Замыкание которое будет вызвано после окончания процесса покупки
    public func buy(_ customData: Any? = nil, completion: (()->())? = nil){
        RZStoreKit.buy(product: self, customData: customData, completion: completion)
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
    public static func getPrice(productId: RZProduct, action: @escaping (String)->()){
        DispatchQueue.main.async {
            getValue(productId, prices, &pricesClosure, action)
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
    public static func getPricesMans(productId: RZProduct, action: @escaping (String)->()){
        DispatchQueue.main.async {
            getValue(productId, pricesMans, &pricesMansClosure, action)
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
    public static func getCurrencyCods(productId: RZProduct, action: @escaping (String)->()){
        DispatchQueue.main.async {
            getValue(productId, currencyCods, &currencyCodsClosure, action)
        }
    }
    
    public static func getCurrencySymbol(productId: RZProduct, action: @escaping (String)->()){
        DispatchQueue.main.async {
            getValue(productId, currencySymbols, &currencySymbolClosure, action)
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
    public func getCurrencySymbol(action: @escaping (String)->()){
        DispatchQueue.main.async {
            Self.getCurrencySymbol(productId: self, action: action)
        }
    }
    
    static var allProduct: [String: RZProduct] = [:]
    
    static var allKeys: Set<String> {
        var allKeys: Set<String> = []
        allProduct.forEach{allKeys.insert($0.key)}
        return allKeys
    }
    
    public static func == (lhs: RZProduct, rhs: RZProduct) -> Bool {
        lhs.id == rhs.id
    }
    
    private static var prices: [String: String] = [:]
    private static var pricesMans: [String: String] = [:]
    private static var currencyCods: [String: String] = [:]
    private static var currencySymbols: [String: String] = [:]
    
    private static var pricesClosure: [String: (String)->()] = [:]
    private static var pricesMansClosure: [String: (String)->()] = [:]
    private static var currencyCodsClosure: [String: (String)->()] = [:]
    private static var currencySymbolClosure: [String: (String)->()] = [:]
    
    static func setPrice(_ productId: RZProduct, _ price: String){
        DispatchQueue.main.async {
            prices[productId.id] = price
            pricesClosure.removeValue(forKey: productId.id)?(price)
        }
    }
    static func setPricesMans(_ productId: RZProduct, _ priceMan: String){
        DispatchQueue.main.async {
            pricesMans[productId.id] = priceMan
            pricesMansClosure.removeValue(forKey: productId.id)?(priceMan)
        }
    }
    static func setCurrencyCods(_ productId: RZProduct, _ currencyCod: String){
        DispatchQueue.main.async {
            currencyCods[productId.id] = currencyCod
            currencyCodsClosure.removeValue(forKey: productId.id)?(currencyCod)
        }
    }
    static func setCurrencySymbols(_ productId: RZProduct, _ currencySymbol: String){
        DispatchQueue.main.async {
            currencySymbols[productId.id] = currencySymbol
            currencySymbolClosure.removeValue(forKey: productId.id)?(currencySymbol)
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
            if result.retrievedProducts.count == 0{
                _ = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
                    DispatchQueue.main.async {
                        getProducInfo()
                    }
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
                   let currencyCode = plan.priceLocale.currencyCode,
                   let currencySymbol = plan.priceLocale.currencySymbol{
                    setPrice(productId, price)
                    setPricesMans(productId, "\(plan.price)")
                    setCurrencyCods(productId, currencyCode)
                    setCurrencySymbols(productId, currencySymbol)
                }
            }
            RZStoreKit.delegate?.productsReceived(skProducts: prodects)
        }else{
            getProducInfo()
        }
    }
    
    
    
    
    private static func getValue(_ productId: RZProduct,
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
