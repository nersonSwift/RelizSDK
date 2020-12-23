//
//  RZControlledProtocol.swift
//  RZScreensKit
//
//  Created by Александр Сенин on 11.12.2020.
//

import Foundation


public protocol RZControlledNJProtocol{
    var screenController: RZScreenControllerProtocol? {get set}
}

extension RZControlledNJProtocol{
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
    private var key: UnsafeRawPointer? {
        return UnsafeRawPointer(bitPattern: 16)
    }
    
    var screenControllerInterfase: PresenterInterfase {
        if let key = key, let presenterInterfase = objc_getAssociatedObject(self, key) as? PresenterInterfase{
            return presenterInterfase
        }
        let presenterInterfase = PresenterInterfase()
        
        if let key = key{
            objc_setAssociatedObject(self, key, presenterInterfase, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
        return presenterInterfase
    }
    
    public mutating func setInstallableScreen(_ installableScreen: RZScreenControllerProtocol){
        self.screenController = installableScreen
    }
}


public protocol RZControlledProtocol: RZControlledNJProtocol{
    associatedtype Controller: RZScreenControllerProtocol
    var controller: Controller? { get }
}

extension RZControlledProtocol {
    public var controller: Controller?{ screenController as? Controller }
}
