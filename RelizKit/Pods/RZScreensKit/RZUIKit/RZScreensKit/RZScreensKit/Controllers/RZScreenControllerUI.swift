//
//  ScreenControllerUI.swift
//  NewArc
//
//  Created by Александр Сенин on 07.07.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import SwiftUI


public typealias RZScreenControllerUI = RZUIHostingController & RZScreenControllerProtocol & RZScreenControllerUIProtocol

public protocol RZScreenControllerUIProtocol: RZScreenControllerProtocol, RZSetPresenterProtocol{
    associatedtype R: RZRouter
    var router: R? {get set}
    var iPhoneRouter: RZRouterNJProtocol? { get }
    var iPadRouter: RZRouterNJProtocol? { get }
    var macRouter: RZRouterNJProtocol? { get }
}

extension RZScreenControllerUIProtocol{
    public var iPhoneRouter: RZRouterNJProtocol? { nil }
    public var iPadRouter: RZRouterNJProtocol? { nil }
    public var macRouter: RZRouterNJProtocol? { nil }
    
    public func setPresenter(){
        #if targetEnvironment(macCatalyst)
            if let macRouter = macRouter{
                router = macRouter as? Self.R
            }
        #else
            if UIDevice.current.userInterfaceIdiom == .pad, let iPadRouter = iPadRouter{
                router = iPadRouter as? Self.R
            }else if UIDevice.current.userInterfaceIdiom == .phone, let iPhoneRouter = iPhoneRouter{
                router = iPhoneRouter as? Self.R
            }
        #endif
        router?.setInstallableScreen(self)
        if let hostingScreen = self as? UIHostingController<AnyView>, let router = router{
            hostingScreen.rootView = (router.screenType?.init().testSelf(rowRouter: router))!
        }
    }
}

open class RZUIHostingController: UIHostingController<AnyView>{
    public init(){
        super.init(rootView: AnyView(Text("OH NO!")))
    }
    
    @objc required dynamic public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


