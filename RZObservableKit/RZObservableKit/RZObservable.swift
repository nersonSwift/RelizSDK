//
//  RZObservable.swift
//  RZViewBuilder
//
//  Created by Александр Сенин on 22.12.2020.
//

import Foundation
import SwiftUI
import Combine

protocol RZObservableProtocol: class {
    var objectWillChange: ObservableObjectPublisher? {get set}
}

//MARK: - RZObservable Entities
//MARK: - UseType
public enum RZOUseType{
    case animate
    case noAnimate
    case useAnimate(_ animation: RZUIAnimation)
    case useDefaultAnimate
}

public class RZObserveAnchorObject{
    private weak var result: RZOResultProtocol?
    deinit {result?.remove()}
    init(_ result: RZOResultProtocol) { self.result = result }
}

public protocol RZOResultProtocol: class{
    var key: Int {get}
    func remove()
}
//MARK: - Result
public class RZOResult<Value>: RZOResultProtocol{
    private weak var rzObservable: RZObservable<Value>?
    public var key: Int
    public var anchorObject: RZObserveAnchorObject {RZObserveAnchorObject(self)}
    public var action: RZOAction<Value>
    
    public var value: Value? {
        set(value){
            guard let value = value else { return }
            rzObservable?.wrappedValue = value
        }
        get{
            rzObservable?.wrappedValue
        }
    }
    @discardableResult
    public func use(_ useType: RZOUseType = .animate) -> Self { rzObservable?.use(useType, key); return self }
    public func remove(){ rzObservable?.remove(key) }
    @discardableResult
    public func snapToObject(_ object: AnyObject) -> Self{
        Associated(object).set(anchorObject, .random, .OBJC_ASSOCIATION_RETAIN)
        return self
    }
    
    init(_ rzObservable: RZObservable<Value>, _ key: Int, _ action: RZOAction<Value>){
        self.rzObservable = rzObservable
        self.key = key
        self.action = action
    }
}
//MARK: - RZAnimationCompletion
public class RZAnimationCompletion{
    public var completion = {}
}

//MARK: - Action
public class RZOAction<Value>{
    public enum AUseType{
        case animate
        case noAnimate
        case useAnimate(_ animation: RZUIAnimation)
        case useDefaultAnimate(_ animation: RZUIAnimation)
    }
    
    public var closure: ((RZOActionData<Value>)->())?
    public var animation: RZUIAnimation?
    
    public func use(_ aUseType: AUseType = .animate, _ actionData: RZOActionData<Value>){
        var actionData = actionData
        actionData.animation = animation
        let aCompletion = actionData.animationCompletion
        switch aUseType{
        case .animate:
            var animation = self.animation
            if animation == nil, UIView.isAnimation{
                animation = .duration(0)
            }else if animation == nil, !UIView.isAnimation{
                closure?(actionData)
                aCompletion.completion()
                return
            }
            animation?.animate({ [weak self] in self?.closure?(actionData) }, {_ in aCompletion.completion()})
            
        case .noAnimate:
            closure?(actionData)
            aCompletion.completion()
            
        case .useAnimate(let animation):
            actionData.animation = animation
            animation.animate({[weak self] in self?.closure?(actionData) }, {_ in aCompletion.completion()})
            
        case .useDefaultAnimate(let animation):
            actionData.animation = self.animation ?? animation
            (self.animation ?? animation).animate({ [weak self] in self?.closure?(actionData) }, {_ in aCompletion.completion()})
        }
    }

    
    public init(_ animation: RZUIAnimation?, _ closure: @escaping (RZOActionData<Value>)->()) {
        self.animation = animation
        self.closure = closure
    }
}

//MARK: - ActionData
public struct RZOActionData<Value>{
    public var animation: RZUIAnimation?
    public var useType: RZOUseType
    public let animationCompletion = RZAnimationCompletion()
    
    public var old: Value
    public var new: Value
    
    public func completion(_ value: @escaping ()->()){
        animationCompletion.completion = value
    }
}

//MARK: - RZObservable
@propertyWrapper
public class RZObservable<Value>: NSObject, RZObservableProtocol {
    //MARK: - Property
    //MARK: - Internal
    var objectWillChange: ObservableObjectPublisher?
    var prepareAnimation: RZUIAnimation?
    var defaultAnimation: RZUIAnimation?
    var observeResults = [RZOResult<Value>]()
    
    var counter: Int = 1
    
    var value: Value {didSet{ objectWillChange?.send() }}
    
    //MARK: - Public
    public var projectedValue: RZObservable<Value> {return self}
    public var deInitAction = {}
    
    deinit {deInitAction()}
    public var wrappedValue: Value{
        set(wrappedValue){
            setValue(.animate, value: wrappedValue)
        }
        get{ value }
    }
    
