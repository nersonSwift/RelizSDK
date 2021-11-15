//
//  RZEvent.swift
//  RelizKit
//
//  Created by Александр Сенин on 09.11.2020.
//

import Foundation


public class RZAnyEvent{
    fileprivate var events = [RZAnyEvent]()
    fileprivate var _sendKey: String = ""
    
    fileprivate var _name: String?
    fileprivate var _value: Any?
    
    fileprivate var _sendDelegate: EventSendDelegate?
    
    init(){}
    
    init(_ sendDelegate: EventSendDelegate? = nil, _ events: [RZAnyEvent] = []){
        self._sendDelegate = sendDelegate
        self.events = events
    }
    
    convenience init(_ sendDelegate: EventSendDelegate? = nil, @EventBuilder _ events: ()->[RZAnyEvent]){
        self.init(sendDelegate, events())
    }
    
    init(_ key: String = "", _ sendDelegate: EventSendDelegate? = nil){
        self._sendDelegate = sendDelegate
        _sendKey = key
    }
    
    convenience init(_ key: Bool, _ sendDelegate: EventSendDelegate? = nil){
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
    public func add(_ value: RZAnyEvent) -> Self{
        events.append(value)
        return self
    }
    
    @discardableResult
    public func add(_ value: [RZAnyEvent]) -> Self{
        events += value
        return self
    }
    
    @discardableResult
    public func add(@EventBuilder _ value: ()->[RZAnyEvent]) -> Self{
        add(value())
        return self
    }
    
    @discardableResult
    public func set(_ value: [RZAnyEvent]) -> Self {
        events = value
        return self
    }
    
    @discardableResult
    public func set(@EventBuilder _ value: ()->[RZAnyEvent]) -> Self{
        set(value())
        return self
    }
    
    public subscript(index: Int) -> RZAnyEvent?{
        if index <= events.count { return nil }
        return events[index]
    }
    
    public subscript(index: String) -> [RZAnyEvent]{
        var events = [RZAnyEvent]()
        self.events.forEach{
            if $0._sendKey == index { events.append($0) }
        }
        return events
    }
    
    public subscript(index: Bool) -> [RZAnyEvent]{
        return self["\(index)"]
    }
    
    public func send(_ key: String? = nil){
        if events.count > 0{
            events.forEach{
                $0._name = $0._name ?? _name
                $0._value = $0._value ?? _value
                $0._sendDelegate = $0._sendDelegate ?? _sendDelegate
                $0.send(key)
            }
        }else if let key = key{
            if _sendKey == key{
                sendEvent()
            }
        }else{
            sendEvent()
        }
    }
    
    public func send(_ key: Bool){
        send("\(key)")
    }
    
    private func sendEvent(){
        _sendDelegate?.send(_name, _value)
    }
    
    public func copy() -> RZAnyEvent{
        RZAnyEvent(_sendDelegate, events.map{$0.copy()}).sendKey(_sendKey).name(_name).value(_value)
    }
}

open class EventSendDelegate {
    open func send(_ name: String?, _ value: Any?) {}
    public init(){}
}

@resultBuilder public struct EventBuilder{
    public static func buildBlock(_ atrs: RZAnyEvent...) -> [RZAnyEvent] {
        return atrs
    }
}


public class RZEvent<SD: EventSendDelegate>: RZAnyEvent{
    public override init() where SD == EventSendDelegate{
        super.init()
    }
    
    public init(_ sendDelegate: SD? = nil, _ events: [RZAnyEvent] = []){
        super.init(sendDelegate, events)
    }
    
    public convenience init(_ sendDelegate: SD? = nil, @EventBuilder _ events: ()->[RZAnyEvent]){
        self.init(sendDelegate, events())
    }
    
    public init(_ key: String = "", _ sendDelegate: SD? = nil){
        super.init(key, sendDelegate)
    }
    
    public convenience init(_ key: Bool, _ sendDelegate: SD? = nil){
        self.init("\(key)", sendDelegate)
    }
}
