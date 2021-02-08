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
    public var view: UIView{
        uiPacController?.view ?? UIView()
    }
    
    public var uiPacController: RZUIPacControllerNJProtocol?{
        set(uiPacC){
            uiPacControllerInterfase.uiPacC = uiPacC
        }
        get{
            uiPacControllerInterfase.uiPacC
        }
    }
    private var key: UnsafeRawPointer? {
        return UnsafeRawPointer(bitPattern: "\(Self.self)".hashValue)
    }
    
    var uiPacControllerInterfase: RZUIPacArchitectInterfase {
        if let key = key, let architectInterfase = objc_getAssociatedObject(self, key) as? RZUIPacArchitectInterfase{
            return architectInterfase
        }
        let architectInterfase = RZUIPacArchitectInterfase()
        
        if let key = key{
            objc_setAssociatedObject(self, key, architectInterfase, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
        return architectInterfase
    }
    
    public mutating func setUIPacC(_ uiPacC: RZUIPacControllerNJProtocol){
        self.uiPacController = uiPacC
    }
}


public protocol RZControlledProtocol: RZControlledNJProtocol{
    associatedtype Controller: RZUIPacControllerNJProtocol
    var controller: Controller? { get }
}
extension RZControlledProtocol where Controller: RZUIPacControllerModeledProtocol{
    public var model: Controller.UIPacModel! { controller?.model }
}

extension RZControlledProtocol {
    public var controller: Controller?{ uiPacController as? Controller }
}
