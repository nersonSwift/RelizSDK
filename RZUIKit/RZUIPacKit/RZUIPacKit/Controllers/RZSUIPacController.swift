//
//  ScreenControllerUI.swift
//  NewArc
//
//  Created by Александр Сенин on 07.07.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import SwiftUI
#if canImport(RZViewBuilder)
    import RZViewBuilder
#endif


public typealias RZSUIPacController = RZUIHostingController & RZSUIPacControllerProtocol

public protocol RZSUIPacControllerProtocol: RZSetUIPacViewProtocol, RZUIPacControllerRouteredProtocol{
    var iPhoneViewType: RZAnySUIPacView.Type? { get }
    var iPadViewType: RZAnySUIPacView.Type? { get }
    var macViewType: RZAnySUIPacView.Type? { get }
}

extension RZSUIPacControllerProtocol{
    public var iPhoneViewType: RZAnySUIPacView.Type? { nil }
    public var iPadViewType: RZAnySUIPacView.Type? { nil }
    public var macViewType: RZAnySUIPacView.Type? { nil }
    
    public func setView(){
        var rzView: RZAnySUIPacView?
        #if targetEnvironment(macCatalyst)
            if let macViewType = macViewType{
                rzView = macViewType.init()
            }
        #else
            if UIDevice.current.userInterfaceIdiom == .pad, let iPadViewType = iPadViewType{
                rzView = iPadViewType.init()
            }else if UIDevice.current.userInterfaceIdiom == .phone, let iPhoneViewType = iPhoneViewType{
                rzView = iPhoneViewType.init()
            }
        #endif
        #if canImport(RZViewBuilder)
            router.setRZObservables()
        #endif
        
        var rzViewL = rzView as? RZControlledNJProtocol & RZAnySUIPacView
        rzViewL?.setUIPacC(self)
        if let hostingController = self as? UIHostingController<AnyView>{
            hostingController.rootView = (rzViewL?.testSelf(rowRouter: router))!
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


