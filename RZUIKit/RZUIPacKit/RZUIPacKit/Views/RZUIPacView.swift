//
//  Presenter.swift
//  NewArc
//
//  Created by Александр Сенин on 07.07.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import UIKit

public protocol RZUIPacViewNoJenericProtocol: UIView{
    func create()
    func rotate()
    func resize()
    
    static func createSelf(_ rowRouter: RZUIPacRouterNJProtocol) -> Self?
}

extension RZUIPacViewNoJenericProtocol{
    public func create() {}
    public func resize() {}
    public func rotate() {}
    
    public static func createSelf(_ rowRouter: RZUIPacRouterNJProtocol) -> Self? {nil}
}

extension RZUIPacViewNoJenericProtocol where Self: RZUIPacViewProtocol{
    public static func createSelf(_ rowRouter: RZUIPacRouterNJProtocol) -> Self? {
        if let router = rowRouter as? UIPacRouter{
            return Self(router: router)
        }
        return nil
    }
}

public protocol RZUIPacViewProtocol: RZUIPacViewNoJenericProtocol, RZUIRouted{}

extension RZUIPacViewProtocol{
    public init(router: UIPacRouter) {
        self.init(frame: .zero)
        var test = self
        test.router = router
    }
}

public typealias RZUIPacView = UIView & RZUIPacViewProtocol
