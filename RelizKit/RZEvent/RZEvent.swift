//
//  RZEvent.swift
//  RelizKit
//
//  Created by Александр Сенин on 09.11.2020.
//

import Foundation

public class RZEvent{
    private var events = [RZEvent]()
    private var _sendKey: String = ""
    
    private var _name: String?
    private var _value: Any?
    
    private var _sendDelegate: EventSendDelegate?
    
    public init(){}
    
    public init(_ sendDelegate: EventSendDelegate? = nil, _ events: [RZEvent] = []){
        self._sendDelegate = sendDelegate
        self.events = events
    }
    
    public convenience init(_ sendDelegate: EventSendDelegate? = nil, @EventBuilder _ events: ()->[RZEvent]){
        self.init(sendDelegate, events())
    }
    
    public init(_ key: String = "", _ sendDelegate: EventSendDelegate? = nil){
        self._sendDelegate = sendDelegate
        _sendKey = key
    }
    
    public convenience init(_ key: Bool, _ sendDelegate: EventSendDelegate? = nil){
        self.init("\(key)", sendDelegate)
    }
    
    @discardableResult
    public func delegate(_ value: EventSendDelegate) -> Self{
        _sendDelegate = value
        return self
    }
    
    @discardableResult
    public func name(_ value: String?) -> Self{
        _name = value
        return self
    }
    
    @discardableResult
    public func value(_ value: Any?) -> Self{
        _value = value
        return self
    }
    
    @discardableResult
    public func sendKey(_ value: String) -> Self {
        _sendKey = value
        return self
    }
    
    @discardableResult
    public func sendKey(_ value: Bool) -> Self {
        _sendKey = "\(value)"
        return self
    }
    
    @discardableResult
    public func add(_ value: RZEvent) -> Self{
        events.append(value)
        return self
    }
    
    @discardableResult
    public func add(_ value: [RZEvent]) -> Self{
        events += value
        return self
    }
    
    @discardableResult
    public func add(@EventBuilder _ value: ()->[RZEvent]) -> Self{
        add(value())
        return self
    }
    
    @discardableResult
    public func set(_ value: [RZEvent]) -> Self {
        events = value
        return self
    }
    
    @discardableResult
    public func set(@EventBuilder _ value: ()->[RZEvent]) -> Self{
        set(value())
        return self
    }
    
    public subscript(index: Int) -> RZEvent?{
        if index <= events.count { return nil }
        return events[index]
    }
    
    public subscript(index: String) -> [RZEvent]{
        var events = [RZEvent]()
        self.events.forEach{
            if $0._sendKey == index { events.append($0) }
        }
        return events
    }
    
    public subscript(index: Bool) -> [RZEvent]{
        return self["\(index)"]
    }
    
    public func send(_ key: String? = nil){
        if events.count > 0{
            events.forEach{
                $0._name = $0._name ?? _name
                $0._value = $0._value ?? _value
                $0._sendDelegate = $0._sendDelegate ?? _sendDelegate
            }
        }else if let key = key{
            if _sendKey == key{
                return sendEvent()
            }
        }else{
            return sendEvent()
        }
    }
    
    public func send(_ key: Bool){
        send("\(key)")
    }
    
    private func sendEvent(){
        _sendDelegate?.send(_name, _value)
    }
    
    public func copy() -> RZEvent{
        RZEvent(_sendDelegate, events.map{$0.copy()}).sendKey(_sendKey).name(_name).value(_value)
    }
}

public class EventSendDelegate {
    func send(_ name: String?, _ value: Any?) {}
}

@_functionBuilder struct EventBuilder{
    static func buildBlock(_ atrs: RZEvent...) -> [RZEvent] {
        return atrs
    }
}
