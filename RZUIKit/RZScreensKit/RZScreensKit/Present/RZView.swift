//
//  ScreenUI.swift
//  NewArc
//
//  Created by Александр Сенин on 07.07.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import SwiftUI

public protocol RZAnyView{
    func testSelf(rowRouter: RZRouterNJProtocol) -> AnyView?
    init()
}
extension RZAnyView{
    public func testSelf(rowRouter: RZRouterNJProtocol) -> AnyView?{
        return nil
    }
}
extension RZAnyView where Self: RZView{
    public func testSelf(rowRouter: RZRouterNJProtocol) -> AnyView?{
        let ro = rowRouter as! R
        return AnyView(self.environmentObject(ro))
    }
}

public protocol RZView: View, RZAnyView{
    associatedtype R: RZRouter
    var router: R { get }
    var controller: R.Controller? { get }
}

extension RZView{
    public var controller: R.Controller? { router.controller }
}
