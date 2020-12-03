//
//  ScreenControllerUI.swift
//  NewArc
//
//  Created by Александр Сенин on 07.07.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import SwiftUI


public typealias RZScreenControllerUI = UIHostingController<AnyView> & RZScreenControllerProtocol & RZScreenControllerUIProtocol

public protocol RZScreenControllerUIProtocol: RZScreenControllerProtocol, RZSetPresenterProtocol{
    associatedtype R: RZRouter
    var router: R? {get set}
    var iPhoneRouter: R.Type? { get }
    var iPadRouter: R.Type? { get }
}

extension RZScreenControllerUIProtocol{
    public var iPhoneRouter: R.Type? { nil }
    public var iPadRouter: R.Type? { nil }
    
    public func setPresenter(){
        if UIDevice.current.userInterfaceIdiom == .pad, let type = iPadRouter{
            router = type.init()
        }else if UIDevice.current.userInterfaceIdiom == .phone, let type = iPhoneRouter{
            router = type.init()
        }else{
            router = R.init()
        }
        router?.screenController = self
        
        if let hostingScreen = self as? UIHostingController<AnyView>, let router = router{
            hostingScreen.rootView = (router.screenType?.init().testSelf(rowRouter: router))!
        }
    }
}



