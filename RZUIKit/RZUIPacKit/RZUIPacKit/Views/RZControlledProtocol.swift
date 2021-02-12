//
//  RZControlledProtocol.swift
//  RZScreensKit
//
//  Created by Александр Сенин on 11.12.2020.
//

import Foundation


public protocol RZControlledNJProtocol{
    var uiPacController: RZUIPacControllerNJProtocol? {get set}
}

extension RZControlledNJProtocol{
    public var uiPacController: RZUIPacControllerNJProtocol?{
        set(uiPacC){
            if let key = key{
                objc_setAssociatedObject(self, key, uiPacC, .OBJC_ASSOCIATION_ASSIGN)
            }
        }
        get{
            if let key = key, let uiPacController = objc_getAssociatedObject(self, key) as? RZUIPacControllerNJProtocol{
                return uiPacController
            }
            return nil
        }
    }
    private var key: UnsafeRawPointer? {
        return UnsafeRawPointer(bitPattern: "Controller".hashValue)
    }
    
    public mutating func setUIPacC(_ uiPacC: RZUIPacControllerNJProtocol){
        self.uiPacController = uiPacC
    }
}


public protocol RZControlledProtocol: RZControlledNJProtocol{
    associatedtype Controller: RZUIPacControllerRouteredProtocol
    var controller: Controller? { get }
}
extension RZControlledProtocol{
    public var controller: Controller?{ uiPacController as? Controller }
    public var router: Controller.UIPacRouter! { controller?.router }
}
