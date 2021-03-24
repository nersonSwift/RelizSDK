//
//  Presenter.swift
//  NewArc
//
//  Created by Александр Сенин on 07.07.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import UIKit

public protocol RZUIPacViewNoJenericProtocol: UIView, RZUIPacAnyViewProtocol{
    func initActions()
    func create()
    
    func rotate()
    func resize()
    
    static func createSelf() -> Self?
}

extension RZUIPacViewNoJenericProtocol{
    public func initActions() {}
    public func create() {}
    
    public func resize() {}
    public func rotate() {}
    
    public static func createSelf(_ rowRouter: RZUIPacRouterNJProtocol) -> UIView? { nil }
}

extension RZUIPacViewNoJenericProtocol where Self: RZUIPacViewProtocol{
    public static func createSelf(_ rowRouter: RZUIPacRouterNJProtocol) -> UIView? {
        guard let router = rowRouter as? UIPacRouter else {return nil}
        var view = Self(frame: .zero)
        view.router = router
        return view
    }
}

public protocol RZUIPacViewProtocol: RZUIPacViewNoJenericProtocol, RZUIRouted{}

public typealias RZUIPacView = UIView & RZUIPacViewProtocol
