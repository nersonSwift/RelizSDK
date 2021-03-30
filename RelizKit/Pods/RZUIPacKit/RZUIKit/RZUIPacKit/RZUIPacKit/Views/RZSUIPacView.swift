//
//  ScreenUI.swift
//  NewArc
//
//  Created by Александр Сенин on 07.07.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import SwiftUI

public protocol RZUIPacAnyViewProtocol{
    static func createSelf(_ rowRouter: RZUIPacRouterNJProtocol) -> UIView?
}

public protocol RZSUIPacViewProtocol: RZUIPacAnyViewProtocol{}

extension RZSUIPacViewProtocol{
    public static func createSelf(_ rowRouter: RZUIPacRouterNJProtocol) -> UIView? { nil }
}

extension RZUIPacAnyViewProtocol where Self: RZSUIPacView{
    public static func createSelf(_ rowRouter: RZUIPacRouterNJProtocol) -> UIView? {
        guard let ro = rowRouter as? UIPacRouter else { return nil }
        return RZUIViewWraper(ro) { AnyView(Self(router: $0)) }
    }
}

public protocol RZSUIPacView: View, RZUIPacAnyViewProtocol, RZSUIRouted{}

