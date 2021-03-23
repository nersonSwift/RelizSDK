//
//  ScreenControllerUI.swift
//  NewArc
//
//  Created by Александр Сенин on 07.07.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import SwiftUI
import RZObservableKit


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
        var anyView: AnyView?
        #if targetEnvironment(macCatalyst)
            if let macViewType = macViewType{
                anyView = macViewType.createSelf(router)
            }
        #else
            if UIDevice.current.userInterfaceIdiom == .pad, let iPadViewType = iPadViewType{
                anyView = iPadViewType.createSelf(router)
            }else if UIDevice.current.userInterfaceIdiom == .phone, let iPhoneViewType = iPhoneViewType{
                anyView = iPhoneViewType.createSelf(router)
            }
        #endif
        
        router.setRZObservables()
        if let hostingController = self as? UIHostingController<AnyView>, let anyView = anyView{
            hostingController.rootView = anyView
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


