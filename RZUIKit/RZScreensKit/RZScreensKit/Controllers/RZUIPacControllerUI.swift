//
//  ScreenControllerUI.swift
//  NewArc
//
//  Created by Александр Сенин on 07.07.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import SwiftUI


public typealias RZUIPacControllerUI = RZUIHostingController & RZUIPacControllerNJProtocol & RZUIPacControllerUIProtocol

public protocol RZUIPacControllerUIProtocol: RZUIPacControllerNJProtocol, RZSetUIPacArchitectProtocol{
    associatedtype R: RZRouter
    var router: R? {get set}
    var iPhoneRouter: RZRouterNJProtocol? { get }
    var iPadRouter: RZRouterNJProtocol? { get }
    var macRouter: RZRouterNJProtocol? { get }
}

extension RZUIPacControllerUIProtocol{
    public var iPhoneRouter: RZRouterNJProtocol? { nil }
    public var iPadRouter: RZRouterNJProtocol? { nil }
    public var macRouter: RZRouterNJProtocol? { nil }
    
    public func setArchitect(){
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
        router?.setUIPacC(self)
        if let hostingController = self as? UIHostingController<AnyView>, let router = router{
            hostingController.rootView = (router.rzViewType?.init().testSelf(rowRouter: router))!
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


