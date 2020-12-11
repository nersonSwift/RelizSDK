//
//  ScreenUI.swift
//  NewArc
//
//  Created by Александр Сенин on 07.07.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import SwiftUI

public protocol RZAnyScreen{
    func testSelf(rowRouter: RZRouterNJProtocol) -> AnyView?
    init()
}
extension RZAnyScreen{
    public func testSelf(rowRouter: RZRouterNJProtocol) -> AnyView?{
        return nil
    }
}
extension RZAnyScreen where Self: RZScreenUI{
    public func testSelf(rowRouter: RZRouterNJProtocol) -> AnyView?{
        let ro = rowRouter as! R
        return AnyView(self.environmentObject(ro))
    }
}

public protocol RZScreenUI: View, RZAnyScreen{
    associatedtype R: RZRouter
    var router: R { get }
    var controller: R.Controller? { get }
}

extension RZScreenUI{
    public var controller: R.Controller? { router.controller }
}
