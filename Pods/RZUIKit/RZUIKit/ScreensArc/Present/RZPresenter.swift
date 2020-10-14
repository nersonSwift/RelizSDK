//
//  Presenter.swift
//  NewArc
//
//  Created by Александр Сенин on 07.07.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import UIKit

fileprivate class PresenterInterfase{
    weak var screenController: RZScreenControllerProtocol?
}

public protocol RZPresenterNoJenericProtocol: NSObject{
    var view: UIView { get }
    func create()
    init(installableScreen: RZScreenControllerProtocol)
}

extension RZPresenterNoJenericProtocol{
    public var view: UIView{
        screenController?.view ?? UIView()
    }
    
    public var screenController: RZScreenControllerProtocol?{
        set(screenController){
            screenControllerInterfase.screenController = screenController
        }
        get{
            screenControllerInterfase.screenController
        }
    }
    
    public init(installableScreen: RZScreenControllerProtocol) {
        self.init()
        screenController = installableScreen
    }
    
    private var key: UnsafeRawPointer? {
        return UnsafeRawPointer(bitPattern: 16)
    }
    
    private var screenControllerInterfase: PresenterInterfase {
        if let key = key, let presenterInterfase = objc_getAssociatedObject(self, key) as? PresenterInterfase{
            return presenterInterfase
        }
        let presenterInterfase = PresenterInterfase()
        
        if let key = key{
            objc_setAssociatedObject(self, key, presenterInterfase, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
        return presenterInterfase
    }
}


public protocol RZPresenterProtocol: RZPresenterNoJenericProtocol{
    associatedtype Controller: RZScreenControllerProtocol
    var controller: Controller? { get }
}

extension RZPresenterProtocol {
    public var controller: Controller?{ screenController as? Controller }
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


public typealias RZPresenterNMJ = NSObject & RZPresenterNoJenericProtocol
public typealias RZPresenterNJ = NSObject & RZPresenterNoJenericProtocol & RZScreenModelSeter
public typealias RZPresenterNM = NSObject & RZPresenterProtocol
public typealias RZPresenter = NSObject & RZPresenterProtocol & RZScreenModelSeter




