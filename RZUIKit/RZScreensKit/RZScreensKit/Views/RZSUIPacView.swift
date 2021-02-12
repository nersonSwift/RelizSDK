//
//  ScreenUI.swift
//  NewArc
//
//  Created by Александр Сенин on 07.07.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import SwiftUI

public protocol RZAnySUIPacView{
    func testSelf(rowRouter: RZUIPacRouterNJProtocol) -> AnyView?
    init()
}
extension RZAnySUIPacView{
    public func testSelf(rowRouter: RZUIPacRouterNJProtocol) -> AnyView?{
        return nil
    }
}
extension RZAnySUIPacView where Self: RZSUIPacView{
    public func testSelf(rowRouter: RZUIPacRouterNJProtocol) -> AnyView?{
        let ro = rowRouter as! Controller.UIPacRouter
        return AnyView(self.environmentObject(ro))
    }
}

public protocol RZSUIPacView: View, RZAnySUIPacView, RZControlledProtocol{}

