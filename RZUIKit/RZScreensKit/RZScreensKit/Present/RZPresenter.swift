//
//  Presenter.swift
//  NewArc
//
//  Created by Александр Сенин on 07.07.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import UIKit

class PresenterInterfase{
    weak var screenController: RZScreenControllerProtocol?
}

public protocol RZPresenterNoJenericProtocol: RZControlledNJProtocol{
    var view: UIView { get }
    func create()
    func rotate()
    func resize()
}

extension RZPresenterNoJenericProtocol{
    public func resize() {}
    public func rotate() {}
}

public protocol RZScreenModelProtocol{}

public protocol RZScreenModelSeterNJ: class {
    func setModel()
}

public protocol RZScreenModelSeter: RZScreenModelSeterNJ {
    associatedtype ScreenModel: RZScreenModelProtocol
    var screenModel: ScreenModel! {get set}
    
    func setModel()
    func setModel(_ model: ScreenModel?)
}

extension RZScreenModelSeter{
    public func setModel(){
        setModel(nil)
    }
    
    public func setModel(_ model: ScreenModel?){
        if let model = model{
            screenModel = model
        }
    }
}

public protocol RZPresenterProtocol: RZPresenterNoJenericProtocol, RZControlledProtocol{}

public typealias RZPresenterNMJ = RZPresenterNoJenericProtocol
public typealias RZPresenterNJ = RZPresenterNoJenericProtocol & RZScreenModelSeter
public typealias RZPresenterNM = RZPresenterProtocol
public typealias RZPresenter = RZPresenterProtocol & RZScreenModelSeter
