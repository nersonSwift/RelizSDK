//
//  ScreenUI.swift
//  NewArc
//
//  Created by Александр Сенин on 07.07.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import SwiftUI

public protocol RZAnySUIPacView{
    static func createSelf(_ rowRouter: RZUIPacRouterNJProtocol) -> AnyView?
}
extension RZAnySUIPacView{
    public static func createSelf(_ rowRouter: RZUIPacRouterNJProtocol) -> AnyView? { nil }
}
extension RZAnySUIPacView where Self: RZSUIPacView{
    public static func createSelf(_ rowRouter: RZUIPacRouterNJProtocol) -> AnyView? {
        guard let ro = rowRouter as? UIPacRouter else { return nil }
        return AnyView(Self(router: ro))
    }
}

public protocol RZSUIPacView: View, RZAnySUIPacView, RZSUIRouted{}

