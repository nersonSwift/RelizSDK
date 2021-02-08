//
//  LinesController.swift
//  ConnectAPI
//
//  Created by Александр Сенин on 24.08.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import Foundation

public struct RZUIPacLines: Hashable {
    public var id: String
    
    public init(_ id: String){
        self.id = id
    }
}

public class RZLineController{
    fileprivate static var lins: [String: ()->RZLine?] = [:]
    static var rootLine: String = ""
    fileprivate static var anchor = RZLineController()
    
    public static func getLine(_ id: RZUIPacLines) -> RZLine? { getLine(id.id) }
    public static func getLine(_ id: String) -> RZLine? { lins[id]?() }
    
    public static func getControllerInLine(_ id: RZUIPacLines) -> RZUIPacControllerNJProtocol? { getLine(id)?.controller }
    public static func getControllerInLine(_ id: String) -> RZUIPacControllerNJProtocol? { getLine(id)?.controller }
    
    public static func setControllerInLine(_ id: RZUIPacLines, _ controller: RZUIPacControllerNJProtocol?){
        setControllerInLine(id.id, controller)
    }
    public static func setControllerInLine(_ id: String, _ controller: RZUIPacControllerNJProtocol?){ getLine(id)?.controller = controller }
    
    public static func addLines(_ lines: [RZLine]){ lines.forEach{ addLine($0) } }
    public static func addLine(_ line: RZLine){ lins[line.id] = { [weak line] in return line } }
    public static func addLine(id: RZUIPacLines,
                               controller: RZUIPacControllerNJProtocol? = nil,
                               anchor: AnyObject? = nil,
                               key: UnsafeRawPointer? = nil
    ){
        addLine(id: id.id, controller: controller, anchor: anchor, key: key)
    }
    public static func addLine(id: String,
                               controller: RZUIPacControllerNJProtocol? = nil,
                               anchor: AnyObject? = nil,
                               key: UnsafeRawPointer? = nil){
        addLine(RZLine(id: id, controller: controller, anchor: anchor, key: key))
    }
    
    
    public static func removeLine(id: RZUIPacLines){ removeLine(id: id.id) }
    public static func removeLine(id: String){
        let line = lins[id]?()
        line?.removeAssociated()
        lins[id] = nil
    }
    
    public static func migrateController(at: RZUIPacLines, to: RZUIPacLines){ migrateController(at: at.id, to: to.id) }
    public static func migrateController(at: String, to: String){
        let atLine = getLine(at)
        let toLine = getLine(to)
        atLine?.controller?.uiPacLine = nil
        toLine?.controller = atLine?.controller
        atLine?.controller = nil
    }
    
    public static func setRootLine(id: String){ rootLine = id }
    public static func setRootLine(id: RZUIPacLines){ rootLine = id.id }
}

public class RZLine{
    public var id: String = ""
    public var controller: RZUIPacControllerNJProtocol?{
        didSet(old){
            old?.uiPacLine = nil
            if let line = controller?.uiPacLine, id != line{
                RZLineController.migrateController(at: line, to: id)
            }else{
                controller?.uiPacLine = id
            }
        }
    }
    
    private weak var anchor: AnyObject?
    private var key: UnsafeRawPointer?
    
    public convenience init(id: RZUIPacLines, controller: RZUIPacControllerNJProtocol? = nil, anchor: AnyObject? = nil, key: UnsafeRawPointer? = nil){
        self.init(id: id.id, controller: controller, anchor: anchor, key: key)
    }
    
    public init(id: String, controller: RZUIPacControllerNJProtocol? = nil, anchor: AnyObject? = nil, key: UnsafeRawPointer? = nil){
        self.id = id
        self.controller = controller
        self.controller?.uiPacLine = id
        associatedLine(anchor, key: key)
    }
    
    public func associatedLine(_ anchor: AnyObject? = nil, key: UnsafeRawPointer? = nil){
        removeAssociated()
        
        let anchor = anchor ?? RZLineController.anchor
        var key = key
        
        if key == nil{
            var counter: UInt = UInt(arc4random())
            var testObj: Any?
            repeat{
                if let keyL = UnsafeRawPointer(bitPattern: counter){
                    key = keyL
                    testObj = objc_getAssociatedObject(anchor, keyL)
                }
                counter = UInt(arc4random())
            }while testObj != nil
        }
        
        if let key = key {
            self.key = key
            self.anchor = anchor
            objc_setAssociatedObject(anchor, key, self, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public func removeAssociated(){
        if let anchor = self.anchor, let key = self.key{
            objc_setAssociatedObject(anchor, key, nil, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}


