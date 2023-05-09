//
//  ScreenUI.swift
//  NewArc
//
//  Created by Александр Сенин on 07.07.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import SwiftUI

public protocol RZSUIRouted{
    associatedtype UIPacRouter: RZUIPacRouter
    var router: UIPacRouter { get set }
    init(router: UIPacRouter)
}

public protocol RZUIPacAnyViewProtocol{
    static func createUIPacView(_ rowRouter: RZUIPacRouterNGProtocol) -> UIView?
}

public protocol RZSUIPacViewProtocol: RZUIPacAnyViewProtocol{}

extension RZSUIPacViewProtocol{
    public static func createUIPacView(_ rowRouter: RZUIPacRouterNGProtocol) -> UIView? { nil }
}

extension RZUIPacAnyViewProtocol where Self: RZSUIPacView{
    public static func createUIPacView(_ rowRouter: RZUIPacRouterNGProtocol) -> UIView? {
        guard let ro = rowRouter as? UIPacRouter else { return nil }
        return RZSUIViewWraper(ro) { AnyView(Self(router: $0)) }
    }
}

public protocol RZSUIPacView: View, RZUIPacAnyViewProtocol, RZSUIRouted{}