    //MARK: - funcs
    //MARK: - Internal
    func use(_ useType: RZOUseType = .animate, _ key: Int, _ old: Value? = nil){
        guard let action = getAction(key) else { return }
        let actionData = RZOActionData(animation: nil, useType: useType, old: old ?? wrappedValue, new: wrappedValue)
        switch useType {
        case .animate:
            if let defaultAnimetion = defaultAnimation{
                action.use(.useDefaultAnimate(defaultAnimetion), actionData)
            }else{
                action.use(.animate, actionData)
            }
        case .noAnimate:
            action.use(.noAnimate, actionData)
        case .useAnimate(let animation):
            action.use(.useAnimate(animation), actionData)
        case .useDefaultAnimate:
            if let defaultAnimetion = defaultAnimation{
                action.use(.useAnimate(defaultAnimetion), actionData)
            }else{
                action.use(.animate, actionData)
            }
        }
    }
    
    func getAction(_ key: Int) -> RZOAction<Value>? { getResult(key)?.action }
    func getResult(_ key: Int) -> RZOResult<Value>? {
        guard let counter = getResultCounter(key) else { return nil }
        return observeResults[counter]
    }
    func getResultCounter(_ key: Int) -> Int?{
        for (i, value) in observeResults.enumerated() {
            if value.key == key { return i }
        }
        return nil
    }
    
    //MARK: - Public
    @discardableResult
    public func add(_ animation: RZUIAnimation? = nil, _ observeClosure: @escaping (RZOActionData<Value>)->()) -> RZOResult<Value>{
        var animation = animation
    
        if animation == nil, let prepareAnimetion = prepareAnimation{
            animation = prepareAnimetion
            self.prepareAnimation = nil
        }
        let result = RZOResult(self, counter, RZOAction(animation, observeClosure))
        observeResults.append(result)
        counter += 1
        return result
    }
    
    public func remove(_ key: Int){
        guard let counter = getResultCounter(key) else { return }
        observeResults.remove(at: counter)
    }
    
    public func setValue(_ useType: RZOUseType = .noAnimate, value: Value){
        let old = self.value
        self.value = value
        observeResults.forEach{ use(useType, $0.key, old) }
    }
    
    public func silentSet(_ value: Value){
        self.value = value
    }
    
    @discardableResult
    public func animation(_ animation: RZUIAnimation) -> Self{
        prepareAnimation = animation
        return self
    }
    
    //MARK: - inits
    public init(wrappedValue: Value, _ animation: RZUIAnimation){
        defaultAnimation = animation
        self.value = wrappedValue
    }
    public init(wrappedValue: Value){
        self.value = wrappedValue
    }
}

//MARK: - RZPublisherObservable
public class RZPublisherObservable<Value>: RZObservable<Value>{
    var binding: Binding<Value>?
    var anyCancellable: AnyCancellable?
    
    override public var wrappedValue: Value{
        set(wrappedValue){
            if let binding = binding{
                binding.wrappedValue = wrappedValue
            }else{
                super.wrappedValue = wrappedValue
            }
        }
        get{
            value
        }
    }
    
    func update(_ value: Value){
        setValue(.animate, value: value)
    }
    
    init(binding: Binding<Value>){
        super.init(wrappedValue: binding.wrappedValue)
        self.binding = binding
    }
}

//MARK: - Extensions
//MARK: - Switcher
extension RZObservable where Value: Hashable{
    public func switcher<SValue>(_ map: [Value: SValue]) -> RZObservable<SValue>?{ self ?> RZSwitch(map) }
}
extension RZObservable where Value == Int{
    public func switcher<SValue>(_ map: SValue...) -> RZObservable<SValue>?{ switcher(map) }
    public func switcher<SValue>(_ map: [SValue]) -> RZObservable<SValue>?{
        var mapD = [Value: SValue]()
        for (i, value) in map.enumerated(){
            mapD[i] = value
        }
        return self ?> RZSwitch(mapD)
    }
}
extension RZObservable where Value == Bool{
    public func switcher<SValue>(_ map: SValue...) -> RZObservable<SValue>?{ switcher(map) }
    public func switcher<SValue>(_ map: [SValue]) -> RZObservable<SValue>?{
        if map.count != 2 {return nil}
        var mapD = [Value: SValue]()
        mapD[true]  = map[0]
        mapD[false] = map[1]
        return self ?> RZSwitch(mapD)
    }
}

extension RZObservable{
    public func handler<SValue>(_ value: @escaping (RZOActionData<Value>)->(SValue)) -> RZObservable<SValue>?{
        let handler = RZObservable<SValue>(
            wrappedValue: value(
                RZOActionData(animation: nil, useType: .noAnimate, old: wrappedValue, new: wrappedValue)
            )
        )
        add { (data) in handler.wrappedValue = value(data) }
        return handler
    }
}

//MARK: - UITextField / UITextView
extension RZObservable where Value == String{
    public func setTextObserve(_ textField: UITextField){
        textField.addAction(for: .editingChanged) {[weak self, weak textField] in
            if self?.wrappedValue != textField?.text{
                self?.wrappedValue = textField?.text ?? ""
            }
        }
    }
    
    public func setTextObserve(_ textView: UITextView){
        RZTextViewDelegate.setDelegate(textView, self)
    }
}




