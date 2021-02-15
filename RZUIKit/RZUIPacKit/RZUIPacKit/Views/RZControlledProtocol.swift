//
//  RZControlledProtocol.swift
//  RZScreensKit
//
//  Created by Александр Сенин on 11.12.2020.
//

import Foundation

public protocol RZUIRouted{
    associatedtype UIPacRouter: RZUIPacRouter
    var router: UIPacRouter! { get set }
}

public protocol RZSUIRouted{
    associatedtype UIPacRouter: RZUIPacRouter
    var router: UIPacRouter { get set }
    init(router: UIPacRouter)
}
