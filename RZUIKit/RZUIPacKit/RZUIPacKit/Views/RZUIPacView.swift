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
    
    func setRouter(_ router: RZUIPacRouterNJProtocol)
    
    static func createSelf() -> Self?
}

extension RZUIPacViewNoJenericProtocol{
    public func create() {}
    public func resize() {}
    public func rotate() {}
    
    public func setRouter(_ router: RZUIPacRouterNJProtocol) {}
    
    public static func createSelf() -> Self? {nil}
}

extension RZUIPacViewNoJenericProtocol where Self: RZUIPacViewProtocol{
    public static func createSelf() -> Self? { Self(frame: .zero) }
    public func setRouter(_ router: RZUIPacRouterNJProtocol) {
        guard let router = router as? UIPacRouter else {return}
        var view = self
        view.router = router
    }
}

public protocol RZUIPacViewProtocol: RZUIPacViewNoJenericProtocol, RZUIRouted{}

public typealias RZUIPacView = UIView & RZUIPacViewProtocol
