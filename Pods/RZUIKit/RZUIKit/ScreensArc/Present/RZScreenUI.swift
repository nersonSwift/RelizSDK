//
//  ScreenUI.swift
//  NewArc
//
//  Created by Александр Сенин on 07.07.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import SwiftUI

public protocol RZAnyScreen{
    func testSelf(rowRouter: RZRowRouter) -> AnyView?
    init()
}
extension RZAnyScreen{
    func testSelf(rowRouter: RZRowRouter) -> AnyView?{
        return nil
    }
}
extension RZAnyScreen where Self: RZScreenUI{
    func testSelf(rowRouter: RZRowRouter) -> AnyView?{
        let ro = rowRouter as! R
        return AnyView(self.environmentObject(ro))
    }
}

public protocol RZScreenUI: View, RZAnyScreen{
    associatedtype R: RZRouter
    var router: R { get }
    var screenController: RZScreenControllerProtocol? { get }
    init()
}

extension RZScreenUI{
    var screenController: RZScreenControllerProtocol? { router.screenController }
}
