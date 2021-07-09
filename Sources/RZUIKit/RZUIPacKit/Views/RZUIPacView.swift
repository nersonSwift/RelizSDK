//
//  Presenter.swift
//  NewArc
//
//  Created by Александр Сенин on 07.07.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import UIKit

public protocol RZUIRouted{
    associatedtype UIPacRouter: RZUIPacRouter
    var router: UIPacRouter! { get set }
}

public protocol RZUIPacViewNGProtocol: UIView, RZUIPacAnyViewProtocol{
    func initActions()
    func create()
    
    func rotate()
    func resize()
}

extension RZUIPacViewNGProtocol{
    public func initActions() {}
    public func create() {}
    
    public func resize() {}
    public func rotate() {}
    
    public static func createUIPacView(_ rowRouter: RZUIPacRouterNGProtocol) -> UIView? { nil }
}

extension RZUIPacViewNGProtocol where Self: RZUIPacViewProtocol{
    public static func createUIPacView(_ rowRouter: RZUIPacRouterNGProtocol) -> UIView? {
        guard let router = rowRouter as? UIPacRouter else {return nil}
        var view = Self(frame: .zero)
        view.router = router
        return view
    }
}

public protocol RZUIPacViewProtocol: RZUIPacViewNGProtocol, RZUIRouted{}

public typealias RZUIPacView = UIView & RZUIPacViewProtocol
