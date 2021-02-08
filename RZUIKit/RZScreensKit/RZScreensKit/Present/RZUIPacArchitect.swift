//
//  Presenter.swift
//  NewArc
//
//  Created by Александр Сенин on 07.07.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import UIKit

class RZUIPacArchitectInterfase{
    weak var uiPacC: RZUIPacControllerNJProtocol?
}

public protocol RZUIPacArchitectNoJenericProtocol: RZControlledNJProtocol{
    var view: UIView { get }
    func create()
    func rotate()
    func resize()
}

extension RZUIPacArchitectNoJenericProtocol{
    public func create() {}
    public func resize() {}
    public func rotate() {}
}

public protocol RZUIPacModelProtocol{}
public protocol RZUIPacArchitect: RZUIPacArchitectNoJenericProtocol, RZControlledProtocol{}

